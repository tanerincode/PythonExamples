from flask import Flask, render_template, flash, redirect, url_for, session, logging, request
from flask_mysqldb import MySQL
from wtforms import Form, StringField, TextAreaField, PasswordField, validators
from passlib.hash import sha256_crypt



# user register form
class RegisterForm(Form):
    name = StringField("Name Surname :", validators=[validators.length(min = 4, max = 25 )])
    username = StringField("Username :", validators=[validators.length(min = 5, max = 35 )])
    email = StringField("E-Mail :", validators=[validators.Email(message = "E-Mail Failed !")])
    password = PasswordField("Password :", validators=[
        validators.DataRequired(message = "Password is required !"),
        validators.EqualTo(fieldname = "confirm_password", message = "Passwords not matched !")
    ])
    confirm_password = PasswordField("Confirm Password :")














app = Flask(__name__)
app.secret_key = "BlogApp"

app.config["MYSQL_HOS"] = "localhost"
app.config["MYSQL_USER"] = "root"
app.config["MYSQL_PASSWORD"] = ""
app.config["MYSQL_DB"] = "flaskblog"
app.config['MYSQL_CURSORCLASS'] = "DictCursor"

mysql = MySQL(app)



@app.route('/')
def index():
    return render_template("index.html")


@app.route("/about")
def about():
    return render_template("about.html")


@app.route("/register", methods=["GET", "POST"])
def register():
    form = RegisterForm(request.form)
    if request.method == "POST" and form.validate():

        name = form.name.data
        username = form.username.data
        email = form.email.data
        password = sha256_crypt.encrypt(form.password.data)

        cursor = mysql.connection.cursor()

        query = "INSERT into users(name, email, username, password) VALUES(%s, %s, %s, %s)"
        cursor.execute(query, (name, email, username, password))
        mysql.connection.commit()
        cursor.close()

        flash("Successfuly : Register complate ...", "success")
        return redirect(url_for("index"))
    else:
        return render_template("register.html", form=form)


@app.route("/posts")
def posts():
    return "POSTS PAGE"


@app.route("/posts/<string:id>")
def PostDetail(id):
    return "Post ID : " + id


if __name__ == "__main__":
    app.run(debug=True)
