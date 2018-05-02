from flask import Flask, render_template

app = Flask(__name__)


@app.route('/')
def index():
    article = dict()

    article['title'] = "Deneme"
    article["body"] = "Detail"
    article['author'] = "Taner Tombas"

    return render_template("index.html", article=article)


@app.route("/about")
def about():
    return "Hakkimda"


@app.route("/about/taner")
def aboutDetail():
    return "Hakkimda Taner"


if __name__ == "__main__":
    app.run(debug=True)
