from flask import Flask, render_template, flash, redirect, url_for, session, logging, request
from flask_mysqldb import MySQL
from passlib.hash import sha256_crypt
import Pages
from Forms import RegisterForm, LoginForm

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
    return Pages.home()

@app.route("/register", methods=["GET", "POST"])
def register():
    form = RegisterForm(request.form)
    return Pages.register(form = form, RequestMethod = request.method, dbObject = mysql)

@app.route("/login", methods=["GET", "POST"])
def login():
    form = LoginForm(request.form)
    return Pages.Login(form = form, RequestMethod = request.method, dbObject = mysql)

@app.route("/logout")
def logoout():
    session.clear()
    flash("Info : Log Out complate..", "info")
    return redirect(url_for("index"))

if __name__ == '__main__':
    app.run(debug=True)
