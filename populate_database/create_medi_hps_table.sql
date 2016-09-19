-- https://medschool.vanderbilt.edu/cpm/center-precision-medicine-blog/medi-ensemble-medication-indication-resource
CREATE TABLE medi_hps (
RXCUI_IN                int,
DRUG_DESC               varchar(102),
ICD9                    varchar(13),
INDICATION_DESCRIPTION  varchar(167),
POSSIBLE_LABEL_USE      varchar(20)
);
