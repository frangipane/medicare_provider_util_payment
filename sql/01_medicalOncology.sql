-- How many medical oncologists are there in summary?
-- 2849
SELECT COUNT(DISTINCT npi)
  FROM summary
  WHERE provider_type = 'Medical Oncology';


-- # of medical oncologists in payments:
-- 2795
SELECT COUNT(DISTINCT npi)
  FROM payments
  WHERE provider_type = 'Medical Oncology';


-- Are all medical oncos. in payments also in summary?
-- no
SELECT DISTINCT nppes_provider_last_org_name AS name,
       nppes_provider_country AS country
FROM payments
WHERE npi NOT IN
(
        SELECT npi FROM summary
        WHERE provider_type = 'Medical Oncology'
) AND provider_type = 'Medical Oncology';


-- Which medical oncos. are in summary but not payments?
-- there are 54
SELECT DISTINCT nppes_provider_last_org_name AS name,
       nppes_provider_country AS country
FROM summary
WHERE npi NOT IN
(
        SELECT npi FROM payments
        WHERE provider_type = 'Medical Oncology'
) AND provider_type = 'Medical Oncology';


-- Take a look at providers with largest numbers of beneficiaries
SELECT npi, nppes_provider_last_org_name AS "last name",
       nppes_provider_first_name AS "first name",
       total_unique_benes AS "benef count",
       nppes_provider_gender AS gender
FROM summary
WHERE provider_type = 'Medical Oncology'
ORDER BY total_unique_benes DESC
LIMIT 20;

-- how many male oncologists?
-- 1988
SELECT COUNT(*) FROM summary
WHERE nppes_provider_gender = 'M'
AND provider_type = 'Medical Oncology';


-- how many female oncologists?
-- 861
SELECT COUNT(*) FROM summary
WHERE nppes_provider_gender = 'F'
AND provider_type = 'Medical Oncology';


-- Are there oncologists in every state?
-- 53
-- extra 3 come from: PR - puerto rico, GU - guam, DC - washington DC
SELECT DISTINCT nppes_provider_state,
       nppes_provider_country
FROM summary
WHERE provider_type = 'Medical Oncology';


-- How many oncologists are there per state?
-- Interesting although CA has almost 2x population of NY, NY has almost
-- 2x the number of medical oncologists.
SELECT nppes_provider_state AS state, COUNT(*) FROM summary
WHERE provider_type = 'Medical Oncology'
GROUP BY nppes_provider_state
ORDER BY 2 DESC;


-- How many rows in payments correspond to medical oncologists?
-- 53,502
SELECT COUNT(*) FROM payments
WHERE provider_type = 'Medical Oncology';


-- How many distinct oncologist addresses are there in summary table?
-- 1577 (whereas there are 2849 providers)
SELECT COUNT(*) FROM
(
        SELECT DISTINCT nppes_provider_street1, nppes_provider_zip
        FROM summary
        WHERE provider_type = 'Medical Oncology'
) AS fargle;


-- Which location has the most oncologists?
-- New York (interesting, no locations in CA in top 20 counts)
SELECT COUNT(*), nppes_provider_street1 AS street,
       nppes_provider_city AS city,
       nppes_provider_state AS state
FROM summary
WHERE provider_type = 'Medical Oncology'
GROUP BY nppes_provider_street1, nppes_provider_city, nppes_provider_state
ORDER BY 1 DESC
LIMIT 20;


-- How many locations have just 1 oncologist?
-- 1099 (out of 2849 oncologists), so there are roughly 2x as many oncologists
-- in multi-onc. site vs single oncologist site. 
SELECT COUNT(*) FROM
(
        SELECT COUNT(*) AS numdocs
        FROM summary
        WHERE provider_type = 'Medical Oncology'
        GROUP BY nppes_provider_street1, nppes_provider_city, nppes_provider_state
) AS counts_per_loc
WHERE counts_per_loc.numdocs = 1;

-- # locations with > 1 oncologist:
-- 398
SELECT COUNT(*) FROM
(
        SELECT COUNT(*) AS numdocs
        FROM summary
        WHERE provider_type = 'Medical Oncology'
        GROUP BY nppes_provider_street1, nppes_provider_city, nppes_provider_state
) AS counts_per_loc
WHERE counts_per_loc.numdocs > 1;


-- # of distinct locations
-- 1497 (compare to when grouping just by street1 and zip, i.e. 1577)
SELECT COUNT(*) FROM
(
        SELECT COUNT(*) AS numdocs
        FROM summary
        WHERE provider_type = 'Medical Oncology'
        GROUP BY nppes_provider_street1, nppes_provider_city, nppes_provider_state
) AS counts_per_loc;
