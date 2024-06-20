from flask import Blueprint, jsonify, render_template, redirect, url_for, request
from flask_login import current_user, login_required,login_user,logout_user
from app.models import User
from app.extentions import db
# Create a Blueprint for your routes
home = Blueprint('home', __name__)


@home.route('/')
def index():
    return render_template('index.html')


@home.route('/logout')
def lgout():
    if current_user.is_authenticated:
        logout_user()
    return redirect(url_for('home.index'))

@home.route('/login', methods=['GET', 'POST'])
def log():
    if not current_user.is_authenticated:
        if request.method == 'GET':
            return render_template('login.html')
        else:
            username = request.form.get('username')
            password = request.form.get('password')
            user= User.query.filter_by(username=username,password=password).first()
            if user:
                login_user(user)
                return redirect(url_for('home.index'))
            else:
                return render_template('login.html',login_error=True)
    else:
        return redirect(url_for('home.index'))


@home.route('/register', methods=['GET', 'POST'])
def regis():
    if request.method=='POST':
        user = User(**request.form)
        db.session.add(user)
        db.session.commit()
        login_user(user)
        return redirect(url_for('home.index'))

    return render_template('login copy.html')