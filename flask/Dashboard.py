from flask import render_template, flash, redirect, url_for, session
from passlib.hash import sha256_crypt

def home():
    return render_template("dashboard.html")

def posts():
    pass

def PostCreate(form, dbObject):
    return render_template("PostCreate.html", form = form)