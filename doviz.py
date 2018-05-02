import requests

url = "http://data.fixer.io/api/latest?access_key=789c84968854e66e1a94201b88f9a144&base="
first = input("$ : ")
second = input("₺ : ")

response = requests.get(url + first)

objJson = response.json()

print(objJson)