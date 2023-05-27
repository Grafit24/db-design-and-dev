from flask import Blueprint, render_template, url_for, request, redirect
from flask_login import login_required, current_user
from . import db
from .models import Workspaces, WorkspacesUsers

main = Blueprint('main', __name__)

@main.route('/')
def index():
    return render_template("index.html")

@main.route('/profile')
@login_required
def profile():
    return render_template("profile.html", login=current_user.login)

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
    servers_id = request.form.get("server_id")
    open = request.form.get("open_datetime")
    close = request.form.get("close_datetime")
    ...

@main.route("/get-servers")
@login_required
def get_servers():
    query = """
    SELECT DISTINCT servers.server_conf_id AS server_conf_id, cpu, gpu, ram_mb, ssd_storage_mb, os FROM 
        servers_configuration INNER JOIN servers 
        ON servers.server_conf_id = servers_configuration.server_conf_id
        WHERE servers.closed_on < NOW();
    """
    results = db.engine.execute(query).fetchall()
    return render_template("servers-template.html", results=results)
