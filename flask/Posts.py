from flask import render_template, flash, redirect, url_for, session
from passlib.hash import sha256_crypt


def posts(dbObject):
    cursor = dbObject.connection.cursor()
    result = cursor.execute("SELECT * FROM posts")
    if result > 0:
        posts = cursor.fetchall()
        return render_template("posts.html", posts=posts)
    else:
        return render_template("posts.html")


def detail(id, dbObject):
    cursor = dbObject.connection.cursor()
    result = cursor.execute("SELECT * FROM posts WHERE id=%s", (id,))
    if result > 0:
        post = cursor.fetchone()
        return render_template("postsDetail.html", Post=post)
    else:
        return render_template("postsDetail.html")


def postEdit(id, method, form, dbObject):
    if method == "POST" and form.validate():

        newTitle = form.title.data
        newContent = form.content.data

        cursor = dbObject.connection.cursor()
        cursor.execute("UPDATE posts SET title = %s, content=%s WHERE id=%s", (newTitle, newContent, id))
        dbObject.connection.commit()
        cursor.close()

        flash("success : POST update complete", "success")
        return redirect(url_for("dashboard"))
    else:
        cursor = dbObject.connection.cursor()
        result = cursor.execute("SELECT * FROM posts WHERE id=%s", (id,))
        if result > 0:
            post = cursor.fetchone()

            form.title.data = post['title']
            form.content.data = post['content']

            return render_template("PostEdit.html", form=form)
        else:
            flash("Danger : No such post was found or Permission denied.")
            return redirect(url_for("dashboard"))


def PostCreate(method, form, dbObject):
    if method == "POST" and form.validate():
        title = form.title.data
        content = form.content.data

        cursor = dbObject.connection.cursor()
        cursor.execute("INSERT INTO posts(title, author, content) VALUES(%s, %s, %s )",
                       (title, session["username"], content))
        dbObject.connection.commit()

        cursor.close()

        flash("Success : Post added successfully", "success")
        return redirect(url_for("dashboard"))
    else:
        return render_template("PostCreate.html", form=form)


def postDelete(id, dbObject):
    cursor = dbObject.connection.cursor()
    result = cursor.execute("SELECT * FROM posts WHERE id=%s", (id,))

    if result > 0:
        cursor.execute("DELETE FROM posts WHERE id=%s", (id,))

        dbObject.connection.commit()
        flash("SUCCESS : Post is Deleted !", "success")
        return redirect(url_for("dashboard"))
    else:
        flash("WARNING : Post Not Found !", "warning")
        return redirect(url_for("dashboard"))
