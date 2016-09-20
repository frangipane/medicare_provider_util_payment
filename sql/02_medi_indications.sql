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

-- How many distinct rxcui_in are there?
-- RxNorm Concept Unique Identifier
-- Drugs with identical RxCUI have same ingredients, strengths, and dose forms.
-- Generic and Branded drugs have different RxCUI.
-- 3112
SELECT COUNT(DISTINCT rxcui_in) FROM medi_indication;


-- How many distinct icd-9 are there?
-- 3009
SELECT COUNT(DISTINCT icd9) FROM medi_indication;


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
