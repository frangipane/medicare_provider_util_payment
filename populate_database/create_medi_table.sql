-- https://medschool.vanderbilt.edu/cpm/center-precision-medicine-blog/medi-ensemble-medication-indication-resource
CREATE TABLE medi_indication (
RXCUI_IN                int,
DRUG_DESC               varchar(102),
ICD9                    varchar(13),
INDICATION_DESCRIPTION  varchar(167),
MENTIONEDBYRESOURCES    varchar(20),
HIGHPRECISIONSUBSET     varchar(19),
POSSIBLE_LABEL_USE      varchar(19)
);
