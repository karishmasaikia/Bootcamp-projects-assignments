from flask import Flask, render_template, redirect,jsonify
from flask_pymongo import PyMongo
import scrape_mars

app = Flask(__name__)

mongo = PyMongo(app)

@app.route("/")
def home():

    marsdetails = mongo.db.marsdetails.find_one()
    # return(marsdetails['Mars_Hemispheres'][0]['title'])
    # return(marsdetails['Mars_Weather'])

    return render_template("index.html", marsdetails=marsdetails)


@app.route("/scrape")
def scrape():
    marsdetails=mongo.db.marsdetails
    facts_data=scrape_mars.scrape()

    marsdetails.update (
        {},
        facts_data,
        upsert=True
    )

    return ("scraping succesful")

    

if __name__ == "__main__":
    app.run(debug=True)