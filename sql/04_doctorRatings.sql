-- How many orthopedic surgeons in medicare 'summary' table
-- are also in doctor_ratings table,
-- i.e. are on checkbook.org/surgeonratings
-- 3556
SELECT COUNT(*) FROM doctor_ratings;


-- How many distinct zip codes are in doctor_ratings?
-- 2327
SELECT COUNT(DISTINCT zipcode) FROM doctor_ratings;


-- How many doctors have been recommended by other doctors?
-- 339
SELECT COUNT(*) FROM doctor_ratings
  WHERE recommended_by_doctors NOT LIKE '';


-- What cities do doctors having referrals belong to?
-- there are 192 cities
SELECT DISTINCT summary.nppes_provider_city
  FROM doctor_ratings
  JOIN summary
    ON (summary.npi = doctor_ratings.npi)
  WHERE doctor_ratings.recommended_by_doctors NOT LIKE '';


-- What states do doctors having referrals belong to?
-- 32 states
SELECT DISTINCT summary.nppes_provider_state
  FROM doctor_ratings
       JOIN summary
       ON (summary.npi = doctor_ratings.npi)
  WHERE doctor_ratings.recommended_by_doctors NOT LIKE '';


-- How many doctors with referrals per state?
-- First few rows, ordered by descending # of counts:
/*
 nppes_provider_city | counts 
---------------------+--------
 LOUISVILLE          |      7
 NAPLES              |      6
 SCOTTSDALE          |      6
 SACRAMENTO          |      6
 CINCINNATI          |      6
 PORTLAND            |      6
 JACKSONVILLE        |      5
 AUSTIN              |      5
 HARTFORD            |      5
 NASHVILLE           |      5
 ATLANTA             |      5
 OVERLAND PARK       |      4
 EDINA               |      4
 BALTIMORE           |      4
 LEAWOOD             |      4
 LA JOLLA            |      4
*/
SELECT summary.nppes_provider_city, COUNT(*) AS counts
  FROM doctor_ratings
       JOIN summary
       ON (summary.npi = doctor_ratings.npi)
  WHERE doctor_ratings.recommended_by_doctors NOT LIKE ''
  GROUP BY summary.nppes_provider_city
  ORDER BY counts DESC;


-- How many distinct recommended_by_doctors ratings exist?
-- 18, including null. Max is 29
SELECT DISTINCT recommended_by_doctors FROM doctor_ratings;


-- Who has 29 referrals?
-- Bonner, Kevin Francis (Virginia Beach, VA)
-- Interesting: his relative_volume is 'lower volume'
SELECT * FROM doctor_ratings
  WHERE recommended_by_doctors = '29';

/*
-- Max number of recommendations?
SELECT referral_nums::int FROM
(
  SELECT DISTINCT recommended_by_doctors FROM doctor_ratings
) AS referral_nums;
*/

-- Counts per confidence rating?
SELECT COUNT(*)
  FROM doctor_ratings
  GROUP BY confidence;


-- Who has the highest number of doctor referrals?
SELECT * FROM doctor_ratings





SELECT MAX( CAST (recommended_by_doctors as numeric) ) FROM doctor_ratings;









-- How many distinct cities are in doctor_ratings? (need to join on summary table)
SELECT COUNT(DISTINCT ) FROM
