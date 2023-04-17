from flask_login import UserMixin
from . import db


class User(db.Model, UserMixin):
    __table__ = db.Model.metadata.tables['users']

    def __repr__(self):
        return self.DISTRICT