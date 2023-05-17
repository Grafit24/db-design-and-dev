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


@main.route("/workspaces/update", methods=["PUT"])
@login_required
def update_workspace():
    ...


@main.route("/workspaces/delete", methods=["DELETE"])
@login_required
def delete_workspace():
    ...
