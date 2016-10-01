-- How many orthopedic surgeons in summary?
-- 21301
SELECT COUNT(*)
  FROM summary
  WHERE provider_type = 'Orthopedic Surgery';


-- # of orthopedic surgeons in payments
-- 20652
SELECT COUNT(DISTINCT npi)
  FROM payments
  WHERE provider_type = 'Orthopedic Surgery';


-- Are all orth. surgeons in payments also in summary?
-- yes
SELECT DISTINCT nppes_provider_last_org_name AS name,
       nppes_provider_country AS country
FROM payments
WHERE npi NOT IN
(
        SELECT npi FROM summary
        WHERE provider_type = 'Orthopedic Surgery'
) AND provider_type = 'Orthopedic Surgery';


-- Take a look at providers with largest numbers of beneficiaries
SELECT npi, nppes_provider_last_org_name AS "last name",
       nppes_provider_first_name AS "first name",
       total_unique_benes AS "benef count",
       nppes_provider_gender AS gender
FROM summary
WHERE provider_type = 'Orthopedic Surgery'
ORDER BY total_unique_benes DESC
LIMIT 20;


-- Which location has the most orthopedic surgeons?
-- 200 1st st SW - Rochester, Minnesota - 72
-- 535 E 70th St - New York, NY - 48
SELECT COUNT(*), nppes_provider_street1 AS street,
       nppes_provider_city AS city,
       nppes_provider_state AS state
FROM summary
WHERE provider_type = 'Orthopedic Surgery'
GROUP BY nppes_provider_street1, nppes_provider_city, nppes_provider_state
ORDER BY 1 DESC
LIMIT 20;


-- # of distinct locations
-- 9257
SELECT COUNT(*) FROM
(
        SELECT COUNT(*) AS numdocs
        FROM summary
        WHERE provider_type = 'Orthopedic Surgery'
        GROUP BY nppes_provider_street1, nppes_provider_city, nppes_provider_state
) AS counts_per_loc;


-- 236,084 claims out of facility
SELECT COUNT(*) FROM payments
       WHERE provider_type = 'Orthopedic Surgery'
       AND place_of_service='O';


-- 18,634 doctors made claims out of facility
SELECT COUNT(DISTINCT npi) FROM payments
       WHERE provider_type = 'Orthopedic Surgery'
       AND place_of_service='O';


-- 75,922 claims in facility
SELECT COUNT(*) FROM payments
       WHERE provider_type = 'Orthopedic Surgery'
       AND place_of_service='F';


-- 16,320 doctors made claims in facility
SELECT COUNT(DISTINCT npi) FROM payments
       WHERE provider_type = 'Orthopedic Surgery'
       AND place_of_service='F';
