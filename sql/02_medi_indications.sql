-- column names:
-- rxcui_in
-- drug_desc
-- icd9
-- indication_description
-- mentionedbyresources
-- highprecisionsubset
-- possible_label_use

-- How many records are in table medi_indications?
-- 63343
SELECT COUNT(*) FROM medi_indication;


-- How many records in table medi_indications are flagged as high precision?
-- 13379
SELECT COUNT(*) FROM medi_indication
       WHERE highprecisionsubset LIKE '1';


-- How many distinct rxcui_in are there?
-- RxNorm Concept Unique Identifier
-- Drugs with identical RxCUI have same ingredients, strengths, and dose forms.
-- Generic and Branded drugs have different RxCUI.
-- 3112
SELECT COUNT(DISTINCT rxcui_in) FROM medi_indication;


-- How many distinct icd-9 are there?
-- 3009
SELECT COUNT(DISTINCT icd9) FROM medi_indication;


-- How many distinct pairs of icd-9 and rxcui_in are there?
-- 63343 (so each row is a unique combination of icd-9:rxcui_in, i.e.
-- each row is a unique diagnosis:medicine pair)
SELECT SUM(count_pairs) FROM (
       SELECT COUNT(*) AS count_pairs
              FROM medi_indication
              GROUP BY rxcui_in, icd9
       ) AS throwawayalias;


-- http://www.icd9data.com/2012/Volume1/140-239/170-176/174/default.htm
-- ICD9 diagnosis codes:
-- malignant neoplasm of female breast - numbered 174-


-- How many descriptions contain the word breast?
-- 248
SELECT COUNT(*) FROM medi_indication
       WHERE indication_description ILIKE '%breast%';


-- How many descriptions contain the word breast and are high precision?
-- 101
SELECT COUNT(*) FROM medi_indication
       WHERE indication_description ILIKE '%breast%'
       AND highprecisionsubset LIKE '1';


-- How many distinct drugs are there for indications containing the word breast?
-- 182
SELECT COUNT(DISTINCT rxcui_in) FROM medi_indication
       WHERE indication_description ILIKE '%breast%';


-- How many distinct drugs are there for indications containing the word breast
-- and are high precision?
-- 70
SELECT COUNT(DISTINCT rxcui_in) FROM medi_indication
       WHERE indication_description ILIKE '%breast%'
       AND highprecisionsubset LIKE '1';


-- What are some sample rows relating to breasts?
-- some contain non-breast cancer related issues, e.g. ic9 760.71
-- ("Alcohol affecting ... via breast")
-- 174.9, 175.9, 198.81
SELECT * FROM medi_indication
       WHERE indication_description ILIKE '%breast%'
       LIMIT 10;


-- What if we narrow keywords to both 'breast' and 'neoplasm'?
-- 204
SELECT COUNT(*) FROM medi_indication
       WHERE indication_description
             ILIKE '%breast%'
             AND indication_description ILIKE '%neoplasm%';


-- Look at some sample rows relating to breast and neoplasm.
SELECT * FROM medi_indication
       WHERE indication_description
             ILIKE '%breast%'
             AND indication_description ILIKE '%neoplasm%'
       LIMIT 10;


-- How many distinct ICD-9s are in this subset of descriptions
-- containing both 'breast' and 'neoplasm'?
-- only 4
SELECT COUNT(DISTINCT icd9) FROM medi_indication
       WHERE indication_description
             ILIKE '%breast%'
             AND indication_description ILIKE '%neoplasm%';


-- What are these 4 distinct icd9's relating to both breast
-- and neoplasm?
-- 175.9, 198.81, 239.3, 174.9
SELECT DISTINCT icd9 FROM medi_indication
       WHERE indication_description
             ILIKE '%breast%'
             AND indication_description ILIKE '%neoplasm%';


-- How many drugs are there addressing the breast and neoplasm subset?
-- 153
SELECT COUNT(DISTINCT rxcui_in) FROM medi_indication
       WHERE indication_description
             ILIKE '%breast%'
             AND indication_description ILIKE '%neoplasm%';


-- 'neoplasm' is too restrictive.  Other categories apply to breast
-- cancer, e.g. 'carcinoma'.


-- How many distinct ICD-9s are in subset of descriptions
-- containing both 'breast' and 'carcinoma'?
-- 1
SELECT COUNT(DISTINCT icd9) FROM medi_indication
       WHERE indication_description
             ILIKE '%breast%'
             AND indication_description ILIKE '%carcinoma%';


-- How many drugs are there addressing the breast and carcinoma subset?
-- 3 (Inositol, Tamoxifen, Raloxifene)
SELECT COUNT(DISTINCT rxcui_in) FROM medi_indication
       WHERE indication_description
             ILIKE '%breast%'
             AND indication_description ILIKE '%carcinoma%';


-- How many drugs are prescribed for both non-breast indications and
-- breast indications?
-- 181
-- example: rxcui_in = 4083 => estradiol
SELECT COUNT(DISTINCT rxcui_in) FROM medi_indication
       WHERE rxcui_in IN (
             SELECT rxcui_in FROM medi_indication
                     WHERE indication_description
                     ILIKE '%breast%')
       AND indication_description NOT ILIKE '%breast%';


-- note: drug_desc needs to collapse consecutive white-spaces to just one for
-- mapping later to other tables


--142 indications containing 'lymph'
SELECT COUNT(*) FROM medi_indication
       WHERE indication_description ILIKE '%lymph%'
       AND highprecisionsubset='1';


-- 74 distinct drugs treating indication 'lymph'
SELECT COUNT(DISTINCT rxcui_in) FROM medi_indication
       WHERE indication_description ILIKE '%lymph%'
       AND highprecisionsubset='1';


-- https://en.wikipedia.org/wiki/List_of_ICD-9_codes_140%E2%80%93239:_neoplasms
-- ICD-9 codes: 140–239: neoplasms
SELECT COUNT(*) FROM medi_indication
       WHERE cast(icd9 AS float) >= 140
       AND cast(icd9 AS float) < 240;

-- 3908 rows pertaining to ICD-9 category: neoplasms
SELECT COUNT(*) FROM (
       SELECT * FROM medi_indication
              WHERE icd9 NOT LIKE '%-%'
              AND icd9 NOT LIKE '%|%'
              AND icd9 !~ '^[A-z]+') AS single_icd9_codes
       WHERE cast(icd9 AS float) >= 140
       AND cast(icd9 AS float) < 240;


--887 distinct drugs for neoplasms
SELECT COUNT(DISTINCT rxcui_in) FROM (
       SELECT * FROM medi_indication
              WHERE icd9 NOT LIKE '%-%'
              AND icd9 NOT LIKE '%|%'
              AND icd9 !~ '^[A-z]+') AS single_icd9_codes
       WHERE cast(icd9 AS float) >= 140
       AND cast(icd9 AS float) < 240;


-- 176 distinct indications under neoplasms category
SELECT COUNT(DISTINCT icd9) FROM (
       SELECT * FROM medi_indication
              WHERE icd9 NOT LIKE '%-%'
              AND icd9 NOT LIKE '%|%'
              AND icd9 !~ '^[A-z]+') AS single_icd9_codes
       WHERE cast(icd9 AS float) >= 140
       AND cast(icd9 AS float) < 240;


-- Examples of the 176 indications
/*
Malignant neoplasm of pleura; unspecified
 Malignant neoplasm of head; face; and neck
 Malignant neoplasm of other and unspecified sites of male breast
 Other malignant neoplasm of unspecified site
 Benign neoplasm NOS
 Secondary malignant neoplasm of bone and bone marrow
 Hemangioma of other sites
 Uterine leiomyoma
 Leukemia of unspecified cell type; acute
 Peripheral T-cell lymphoma; unspecified site; extranodal and solid organ sites
 Malignant neoplasm of breast (female); unspecified
 Secondary malignant neoplasm of other parts of nervous system
 Malignant neoplasm of esophagus
 Uterine leiomyoma NOS
 Hemangioma; any site
 Malignant neoplasm of kidney; except pelvis
 Burkitt's tumor or lymphoma
 Neuroendocrine tumors
 Malignant neoplasm of liver; primary
*/
SELECT DISTINCT indication_description FROM (
       SELECT * FROM medi_indication
              WHERE icd9 NOT LIKE '%-%'
              AND icd9 NOT LIKE '%|%'
              AND icd9 !~ '^[A-z]+') AS single_icd9_codes
       WHERE cast(icd9 AS float) >= 140
       AND cast(icd9 AS float) < 240
       LIMIT 176;


/*
Malignant neoplasm of lip, oral cavity, and pharynx (140–149)
Malignant neoplasm of digestive organs and peritoneum (150–159), e.g. stomach, 
                                                                 colon, liver
Malignant neoplasm of respiratory and intrathoracic organs (160–165), e.g. lung
Malignant neoplasm of bone, connective tissue, skin, and breast (170–175)
Malignant neoplasm of genitourinary organs (179–189)
Malignant neoplasm of other and unspecified sites (190–199), e.g. eye, brain, spine
Malignant neoplasm of lymphatic and hematopoietic tissue (200–208)
*/

-- 5 drugs for indication: lip, oral cavity, pharynx
-- 0 highprecisionsubset
SELECT COUNT(DISTINCT rxcui_in) FROM (
       SELECT * FROM medi_indication
              WHERE icd9 NOT LIKE '%-%'
              AND icd9 NOT LIKE '%|%'
              AND icd9 !~ '^[A-z]+') AS single_icd9_codes
       WHERE cast(icd9 AS float) >= 140
       AND cast(icd9 AS float) < 150
       AND highprecisionsubset = '1';

-- 116 drugs for digestive organs and peritoneum
-- 23 highprecisionsubset
SELECT COUNT(DISTINCT rxcui_in) FROM (
       SELECT * FROM medi_indication
              WHERE icd9 NOT LIKE '%-%'
              AND icd9 NOT LIKE '%|%'
              AND icd9 !~ '^[A-z]+') AS single_icd9_codes
       WHERE cast(icd9 AS float) >= 150
       AND cast(icd9 AS float) < 160
       AND highprecisionsubset = '1';

-- 62 drugs for respiratory
-- 25 highprecisionsubset
SELECT COUNT(DISTINCT rxcui_in) FROM (
       SELECT * FROM medi_indication
              WHERE icd9 NOT LIKE '%-%'
              AND icd9 NOT LIKE '%|%'
              AND icd9 !~ '^[A-z]+') AS single_icd9_codes
       WHERE cast(icd9 AS float) >= 160
       AND cast(icd9 AS float) < 166
       AND highprecisionsubset = '1';

-- 193 bone, connective tissue, skin, and breast
-- 69 highprecisionsubset
SELECT COUNT(DISTINCT rxcui_in) FROM (
       SELECT * FROM medi_indication
              WHERE icd9 NOT LIKE '%-%'
              AND icd9 NOT LIKE '%|%'
              AND icd9 !~ '^[A-z]+') AS single_icd9_codes
       WHERE cast(icd9 AS float) >= 170
       AND cast(icd9 AS float) < 176
       AND highprecisionsubset = '1';

-- 177 drugs for  genitourinary organs (179–189)
-- 64 highprecisionsubset
SELECT COUNT(DISTINCT rxcui_in) FROM (
       SELECT * FROM medi_indication
              WHERE icd9 NOT LIKE '%-%'
              AND icd9 NOT LIKE '%|%'
              AND icd9 !~ '^[A-z]+') AS single_icd9_codes
       WHERE cast(icd9 AS float) >= 179
       AND cast(icd9 AS float) < 190
       AND highprecisionsubset = '1';
       
-- 213 drugs for other (190–199), e.g. eye, brain, spine
-- 34 highprecisionsubset
SELECT COUNT(DISTINCT rxcui_in) FROM (
       SELECT * FROM medi_indication
              WHERE icd9 NOT LIKE '%-%'
              AND icd9 NOT LIKE '%|%'
              AND icd9 !~ '^[A-z]+') AS single_icd9_codes
       WHERE cast(icd9 AS float) >= 190
       AND cast(icd9 AS float) < 200
       AND highprecisionsubset = '1';

-- 490 drugs for lymphatic and hematopoietic tissue (200–208)
-- 89 highprecisionsubset
SELECT COUNT(DISTINCT rxcui_in) FROM (
       SELECT * FROM medi_indication
              WHERE icd9 NOT LIKE '%-%'
              AND icd9 NOT LIKE '%|%'
              AND icd9 !~ '^[A-z]+') AS single_icd9_codes
       WHERE cast(icd9 AS float) >= 200
       AND cast(icd9 AS float) < 208
       AND highprecisionsubset = '1';
