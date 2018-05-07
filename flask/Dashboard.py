from flask import render_template, flash, redirect, url_for, session
from passlib.hash import sha256_crypt


def home(dbObject):
    cursor = dbObject.connection.cursor()
    result = cursor.execute("SELECT * FROM posts WHERE author=%s", (session["username"],))
    if result > 0:
        posts = cursor.fetchall()
        return render_template("dashboard.html", posts=posts)
    else:
        return render_template("dashboard.html")
