from flask import Flask, redirect, url_for, request 
import requests
from bs4 import BeautifulSoup
  
app = Flask(__name__) 
  
@app.route('/metadata', methods=['GET']) 
def get_metadata():
    url = request.args['url'] 
    response = requests.get(url)
    soup = BeautifulSoup(response.text, features="lxml")

    metas = soup.find_all('meta')
    # print(metas)
    description = [meta.attrs['content'] for meta in metas if 'name' in meta.attrs and meta.attrs['name'] == 'description' ]
    if len(description) > 0:
        return description[0]
    else:
        print('title')
        title = soup.find('title')
        return title
  
if __name__ == '__main__': 
    app.run() 