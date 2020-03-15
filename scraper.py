import requests
from requests import get
from bs4 import BeautifulSoup
import pandas as pd 
import numpy as np 

headers = {"Accept-langauge": "en-US, en;q=0.5"}

url = "https://hansard.parliament.uk/lords/2020-03-13"
results = requests.get(url, headers=headers)

soup = BeautifulSoup(results.text, "html.parser")


issues_div = soup.find_all('li', class_='no-children')


print(len(issues_div))
issues = []
for container in issues_div:
  issue = container.a.text
  issues.append(issue)


for i in issues:
  print(i)






