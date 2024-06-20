from flask_sqlalchemy import SQLAlchemy
from flask_restx import Api
from flask_cors import CORS
from flask_login import LoginManager

api =Api(doc='/doc')
db= SQLAlchemy()
cor=CORS()
login_manager = LoginManager()