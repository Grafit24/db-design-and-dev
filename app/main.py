from flask import Blueprint, render_template
from flask_login import login_required, current_user
from . import db

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
        FROM workspaces INNER JOIN workspaces_users INNER JOIN users 
        ON workspaces_users.user_id = users.id ON workspaces.id = workspaces_users.id
        WHERE users.login=%s;
    """
    login = current_user.login
    result = db.engine.execute(query, login).fetchall()
    return render_template("workspaces.html", query_result=result)

@main.route("/workspaces-create")
@login_required
def create_workspace():
    ...
