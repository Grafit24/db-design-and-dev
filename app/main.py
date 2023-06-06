from datetime import datetime as dt
from sqlalchemy import desc
from flask import Blueprint, render_template, url_for, request, redirect, jsonify
from flask_login import login_required, current_user
from . import db
from .models import *

main = Blueprint('main', __name__)

@main.route('/')
def index():
    return render_template("index.html")


@main.route('/profile')
@login_required
def profile():
    return render_template("profile.html", login=current_user.login)


@main.route('/admin')
@login_required
def admin():
    if not current_user.admin:
        redirect(url_for("main.profile"))
    query = """
    SELECT servers_configuration.server_conf_id AS config_id, servers.server_id AS server_id, cpu, gpu, ram_mb, 
	ssd_storage_mb, os, price, server_on, 
	MAX(closed_on) > NOW() AS is_busy, COUNT(order_id) AS order_counter FROM
        servers_configuration 
        LEFT JOIN servers ON servers.server_conf_id = servers_configuration.server_conf_id
        LEFT JOIN orders_servers ON servers.server_id = orders_servers.server_id
		GROUP BY servers_configuration.server_conf_id, servers.server_id;
    """
    results = {}
    query_result = db.engine.execute(query).fetchall()
    for row in query_result:
        if results.get(row["config_id"], False):
            results[row["config_id"]]["servers"].append({
                        "is_busy": row["is_busy"],
                        "server_id": row["server_id"],
                        "server_on": row["server_on"]
                    })
        else:
            results[row["config_id"]] = {
                "server_conf_id": row["config_id"],
                "cpu": row["cpu"],
                "gpu": row["gpu"],
                "ram_mb": row["ram_mb"],
                "ssd_storage_mb": row["ssd_storage_mb"],
                "os": row["os"],
                "price": row["price"],
                "order_counter": row["order_counter"],
                "servers": [] if row["server_id"] is None else [{
                        "is_busy": row["is_busy"],
                        "server_id": row["server_id"],
                        "server_on": row["server_on"]
                    }],
            }
    return render_template("admin.html", results=list(results.values()))


@main.route("/admin/create", methods=["POST"])
@login_required
def create_config():
    if not current_user.admin:
        return redirect(url_for("main.profile"))
    cpu = request.form.get("cpu", type=str)
    gpu = request.form.get("gpu", type=str)
    ram_mb = request.form.get("ram", type=int)
    ssd_storage_mb = request.form.get("ssd", type=int)
    os = request.form.get("os", type=str)
    price = request.form.get("price", type=int)
    new_server_config = ServerConfig(
        cpu=cpu, 
        gpu=gpu, 
        ram_mb=ram_mb, 
        ssd_storage_mb=ssd_storage_mb, 
        os=os, 
        price=price
    )
    db.session.add(new_server_config)
    db.session.commit()
    return redirect(url_for("main.admin"))


@main.route('/workspaces')
@login_required
def workspaces():
    query = """
    SELECT workspaces.id AS id, workspaces.workspace_name AS name, workspaces_users.is_owner AS is_owner 
        FROM workspaces INNER JOIN workspaces_users ON workspaces.id = workspaces_users.workspace_id
        WHERE workspaces_users.user_id=%s;
    """
    login = current_user.get_id()
    result = db.engine.execute(query, login).fetchall()
    return render_template("workspaces.html", query_result=result)


@main.route("/workspaces/create", methods=["POST"])
@login_required
def create_workspace():
    workspace_name = request.form.get('workspace_name')
    workspace = Workspaces(workspace_name=workspace_name)

    db.session.add(workspace)
    db.session.flush()
    db.session.refresh(workspace)

    connect_admin = WorkspacesUsers(
        workspace_id=workspace.id, 
        user_id=current_user.get_id(), 
        is_owner=True
    )

    db.session.add(connect_admin)
    db.session.commit()

    return redirect(url_for("main.workspaces"))


@main.route("/workspaces/workspace-<int:workspace_id>-<string:workspace_name>")
@login_required
def view_workspace(workspace_id, workspace_name):
    query = """
    SELECT *
    FROM workspaces_users 
        INNER JOIN orders ON workspaces_users.id = orders.workspaces_users_id
        INNER JOIN orders_servers ON orders.order_id = orders_servers.order_id
        INNER JOIN servers ON orders_servers.server_id = servers.server_id
        INNER JOIN servers_configuration ON servers_configuration.server_conf_id = servers.server_conf_id
    WHERE workspaces_users.workspace_id=%s ORDER BY opened_on DESC;
    """
    result = db.engine.execute(query, workspace_id).fetchall()
    return render_template(
        "workspace.html", query_result=result, 
        workspace_name=workspace_name, workspace_id=workspace_id
    )


@main.route("/workspaces/workspace-<int:workspace_id>-<string:workspace_name>/update", methods=["POST"])
@login_required
def update_workspace(workspace_id, workspace_name):
    new_workspace_name = request.form.get("workspace_name")
    query = "UPDATE workspaces SET workspace_name=%s WHERE id=%s;"
    db.engine.execute(query, new_workspace_name, workspace_id)
    return redirect(url_for("main.view_workspace", workspace_id=workspace_id, workspace_name=new_workspace_name))


@main.route("/workspaces/workspace-<int:workspace_id>-<string:workspace_name>/delete", methods=["POST"])
@login_required
def delete_workspace(workspace_id, workspace_name):
    query = "DELETE FROM workspaces WHERE id=%s;"
    db.engine.execute(query, workspace_id)
    return redirect(url_for("main.workspaces"))


@main.route("/workspaces/workspace-<int:workspace_id>-<string:workspace_name>/buy", methods=["POST"])
@login_required
def buy_server(workspace_id, workspace_name):
    server_conf_id = request.form.getlist("server_choice")[0]
    close_date = request.form.get("close_datetime")
    close_date = dt.strptime(close_date, '%Y-%m-%d')
    price = ServerConfig.query.filter_by(server_conf_id=server_conf_id).first().price

    full_price = (close_date - dt.now()).days * price

    workspaces_users_id = WorkspacesUsers.query.filter_by(workspace_id=workspace_id, user_id=current_user.id).first().id

    order = Order(price_rub=full_price, workspaces_users_id=workspaces_users_id)
    db.session.add(order)
    db.session.flush()
    db.session.refresh(order)

    server_id = Server.query.filter_by(server_conf_id=server_conf_id, server_on=True).first().server_id
    order_server = OrdersServers(order_id=order.order_id, server_id=server_id, closed_on=close_date)
    db.session.add(order_server)
    db.session.commit()
    return redirect(url_for("main.view_workspace", workspace_id=workspace_id, workspace_name=workspace_name))

@main.route("/get-servers")
@login_required
def get_servers():
    query = """
    SELECT * FROM (
        SELECT servers_configuration.server_conf_id AS server_conf_id, cpu, gpu, ram_mb, ssd_storage_mb, os, price, 
				CASE WHEN MAX(CASE WHEN closed_on IS NULL THEN 1 ELSE 0 END) = 0 THEN MAX(closed_on) END as closed_on 
                FROM servers_configuration 
                LEFT JOIN servers ON servers.server_conf_id = servers_configuration.server_conf_id
                LEFT JOIN orders_servers ON orders_servers.server_id = servers.server_id
                WHERE servers.server_on
                GROUP BY servers_configuration.server_conf_id
    ) AS servers_closed_on WHERE closed_on < NOW() OR closed_on IS NULL;
    """
    results = db.engine.execute(query).fetchall()
    results = [dict(res) for res in results]
    return jsonify(results)


@main.route("/admin/config-<int:config_id>")
@login_required
def get_config(config_id):
    if not current_user.admin:
        return redirect(url_for("main.profile"))
    query = """
    SELECT servers_configuration.server_conf_id AS config_id, servers.server_id AS server_id, cpu, gpu, ram_mb, 
	ssd_storage_mb, os, price, server_on, 
	MAX(closed_on) > NOW() AS is_busy, COUNT(order_id) AS order_counter FROM
        servers_configuration 
        LEFT JOIN servers ON servers.server_conf_id = servers_configuration.server_conf_id
        LEFT JOIN orders_servers ON servers.server_id = orders_servers.server_id
        WHERE servers_configuration.server_conf_id = %s
		GROUP BY servers_configuration.server_conf_id, servers.server_id;
    """
    query_result = db.engine.execute(query, config_id).fetchall()
    results = {}
    for row in query_result:
        if results.get(row["config_id"], False):
            results[row["config_id"]]["servers"].append({
                        "is_busy": row["is_busy"],
                        "server_id": row["server_id"],
                        "server_on": row["server_on"]
                    })
        else:
            results[row["config_id"]] = {
                "server_conf_id": row["config_id"],
                "cpu": row["cpu"],
                "gpu": row["gpu"],
                "ram_mb": row["ram_mb"],
                "ssd_storage_mb": row["ssd_storage_mb"],
                "os": row["os"],
                "price": row["price"],
                "order_counter": row["order_counter"],
                "servers": [] if row["server_id"] is None else [{
                        "is_busy": row["is_busy"],
                        "server_id": row["server_id"],
                        "server_on": row["server_on"]
                    }],
            }
    return render_template("config_view.html", result=results[row["config_id"]], config_id=config_id)


@main.route("/admin/config-<int:config_id>/edit", methods=["POST"])
@login_required
def edit_config(config_id):
    if not current_user.admin:
        return redirect(url_for("main.profile"))
    ServerConfig.query.filter_by(server_conf_id=config_id).update({
        "cpu": request.form.get("cpu"),
        "gpu": request.form.get("gpu"),
        "os": request.form.get("os"),
        "price": request.form.get("price", float),
        "ssd_storage_mb": request.form.get("ssd", int),
        "ram_mb": request.form.get("ram", int),
    })
    db.session.commit()
    return redirect(url_for("main.get_config", config_id=config_id))


@main.route("/admin/config-<int:config_id>/delete", methods=["POST"])
@login_required
def delete_config(config_id):
    if not current_user.admin:
        return redirect(url_for("main.profile"))
    config = ServerConfig.query.filter_by(server_conf_id=config_id).first()
    db.session.delete(config)
    db.session.commit()
    return redirect(url_for("main.admin"))


@main.route("/admin/config-<int:config_id>/create-server", methods=["POST"])
@login_required
def create_server(config_id):
    if not current_user.admin:
        return redirect(url_for("main.profile"))
    server = Server(server_conf_id=config_id, server_on=True)
    db.session.add(server)
    db.session.commit()
    return redirect(url_for("main.get_config", config_id=config_id))


@main.route("/admin/server-update", methods=["DELETE"])
@login_required
def delete_server():
    if not current_user.admin:
        return redirect(url_for("main.profile"))
    server_id = request.json.get("server_id")
    server = Server.query.filter_by(server_id=server_id).first()
    db.session.delete(server)
    db.session.commit()
    return ('', 204)


@main.route("/admin/server-update", methods=["PUT"])
@login_required
def update_server():
    if not current_user.admin:
        return redirect(url_for("main.profile"))
    server_id = request.json.get("server_id")
    server_on = request.json.get("server_on")
    server = Server.query.filter_by(server_id=server_id).update({
        "server_on": (not server_on),
    })
    db.session.commit()
    return ('', 204)