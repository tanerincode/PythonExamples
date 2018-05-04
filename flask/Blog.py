from flask import render_template, flash, redirect, url_for, session
from passlib.hash import sha256_crypt

def home():
    return render_template("index.html")