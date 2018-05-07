from functools import wraps
from flask import Flask, render_template, flash, redirect, url_for, session, logging, request
from flask_mysqldb import MySQL
from passlib.hash import sha256_crypt
from Auth import Auth
import Blog
import Dashboard
import Posts
from Forms import RegisterForm, LoginForm, PostCreateForm, PostEditForm

app = Flask(__name__)
app.secret_key = sha256_crypt.encrypt("BlogApp")

app.config["MYSQL_HOST"] = "localhost"
app.config["MYSQL_USER"] = "root"
app.config["MYSQL_PASSWORD"] = ""
app.config["MYSQL_DB"] = "flaskblog"
app.config['MYSQL_CURSORCLASS'] = "DictCursor"

mysql = MySQL(app)


@app.route("/")
def home():
    return Blog.home()


@app.route("/register", methods=["GET", "POST"])
def register():
    form = RegisterForm(request.form)
    return Auth.register(form=form, RequestMethod=request.method, dbObject=mysql)


@app.route("/login", methods=["GET", "POST"])
def login():
    form = LoginForm(request.form)
    return Auth.Login(form=form, RequestMethod=request.method, dbObject=mysql)


@app.route("/logout")
def logoout():
    return Auth.Logout()


@app.route("/dashboard")
@Auth.isLogginRequired
def dashboard():
    return Dashboard.home(mysql)


@app.route("/posts")
def posts():
    return Posts.posts(dbObject=mysql)


@app.route("/post/<string:id>")
def detail(id):
    return Posts.detail(id=id, dbObject=mysql)


@app.route("/posts/new", methods=["GET", "POST"])
@Auth.isLogginRequired
def PostCreate():
    form = PostCreateForm(request.form)
    return Posts.PostCreate(method=request.method, form=form, dbObject=mysql)


@app.route("/post/edit/<string:id>", methods=["GET", "POST"])
@Auth.isLogginRequired
def editPost(id):
    if request.form:
        form = PostEditForm(request.form)
    else:
        form = PostEditForm()

    return Posts.postEdit(id=id, method=request.method, form=form, dbObject=mysql)


@app.route("/post/delete/<string:id>")
@Auth.isLogginRequired
def deletePost(id):
    return Posts.postDelete(id=id, dbObject=mysql)


if __name__ == '__main__':
    app.run(debug=True)
