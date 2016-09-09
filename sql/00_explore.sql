-- How many records are in table summary?
-- 986,677
SELECT COUNT(*) FROM summary;

-- How many records in table payments?
-- 9,316,308
SELECT COUNT(*) FROM payments;

-- How many (distinct) doctors made claims?
-- 938,147
SELECT COUNT(DISTINCT npi) FROM payments;

-- Average number of rows per doctor in payments?
-- 9.9305
SELECT AVG(pyments)
FROM (
  SELECT COUNT(*) AS pyments
    FROM payments
    GROUP BY npi
) AS stupidalias;


-- Average number of total services per doctor?
-- 2685.5
SELECT AVG(total_services)
FROM summary;

-- Average total submitted charge amount per doctor?
-- 332,604.9
SELECT AVG(total_submitted_chrg_amt)
FROM summary;

-- Max total submitted charge amount?
-- 831,446,834.6
SELECT MAX(total_submitted_chrg_amt)
FROM summary;

-- Min total submitted charge amount?
-- 45.00
SELECT MIN(total_submitted_chrg_amt)
FROM summary;


-- Average total medicare standardized amount?
-- 82,349.5
SELECT AVG(total_med_medicare_stnd_amt)
FROM summary;

-- Max total medicare standardized amount?
-- 163,400,728.2
SELECT MAX(total_med_medicare_stnd_amt)
FROM summary;

-- Min total medicare standardized amount?
-- 0.00
SELECT MIN(total_med_medicare_stnd_amt)
FROM summary;

-- Which doctors had 0 payments from medicare based on standardized amt?
-- 36 (all in the U.S.), all participating in medicare, with
-- non-zero total_services.
SELECT npi, nppes_provider_state AS state,
       nppes_provider_country AS country,
       medicare_participation_indicator AS paricipates,
       total_services,
       total_unique_benes
  FROM summary
  WHERE total_med_medicare_stnd_amt = 0;

-- What are the names of these providers with no payment?
-- seem associated with mostly government organizations, e.g. COUNTY OF ..., and
-- some private orgs, e.g. COSTCO or CAREMARK/CVS.
SELECT nppes_provider_last_org_name AS name,
       total_unique_benes
  FROM summary
  WHERE total_med_medicare_stnd_amt = 0;

-- How many states are represented in summary?
-- 61
SELECT COUNT(DISTINCT nppes_provider_state)
  FROM summary;

-- Look at the states with the least representation?
SELECT nppes_provider_state, COUNT(*)
  FROM summary
  GROUP BY nppes_provider_state,
  ORDER BY COUNT(*) ASC
  LIMIT 10;

-- How many countries are in summary?
-- 25
SELECT DISTINCT nppes_provider_country AS country
  FROM summary;

-- How many providers are not in the US?
-- 73
SELECT COUNT(DISTINCT npi) FROM summary
  WHERE nppes_provider_country != 'US';

-- Are there non-US providers in the payments table?
-- There are 61 non-US providers in the payments table
SELECT COUNT(DISTINCT npi) FROM payments
  WHERE nppes_provider_country != 'US';


-- How many provider types are there?
SELECT DISTINCT provider_type FROM summary;

-- How many entries contain "oncology"?
/* 
Surgical Oncology
Hematology/Oncology
Gynecological/Oncology
Radiation Oncology
Medical Oncology 
*/
SELECT DISTINCT provider_type FROM summary
  WHERE provider_type LIKE '%Oncology';
