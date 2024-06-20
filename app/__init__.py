from flask import Flask
from .extentions import db,api,cor,login_manager
from .resources import ns
from .blueprints.home import home
def create_app():
    app=Flask(__name__)
    app.register_blueprint(home)
    api.init_app(app)
    cor.init_app(app)
    app.config["CORS_HEADERS"] = "Content-Type"
    app.config['SQLALCHEMY_DATABASE_URI']="sqlite:///db.sqlite3"
    db.init_app(app)
    api.add_namespace(ns)
    app.config.from_prefixed_env('.env')
    login_manager.init_app(app)
    app.secret_key = b'_5#y2L"F4Q8z\n\xec]/'
    return app