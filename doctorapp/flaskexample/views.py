from flask import render_template
from flask import request, url_for, g
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
    ## Pull 'first_name' and 'last_name' from input field and store it
    first_name = request.args.get('first_name')
    last_name = request.args.get('last_name')

    ## Make uppercase for SQL search
    first_name = first_name.upper().strip()
    last_name = last_name.upper().strip()

    ## Select last and first name from payments database.
    query = """
    SELECT DISTINCT npi
      ,nppes_provider_first_name AS first_name
      ,nppes_provider_last_org_name AS last_name
      ,nppes_provider_street1 AS street
      ,nppes_provider_city AS city
      ,nppes_provider_state AS state
      ,nppes_provider_zip AS zip_code
    FROM payments
    WHERE provider_type='Orthopedic Surgery'
    AND nppes_provider_first_name = '{0}'
    AND nppes_provider_last_org_name = '{1}'
    ORDER BY nppes_provider_state;
    """.format(first_name, last_name)

    print(query)
    query_results = pd.read_sql_query(query,con)
    print(query_results)

    ## 3 possibilities:
    ## (1) Doctor does not exist in database
    ## (2) Multiple doctors with that name exist in database
    ## (3) A single doctor is found.

    number_of_hits = len(query_results)

    if number_of_hits > 0:
        ## multiple doctors
        doctors = []
        for i in range(number_of_hits):
            adoctor = dict( first_name = query_results.loc[i,'first_name'],
                        last_name = query_results.loc[i,'last_name'],
                        street = query_results.loc[i,'street'],
                        city = query_results.loc[i,'city'],
                        state = query_results.loc[i,'state'],
                        zip_code = query_results.loc[i, 'zip_code'][:5],
                        npi = query_results.loc[i, 'npi'] )
            doctors.append(adoctor)

        return render_template("output.html",
                               doctors=doctors,
                               number_of_hits=number_of_hits)

    elif number_of_hits == 0:
        ## no doctors found
        #print(first_name)
        #print(last_name)
        return render_template("output.html",
                               first_name = first_name,
                               last_name = last_name,
                               number_of_hits = number_of_hits)

    else:
        ## exactly one doctor found
        #return render_template("view_profile.html", doctors=doctors[0])
        pass


@app.route('/view_profile/<npi>')
def view_profile(npi):
    ## Pull top 10 claims by the provider that are most relevant to
    ## the assigned topic/specialty

    query_name = """
    SELECT nppes_provider_first_name AS first_name
      ,nppes_provider_last_org_name AS last_name
    FROM summary
    WHERE npi = '{0}';
    """.format(npi)

    fullname = pd.read_sql_query(query_name,con)
    print(fullname)
    
    query = """
    SELECT hcpcs_code
      ,hcpcs_description
      ,place_of_service
      ,bene_unique_cnt
      ,topic
    FROM doctor_claims_for_topic
    WHERE npi = '{0}'
    ORDER BY rank ASC
    LIMIT 10;
    """.format(npi)

    print(query)
    query_results = pd.read_sql_query(query,con)
    print(query_results)

    topic = 'none'
    rows = []
    if len(query_results) > 0:
        topic = query_results.loc[0,'topic']
        for i in range(len(rows)):
            arow = dict(hcpcs_code = query_results.loc[i,'hcpcs_code'],
                        hcpcs_description = query_results.loc[i,'hcpcs_description'],
                        place_of_service = query_results.loc[i,'place_of_service'],
                        bene_unique_cnt = query_results.loc[i,'bene_unique_cnt'])
            rows.append(arow)
    try:
        return render_template("view_profile.html",
                           rows=rows,
                           first_name=fullname.loc[0,'first_name'],
                           last_name=fullname.loc[0,'last_name'],
                           topic=topic,
                           npi=npi)
    except:
        return render_template('index.html')
