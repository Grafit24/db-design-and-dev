from flask_login import UserMixin
from . import db


class User(db.Model, UserMixin):
    __table__ = db.Model.metadata.tables['users']

    def __repr__(self):
        return self.DISTRICT
    
class Workspaces(db.Model, UserMixin):
    __table__ = db.Model.metadata.tables['workspaces']

    def __repr__(self):
        return self.DISTRICT

class WorkspacesUsers(db.Model, UserMixin):
    """Connection between workspace 1-M users."""
    __table__ = db.Model.metadata.tables['workspaces_users']

    def __repr__(self):
        return self.DISTRICT