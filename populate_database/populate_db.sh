#!/user/bin/env bash

### to run this script, type on command line:
### . populate_db.sh

### Script assumes that the raw (uncompressed) data files,
### Medicare_Physician_and_Other_Supplier_NPI_Aggregate_CY2014.txt and
### Medicare_Provider_Util_Payment_PUF_CY2014.txt are located in a
### subdirectory, "data", under the base/project directory.

BASE_DIR="$HOME/repos/medicare_provider_util_payment"
DB_DIR="/usr/local/postgresql/data"
DB_USR="cathy"
DB_NAME="doctordb"
DB_HOST="localhost"
SUMMARY_FNAME="Medicare_Physician_and_Other_Supplier_NPI_Aggregate_CY2014"
PAYMENTS_FNAME="Medicare_Provider_Util_Payment_PUF_CY2014"
MEDI_HPS_FNAME="MEDI_01212013_HPS"


### start postgres server ##################################
pg_ctl -w -D $DB_DIR start -l logfile &> /dev/null
if [ $? -eq 0 ]; then
    echo "Database server already exists at $DB_DIR."
else
    mkdir $DB_DIR
    initdb $DB_DIR
    echo "---Created database server $DB_DIR---"
    pg_ctl -w -D $DB_DIR start -l logfile
    echo "---Started postgres server---"
fi


### create postgres medicare provider database ##################################
if psql -lqt | cut -d \| -f 1 | grep -qw $DB_NAME; then
    echo "$DB_NAME already exists."
else
    createdb $DB_NAME
    echo "Created database $DB_NAME."
fi


### export env variables for using psql ##################################
export PGHOST=$DB_HOST
export PGUSER=$DB_USR
export PGDATABASE=$DB_NAME
export PGDATA=$DB_DIR


### create (empty) summary table in database (if table exists, do nothing) ##################################
SUMMARY_TABLE_EXISTS=$(psql -tAc "SELECT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'summary')")

if [ $SUMMARY_TABLE_EXISTS == 't' ]; then
    echo "Table 'summary' already exists; do nothing."
else
    psql -f $BASE_DIR/populate_database/create_aggregate_table.sql
    echo "Empty table, 'summary', created."

    ### convert .text (tsv) files to csv before loading in postgres
    if [ ! -f "$BASE_DIR/data/$SUMMARY_FNAME.csv" ]; then
        python $BASE_DIR/utils/tsv_to_csv.py < \
               $BASE_DIR/data/$SUMMARY_FNAME.txt > \
               $BASE_DIR/data/$SUMMARY_FNAME.csv
        echo "Created csv from Physician summary (aggregate) tsv file."
    fi

    ### load csv files into table
    psql -q -c  "COPY summary FROM '$BASE_DIR/data/$SUMMARY_FNAME.csv' WITH (DELIMITER ',', FORMAT CSV, HEADER);" && echo "File copied to summary table."
fi

### create (empty) payments table in database (if table exists, do nothing) ##################################
PAYMENTS_TABLE_EXISTS=$(psql -tAc "SELECT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'payments')")

if [ $PAYMENTS_TABLE_EXISTS == 't' ]; then
    echo "Table 'payments' already exists; do nothing."
else
    psql -f $BASE_DIR/populate_database/create_payments_table.sql
    echo "Empty table, 'payments', created."

    ### convert .text (tsv) files to csv before loading in postgres
    if [ ! -f "$BASE_DIR/data/$PAYMENTS_FNAME.csv" ]; then
        python $BASE_DIR/utils/tsv_to_csv.py < \
               $BASE_DIR/data/$PAYMENTS_FNAME.txt > \
               $BASE_DIR/data/$PAYMENTS_FNAME.csv
        echo "Created csv from Physician payments tsv file."
    fi

    ### load csv files into table
    psql -q -c  "COPY payments FROM '$BASE_DIR/data/$PAYMENTS_FNAME.csv' WITH (DELIMITER ',', FORMAT CSV, HEADER);" && echo "File copied to payments table."
fi

### create (empty) MEDI_HPS table (Ensemble MEDication Indication Resource) ##################################
### MEDI-HPS contains medication-indication pairs
### https://medschool.vanderbilt.edu/cpm/center-precision-medicine-blog/medi-ensemble-medication-indication-resource

MEDI_HPS_TABLE_EXISTS=$(psql -tAc "SELECT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'medi_hps')")

if [ $MEDI_HPS_TABLE_EXISTS == 't' ]; then
    echo "Table 'medi_hps' already exists; do nothing."
else
    psql -f $BASE_DIR/populate_database/create_medi_hps_table.sql
    echo "Empty table, 'medi_hps', created."

    ### load csv files into table
    psql -q -c  "COPY payments FROM '$BASE_DIR/data/$MEDI_HPS_FNAME.csv' WITH (DELIMITER ',', FORMAT CSV, HEADER);" && echo "File copied to medi_hps table."
fi

## stop postgres server ##################################
pg_ctl -D $DB_DIR stop
