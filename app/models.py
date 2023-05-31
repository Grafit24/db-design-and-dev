from flask_login import UserMixin
from . import db


class User(db.Model, UserMixin):
    __table__ = db.Model.metadata.tables['users']

    def __repr__(self):
        return self.DISTRICT


class Workspaces(db.Model):
    __table__ = db.Model.metadata.tables['workspaces']

    def __repr__(self):
        return self.DISTRICT


class WorkspacesUsers(db.Model):
    """Connection between workspace 1-M users."""
    __table__ = db.Model.metadata.tables['workspaces_users']

    def __repr__(self):
        return self.DISTRICT


class Order(db.Model):
    __table__ = db.Model.metadata.tables['orders']

    def __repr__(self):
        return self.DISTRICT


class OrdersServers(db.Model):
    __table__ = db.Model.metadata.tables['orders_servers']

    def __repr__(self):
        return self.DISTRICT

class Server(db.Model):
    __table__ = db.Model.metadata.tables['servers']

    def __repr__(self):
        return self.DISTRICT


class ServerConfig(db.Model):
    __table__ = db.Model.metadata.tables['servers_configuration']

    def __repr__(self):
        return self.DISTRICT