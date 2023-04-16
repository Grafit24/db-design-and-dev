from . import db


class User(db.Model):
    __table__ = db.Model.metadata.tables['users']

    def __repr__(self):
        return self.DISTRICT