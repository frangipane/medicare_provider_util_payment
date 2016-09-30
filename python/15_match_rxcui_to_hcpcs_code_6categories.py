import psycopg2
import pandas as pd
import numpy as np
import re


def main():
    con = psycopg2.connect("dbname='doctordb' user='cathy'")

    q = """SELECT DISTINCT hcpcs_code, hcpcs_description FROM payments 
    WHERE (provider_type='Medical Oncology' OR provider_type='Hematology/Oncology')
    AND hcpcs_drug_indicator='Y'"""
    medicare_drug_claims = pd.read_sql_query(q, con=con)

    ## lower case drug claims
    medicare_drug_claims['hcpcs_description'] = (medicare_drug_claims['hcpcs_description'].
                                                 apply(str.lower))

    ## read in rxcui_drugs
    rxcui_drugs = pd.read_csv("14_rxcui_drug_name_6categories.csv")

    ## per drug name in rxcui_drugs, search in hcpcs_description for a match
    matches = []

    for (rxcui, drug, keyword) in rxcui_drugs.itertuples(index=False):
        for (hcpcs_code, hcpcs_desc) in medicare_drug_claims.itertuples(index=False):
            foundMatch = re.search(drug, hcpcs_desc)
        
            if foundMatch:
                matches.append((rxcui, drug, keyword, hcpcs_code, hcpcs_desc))

    print("Number of matches found: {0}".format(len(matches)))

    ## create data frame from matches list of tuples
    rxcui_hcpcs_df = pd.DataFrame(matches, index=None,
                                  columns=['rxcui_in','drug_name',
                                           'keywords_indication_desc',
                                           'hcpcs_code','hcpcs_description'])

    ## write rxcui-hcpcs code map out to csv
    rxcui_hcpcs_df.to_csv("15_rxcui_hcpcs_map_6categories.csv", index=False)

if __name__ == "__main__":
    main()
