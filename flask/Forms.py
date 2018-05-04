from wtforms import Form, StringField, TextAreaField, PasswordField, validators


# user register form
class RegisterForm(Form):
    name = StringField("Name Surname :", validators=[validators.length(min=4, max=25)])
    username = StringField("Username :", validators=[validators.length(min=5, max=35)])
    email = StringField("E-Mail :", validators=[validators.Email(message="E-Mail Failed !")])
    password = PasswordField("Password :", validators=[
        validators.DataRequired(message="Password is required !"),
        validators.EqualTo(fieldname="confirm_password", message="Passwords not matched !")
    ])
    confirm_password = PasswordField("Confirm Password :")

# user Login form
class LoginForm(Form):
    username = StringField("Username :", validators=[validators.DataRequired(message="Username is required !")])
    password = PasswordField("Password :", validators=[validators.DataRequired(message="Password is required !")])

# user register form
class PostCreateForm(Form):
    title = StringField("Title :", validators=[validators.DataRequired(message="Title is required !")])
    content = TextAreaField("Title :", validators=[validators.DataRequired(message="Content is required !")])