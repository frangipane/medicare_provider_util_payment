from flask import render_template
from flask import request
from flaskexample import app
from sqlalchemy import create_engine
from sqlalchemy_utils import database_exists, create_database
from flaskexample.a_Model import ModelIt

import pandas as pd
import psycopg2

user = 'cathy'
host = 'localhost'
#dbname = 'birth_db'
dbname = 'doctordb'
db = create_engine('postgresql://%s%s/%s' % (user,host,dbname))
con = None
con = psycopg2.connect(database = dbname, user=user)

@app.route('/')
@app.route('/index')
def index():
    return render_template("index.html",
                           title = 'Home',
                           user = { 'nickname': 'Miguel' })


@app.route('/db')
def doctor_page():
    #sql_query = "SELECT * FROM birth_data_table WHERE delivery_method='Cesarean';"
    sql_query = "SELECT * FROM doctor_ratings LIMIT 11;"
    query_results = pd.read_sql_query(sql_query,con)
    print(query_results)
    doctors = ""
    for i in range(0,10):
        doctors += query_results.loc[i,'npi']
        doctors += "<br>"
    return doctors


@app.route('/db_fancy')
def doctors_page_fancy():
    sql_query = """SELECT DISTINCT doctor_ratings.recommended_by_doctors, 
                doctor_ratings.name,
                payments.nppes_provider_city,
                payments.nppes_provider_state
        FROM payments
        JOIN doctor_ratings 
        ON (payments.npi = doctor_ratings.npi)
        WHERE recommended_by_doctors <> ''
        LIMIT 10;
"""
    query_results = pd.read_sql_query(sql_query,con)
    doctors = []
    for i in range(0, query_results.shape[0]):
        doctors.append(dict(name=query_results.loc[i,'name'],
                            recommended_by_doctors=query_results.loc[i,'recommended_by_doctors'],
                            city=query_results.loc[i,'nppes_provider_city'],
                            state=query_results.loc[i,'nppes_provider_state']))
    return render_template('doctor_ratings.html', doctors=doctors)


@app.route('/input')
def doctors_input():
    return render_template("input.html")


@app.route('/output')
def doctors_output():
    # pull 'state' from input field and store it
    state = request.args.get('state')
    # just select the Cesareans from the birth database for the month
    # that the user inputs
    query = """SELECT DISTINCT doctor_ratings.recommended_by_doctors, 
                doctor_ratings.name,
                payments.nppes_provider_city,
                payments.nppes_provider_state
        FROM payments
        JOIN doctor_ratings 
        ON (payments.npi = doctor_ratings.npi)
        WHERE recommended_by_doctors <> ''
        AND payments.nppes_provider_state ILIKE '{0}'
        ORDER BY recommended_by_doctors DESC
        LIMIT 1;
""".format(state)
    #query = "SELECT index, attendant, birth_month FROM birth_data_table WHERE delivery_method='Cesarean' AND birth_month='%s'" %patient
    print(query)
    query_results = pd.read_sql_query(query,con)
    print(query_results)

    i = 0
    doctor_rec = dict(name=query_results.loc[i,'name'],
                      recommended_by_doctors=query_results.loc[i,'recommended_by_doctors'],
                      city=query_results.loc[i,'nppes_provider_city'],
                      state=query_results.loc[i,'nppes_provider_state'])

    the_result = doctor_rec['name']
    
    #for i in range(0, query_results.shape[0]):
    #    births.append(dict(index=query_results.loc[i,'index'], attendant=query_results.loc[i,'attendant'],
    #                       birth_month=query_results.loc[i,'birth_month']))
    #    #the_result = ''
    #    the_result = ModelIt(patient,births)
    return render_template("output.html", doctors=[doctor_rec], the_result=the_result)
