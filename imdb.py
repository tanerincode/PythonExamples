import requests

from bs4 import BeautifulSoup

url = "https://www.imdb.com/chart/top"

response = requests.get(url)

htmlContent = response.content
soup = BeautifulSoup(htmlContent, "html.parser")

UserData = float(input("Please write a rating number for filter : "))

# start parser
titles = soup.find_all("td", {"class": "titleColumn"})
ratings = soup.find_all("td", {"class": "ratingColumn imdbRating"})

for titles, ratings in zip(titles, ratings):
    title = titles.text
    title = title.strip()
    title = title.replace("\n", "")

    rating = ratings.text
    rating = rating.strip()
    rating = rating.replace("\n", "")

    if (float(rating) > UserData) :
        print("Movie Name : {} Rating : {}".format(title, rating))
