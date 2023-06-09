from os import environ, path
from dotenv import load_dotenv

basedir = path.abspath(path.dirname(__file__))
if path.exists(path.join(basedir, '.env')):
    load_dotenv(path.join(basedir, '.env'))

class Config:
    TESTING = True
    DEBUG = True
    FLASK_ENV = 'development'
    SECRET_KEY = environ.get('SECRET_KEY')

    SQLALCHEMY_DATABASE_URI = environ.get('SQLALCHEMY_DATABASE_URI')
    SQLALCHEMY_TRACK_MODIFICATIONS = False