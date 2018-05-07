# ************************************************************
# Sequel Pro SQL dump
# Version 4541
#
# http://www.sequelpro.com/
# https://github.com/sequelpro/sequelpro
#
# Host: 127.0.0.1 (MySQL 5.5.5-10.2.14-MariaDB)
# Database: flaskblog
# Generation Time: 2018-05-07 22:15:48 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table posts
# ------------------------------------------------------------

DROP TABLE IF EXISTS `posts`;

CREATE TABLE `posts` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `title` text DEFAULT NULL,
  `author` text DEFAULT NULL,
  `content` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `posts` WRITE;
/*!40000 ALTER TABLE `posts` DISABLE KEYS */;

INSERT INTO `posts` (`id`, `title`, `author`, `content`, `created_at`)
VALUES
	(1,'app.py','tombastaner','<h4>app.py :</h4>\r\n\r\n<hr />\r\n<pre class=\"prettyprint\">\r\n\r\nfrom functools import wraps\r\nfrom flask import Flask, render_template, flash, redirect, url_for, session, logging, request\r\nfrom flask_mysqldb import MySQL\r\nfrom passlib.hash import sha256_crypt\r\nfrom Auth import Auth\r\nimport Blog\r\nimport Dashboard\r\nimport Posts\r\nfrom Forms import RegisterForm, LoginForm, PostCreateForm, PostEditForm\r\n\r\napp = Flask(__name__)\r\napp.secret_key = sha256_crypt.encrypt(&quot;BlogApp&quot;)\r\n\r\napp.config[&quot;MYSQL_HOST&quot;] = &quot;localhost&quot;\r\napp.config[&quot;MYSQL_USER&quot;] = &quot;root&quot;\r\napp.config[&quot;MYSQL_PASSWORD&quot;] = &quot;&quot;\r\napp.config[&quot;MYSQL_DB&quot;] = &quot;flaskblog&quot;\r\napp.config[&#39;MYSQL_CURSORCLASS&#39;] = &quot;DictCursor&quot;\r\n\r\nmysql = MySQL(app)\r\n\r\n\r\n@app.route(&quot;/&quot;)\r\ndef home():\r\n    return Blog.home()\r\n\r\n\r\n@app.route(&quot;/register&quot;, methods=[&quot;GET&quot;, &quot;POST&quot;])\r\ndef register():\r\n    form = RegisterForm(request.form)\r\n    return Auth.register(form=form, RequestMethod=request.method, dbObject=mysql)\r\n\r\n\r\n@app.route(&quot;/login&quot;, methods=[&quot;GET&quot;, &quot;POST&quot;])\r\ndef login():\r\n    form = LoginForm(request.form)\r\n    return Auth.Login(form=form, RequestMethod=request.method, dbObject=mysql)\r\n\r\n\r\n@app.route(&quot;/logout&quot;)\r\ndef logoout():\r\n    return Auth.Logout()\r\n\r\n\r\n@app.route(&quot;/dashboard&quot;)\r\n@Auth.isLogginRequired\r\ndef dashboard():\r\n    return Dashboard.home(mysql)\r\n\r\n\r\n@app.route(&quot;/posts&quot;)\r\ndef posts():\r\n    return Posts.posts(dbObject=mysql)\r\n\r\n\r\n@app.route(&quot;/post/&lt;/string:id&gt;<string:id>&quot;)\r\ndef detail(id):\r\n    return Posts.detail(id=id, dbObject=mysql)\r\n\r\n\r\n@app.route(&quot;/posts/new&quot;, methods=[&quot;GET&quot;, &quot;POST&quot;])\r\n@Auth.isLogginRequired\r\ndef PostCreate():\r\n    form = PostCreateForm(request.form)\r\n    return Posts.PostCreate(method=request.method, form=form, dbObject=mysql)\r\n\r\n\r\n@app.route(&quot;/post/edit/&lt;/string:id&gt;<string:id>&quot;, methods=[&quot;GET&quot;, &quot;POST&quot;])\r\n@Auth.isLogginRequired\r\ndef editPost(id):\r\n    if request.form:\r\n        form = PostEditForm(request.form)\r\n    else:\r\n        form = PostEditForm()\r\n\r\n    return Posts.postEdit(id=id, method=request.method, form=form, dbObject=mysql)\r\n\r\n\r\n@app.route(&quot;/post/delete/&lt;/string:id&gt;<string:id>&quot;)\r\n@Auth.isLogginRequired\r\ndef deletePost(id):\r\n    return Posts.postDelete(id=id, dbObject=mysql)\r\n\r\n\r\nif __name__ == &#39;__main__&#39;:\r\n    app.run(debug=True)\r\n\r\n</string:id></string:id></string:id></pre>\r\n','2018-05-08 01:10:17'),
	(2,'Auth.py','tombastaner','<h4>Auth.py</h4>\r\n\r\n<pre class=\"prettyprint\">\r\n\r\nfrom functools import wraps\r\nfrom flask import render_template, flash, redirect, url_for, session\r\nfrom passlib.hash import sha256_crypt\r\n\r\nclass Auth():\r\n    def __init__(self):\r\n        pass\r\n\r\n    def register(form, RequestMethod, dbObject):\r\n        if RequestMethod == &quot;POST&quot; and form.validate():\r\n\r\n            name = form.name.data\r\n            username = form.username.data\r\n            email = form.email.data\r\n            password = sha256_crypt.encrypt(form.password.data)\r\n            cursor = dbObject.connection.cursor()\r\n\r\n            cursor.execute(&quot;INSERT into users(name, email, username, password) VALUES(%s, %s, %s, %s)&quot;,\r\n                           (name, email, username, password))\r\n            dbObject.connection.commit()\r\n            cursor.close()\r\n\r\n            flash(&quot;Successfuly : Register complate ...&quot;, &quot;success&quot;)\r\n            return redirect(url_for(&quot;login&quot;))\r\n        else:\r\n            return render_template(&quot;register.html&quot;, form=form)\r\n\r\n    def Login(form, RequestMethod, dbObject):\r\n        if RequestMethod == &quot;POST&quot; and form.validate():\r\n            username = form.username.data\r\n            password = form.password.data\r\n\r\n            cursor = dbObject.connection.cursor()\r\n            result = cursor.execute(&quot;SELECT * FROM users WHERE username = %s&quot;, (username,))\r\n\r\n            if result &gt; 0:\r\n                data = cursor.fetchone()\r\n                real_password = data[&#39;password&#39;]\r\n\r\n                if sha256_crypt.verify(password, real_password):\r\n                    flash(&quot;Success : Login Successfuly..&quot;, &quot;success&quot;)\r\n\r\n                    session[&quot;logged_in&quot;] = True\r\n                    session[&quot;username&quot;] = username\r\n                    return redirect(url_for(&quot;home&quot;))\r\n                else:\r\n                    flash(&quot;Error : Password not matched !&quot;, &quot;danger&quot;)\r\n                    return redirect(url_for(&quot;login&quot;))\r\n\r\n            else:\r\n                flash(&quot;Error : User Not Found !&quot;, &quot;danger&quot;)\r\n                return redirect(url_for(&quot;dashboard&quot;))\r\n        else:\r\n            return render_template(&quot;login.html&quot;, form=form)\r\n\r\n    def Logout():\r\n        session.clear()\r\n        flash(&quot;Info : Logout Successfully..&quot;, &quot;info&quot;)\r\n        return redirect(url_for(&quot;home&quot;))\r\n\r\n    def isLogginRequired(f):\r\n        @wraps(f)\r\n        def decorated_function(*args, **kwargs):\r\n\r\n            if &quot;logged_in&quot; in session:\r\n                return f(*args, **kwargs)\r\n            else:\r\n                flash(&quot;Error: Permission Denied !&quot;, &quot;danger&quot;)\r\n                return redirect(url_for(&quot;login&quot;))\r\n\r\n        return decorated_function\r\n\r\n</pre>\r\n','2018-05-08 01:11:33'),
	(3,'Dashboard.py','tombastaner','<h4>Dashboard.py</h4>\r\n\r\n<pre class=\"prettyprint\">\r\nfrom flask import render_template, flash, redirect, url_for, session\r\nfrom passlib.hash import sha256_crypt\r\n\r\n\r\ndef home(dbObject):\r\n    cursor = dbObject.connection.cursor()\r\n    result = cursor.execute(\"SELECT * FROM posts WHERE author=%s\", (session[\"username\"],))\r\n    if result > 0:\r\n        posts = cursor.fetchall()\r\n        return render_template(\"dashboard.html\", posts=posts)\r\n    else:\r\n        return render_template(\"dashboard.html\")\r\n</pre>','2018-05-08 01:13:18'),
	(4,'Forms.py','tombastaner','<h4>Forms.py</h4>\r\n<pre class=\"prettyprint\">\r\nfrom wtforms import Form, StringField, TextAreaField, PasswordField, validators\r\n\r\n\r\n# user register form\r\nclass RegisterForm(Form):\r\n    name = StringField(\"Name Surname :\", validators=[validators.length(min=4, max=25)])\r\n    username = StringField(\"Username :\", validators=[validators.length(min=5, max=35)])\r\n    email = StringField(\"E-Mail :\", validators=[validators.Email(message=\"E-Mail Failed !\")])\r\n    password = PasswordField(\"Password :\", validators=[\r\n        validators.DataRequired(message=\"Password is required !\"),\r\n        validators.EqualTo(fieldname=\"confirm_password\", message=\"Passwords not matched !\")\r\n    ])\r\n    confirm_password = PasswordField(\"Confirm Password :\")\r\n\r\n\r\n# user Login form\r\nclass LoginForm(Form):\r\n    username = StringField(\"Username :\", validators=[validators.DataRequired(message=\"Username is required !\")])\r\n    password = PasswordField(\"Password :\", validators=[validators.DataRequired(message=\"Password is required !\")])\r\n\r\n\r\n# post create form\r\nclass PostCreateForm(Form):\r\n    title = StringField(\"Title :\", validators=[validators.DataRequired(message=\"Title is required !\")])\r\n    content = TextAreaField(\"Content :\", validators=[validators.DataRequired(message=\"Content is required !\")])\r\n\r\n\r\n# post edit form\r\nclass PostEditForm(Form):\r\n    title = StringField(\"Title :\", validators=[validators.DataRequired(message=\"Title is required !\")])\r\n    content = TextAreaField(\"Content :\", validators=[validators.DataRequired(message=\"Content is required !\")])\r\n\r\n</pre>','2018-05-08 01:14:08'),
	(5,'Posts.py','tombastaner','<h4>Posts.py</h4>\r\n<pre class=\"prettyprint\">\r\nfrom flask import render_template, flash, redirect, url_for, session\r\nfrom passlib.hash import sha256_crypt\r\n\r\n\r\ndef posts(dbObject):\r\n    cursor = dbObject.connection.cursor()\r\n    result = cursor.execute(\"SELECT * FROM posts\")\r\n    if result > 0:\r\n        posts = cursor.fetchall()\r\n        return render_template(\"posts.html\", posts=posts)\r\n    else:\r\n        return render_template(\"posts.html\")\r\n\r\n\r\ndef detail(id, dbObject):\r\n    cursor = dbObject.connection.cursor()\r\n    result = cursor.execute(\"SELECT * FROM posts WHERE id=%s\", (id,))\r\n    if result > 0:\r\n        post = cursor.fetchone()\r\n        return render_template(\"postsDetail.html\", Post=post)\r\n    else:\r\n        return render_template(\"postsDetail.html\")\r\n\r\n\r\ndef postEdit(id, method, form, dbObject):\r\n    if method == \"POST\" and form.validate():\r\n\r\n        newTitle = form.title.data\r\n        newContent = form.content.data\r\n\r\n        cursor = dbObject.connection.cursor()\r\n        cursor.execute(\"UPDATE posts SET title = %s, content=%s WHERE id=%s\", (newTitle, newContent, id))\r\n        dbObject.connection.commit()\r\n        cursor.close()\r\n\r\n        flash(\"success : POST update complete\", \"success\")\r\n        return redirect(url_for(\"dashboard\"))\r\n    else:\r\n        cursor = dbObject.connection.cursor()\r\n        result = cursor.execute(\"SELECT * FROM posts WHERE id=%s\", (id,))\r\n        if result > 0:\r\n            post = cursor.fetchone()\r\n\r\n            form.title.data = post[\'title\']\r\n            form.content.data = post[\'content\']\r\n\r\n            return render_template(\"PostEdit.html\", form=form)\r\n        else:\r\n            flash(\"Danger : No such post was found or Permission denied.\")\r\n            return redirect(url_for(\"dashboard\"))\r\n\r\n\r\ndef PostCreate(method, form, dbObject):\r\n    if method == \"POST\" and form.validate():\r\n        title = form.title.data\r\n        content = form.content.data\r\n\r\n        cursor = dbObject.connection.cursor()\r\n        cursor.execute(\"INSERT INTO posts(title, author, content) VALUES(%s, %s, %s )\",\r\n                       (title, session[\"username\"], content))\r\n        dbObject.connection.commit()\r\n\r\n        cursor.close()\r\n\r\n        flash(\"Success : Post added successfully\", \"success\")\r\n        return redirect(url_for(\"dashboard\"))\r\n    else:\r\n        return render_template(\"PostCreate.html\", form=form)\r\n\r\n\r\ndef postDelete(id, dbObject):\r\n    cursor = dbObject.connection.cursor()\r\n    result = cursor.execute(\"SELECT * FROM posts WHERE id=%s\", (id,))\r\n\r\n    if result > 0:\r\n        cursor.execute(\"DELETE FROM posts WHERE id=%s\", (id,))\r\n\r\n        dbObject.connection.commit()\r\n        flash(\"SUCCESS : Post is Deleted !\", \"success\")\r\n        return redirect(url_for(\"dashboard\"))\r\n    else:\r\n        flash(\"WARNING : Post Not Found !\", \"warning\")\r\n        return redirect(url_for(\"dashboard\"))\r\n\r\n</pre>','2018-05-08 01:15:05');

/*!40000 ALTER TABLE `posts` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table users
# ------------------------------------------------------------

DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(191) DEFAULT NULL,
  `email` varchar(191) DEFAULT NULL,
  `username` varchar(191) DEFAULT NULL,
  `password` varchar(191) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;

INSERT INTO `users` (`id`, `name`, `email`, `username`, `password`)
VALUES
	(1,'Taner Tombas','tombastaner@gmail.com','tombastaner','$5$rounds=535000$PSzAcaud.3R7R81A$IJN/Ns9IrQAkh8nlZLxryp8TLoof.HnFYCzV7yc0Wv9');

/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;



/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
