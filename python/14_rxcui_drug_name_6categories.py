import psycopg2
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
import matplotlib.cm as cm
import numpy as np
import re


def preprocess_drug_name(drug):
    """Given a drug name, pre-process before searching for it in Medicare database by:
    converting to all lowercase, convert multiple spaces to single space, separate strings denoting
    alternative compound names with slash into individual strings, remove the characters '(USP)'
    
    INPUT:
    drug - a string
    
    OUTPUT:
    druglist - list of strings (most often a list of length 1)
    """
    # split strings separated by slash into list
    drug_list = drug.split('/')
    
    processed_drug_list = []
    # process each item in the list
    for d in drug_list:
        # lower case
        d = d.lower()
        # substitute (USP) with empty string
        d = d.replace('(usp)', '')
        # convert multiple spaces to single space
        d = re.sub(r'\s\s+', r' ', d)
        # strip leading/trailing whitespace
        d = d.strip()
        
        processed_drug_list.append(d)
        
    return processed_drug_list


def create_query(lowerb, upperb, highprecisionsubset='1'):
    """Given lower and upper bound on ICD-9 neoplasm category,
    construct query to medi_indication database.  Query returns
    rxcui_in and drug_desc.

    Input:
    lowerb - int, lower bound of ICD9 range
    upperb - int, upper bound of ICD9 range
    highprecisionsubset - char, '0' or '1'

    Returns:
    query - string, sql query
    """
    query = """SELECT DISTINCT rxcui_in, drug_desc FROM (
    SELECT * FROM medi_indication
              WHERE icd9 NOT LIKE '%-%'
              AND icd9 NOT LIKE '%|%'
              AND icd9 !~ '^[A-z]+') AS single_icd9_codes
       WHERE cast(icd9 AS float) >= {0}
       AND cast(icd9 AS float) < {1}
       AND highprecisionsubset ='{2}';""".format(lowerb, upperb, highprecisionsubset)
    return query


def create_indications_dict():
    """Create dictionary of 6 neoplasm category indications, where
    key is a keyword that describes the category, value is a tuple of 
    ICD9 upper and lower bounds"""
    neoplasm_dict = {}
    neoplasm_dict['digestive'] = (150, 160)
    neoplasm_dict['respiratory'] = (160, 166)
    neoplasm_dict['breast_skin'] = (170, 176)
    neoplasm_dict['genitourinary'] = (179, 189)
    neoplasm_dict['eye_brain'] = (190, 199)
    neoplasm_dict['lymph_blood'] = (200, 208)
    return neoplasm_dict


    
def main():

    ## get icd9 code bounds per neoplasm category
    neoplasm_dict = create_indications_dict()
    
    ## connect to database
    con = None
    con = psycopg2.connect("dbname='doctordb' user='cathy'")

    ## create list of tuple pairs (rxcui_in, drug_name, keywords_indication_desc)
    processed_drug_list = []

    ## Loop through dictionary and query medi_indications database
    for k, v in neoplasm_dict.items():
        q = create_query(v[0], v[1])
        medi_ind_drugs = pd.read_sql_query(q, con=con)

        ## process medi_ind_drugs drug names
        for (rxcui, drug) in medi_ind_drugs.itertuples(index=False):
            drugs_list = preprocess_drug_name(drug)
    
            for d in drugs_list:
                processed_drug_list.append((rxcui, d, k))

    ## Create data frame from list of tuples
    rxcui_drugs_df = pd.DataFrame(processed_drug_list,
                                  index=None,
                                  columns=['rxcui_in','drug_name','keywords_indication_desc'])

    ## write processed drug name data frame to csv
    rxcui_drugs_df.to_csv("14_rxcui_drug_name_6categories.csv", index=False)
    
    if con:
        con.close()

    pass


if __name__ == "__main__":
    main()
