# credit:
# https://stackoverflow.com/questions/2535255/fastest-way-convert-tab-delimited-file-to-csv-in-linux
# usage in shell: python tsv_to_csv.py < input.tsv > output.csv

import sys
import csv

tsv_in = csv.reader(sys.stdin, dialect=csv.excel_tab)
csv_out = csv.writer(sys.stdout, dialect=csv.excel)

for row in tsv_in:
    csv_out.writerow(row)
