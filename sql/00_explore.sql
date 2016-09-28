-- How many records are in table summary?
-- 986,677
SELECT COUNT(*) FROM summary;

-- How many records in table payments?
-- 9,316,308
SELECT COUNT(*) FROM payments;

-- How many (distinct) doctors made claims?
-- 938,147
SELECT COUNT(DISTINCT npi) FROM payments;


-- How many (distinct) hcpcs codes?
-- 5972
SELECT COUNT(DISTINCT hcpcs_code) FROM payments;


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
-- 91
/*
                provider_type                
---------------------------------------------
 Internal Medicine
 Hematology/Oncology
 Certified Clinical Nurse Specialist
 Pediatric Medicine
 Emergency Medicine
 General Surgery
 Vascular Surgery
 Public Health Welfare Agency
 Endocrinology
 Osteopathic Manipulative Medicine
 Gynecological/Oncology
 Sleep Medicine
 General Practice
 Mass Immunization Roster Biller
 Radiation Therapy
 Centralized Flu
 Clinical Laboratory
 Physician Assistant
 Ambulatory Surgical Center
 Preventive Medicine
 Diagnostic Radiology
 Chiropractic
 Independent Diagnostic Testing Facility
 Unknown Physician Specialty Code
 Hand Surgery
 Maxillofacial Surgery
 Occupational therapist
 Speech Language Pathologist
 Registered Dietician/Nutrition Professional
 Allergy/Immunology
 Medical Oncology
 Interventional Pain Management
 Multispecialty Clinic/Group Practice
 Urology
 Slide Preparation Facility
 Addiction Medicine
 Thoracic Surgery
 Cardiac Surgery
 Pulmonary Disease
 Plastic and Reconstructive Surgery
 Ophthalmology
 Gastroenterology
 Otolaryngology
 Colorectal Surgery (formerly proctology)
 CRNA
 Rheumatology
 Sports Medicine
 Nuclear Medicine
 Cardiac Electrophysiology
 Neurosurgery
 Anesthesiology
 Neuropsychiatry
 Obstetrics/Gynecology
 Pharmacy
 All Other Suppliers
 Psychiatry
 Interventional Radiology
 Certified Nurse Midwife
 Physical Medicine and Rehabilitation
 Physical Therapist
 Pain Management
 Hematology
 Audiologist (billing independently)
 Hospice and Palliative Care
 Licensed Clinical Social Worker
 Clinical Psychologist
 Peripheral Vascular Disease
 Geriatric Medicine
 Oral Surgery (dentists only)
 Nephrology
 Family Practice
 Podiatry
 Neurology
 Cardiology
 Surgical Oncology
 Orthopedic Surgery
 Portable X-ray
 Radiation Oncology
 Interventional Cardiology
 Ambulance Service Supplier
 Critical Care (Intensivists)
 Anesthesiologist Assistants
 Unknown Supplier/Provider
 Dermatology
 Infectious Disease
 Mammographic Screening Center
 Geriatric Psychiatry
 Nurse Practitioner
 Psychologist (billing independently)
 Pathology
 Optometry
*/
SELECT COUNT(DISTINCT provider_type) FROM summary;

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


-- Which entries contain 'surgery'?
-- 11 entries
/*
Neurosurgery
 Maxillofacial Surgery
 Oral Surgery (dentists only)
 Plastic and Reconstructive Surgery
 Thoracic Surgery
 Cardiac Surgery
 Hand Surgery
 General Surgery
 Colorectal Surgery (formerly proctology)
 Orthopedic Surgery
 Vascular Surgery
*/
SELECT DISTINCT provider_type FROM summary
  WHERE provider_type ILIKE '%Surgery%';


-- How many rows for general surgery?
-- 19905
SELECT COUNT(*) FROM summary
  WHERE provider_type ILIKE '%General Surgery%';


-- How many rows for orthopedic surgery?
-- 21301
SELECT COUNT(*) FROM summary
  WHERE provider_type ILIKE '%Orthopedic Surgery%';

-- How many distinct states for orthopedic surgery?
-- 56
SELECT COUNT(DISTINCT nppes_provider_state) FROM summary
  WHERE provider_type ILIKE '%Orthopedic Surgery%';


-- npis from LEIE

-- Licensed Clinical Social Worker
SELECT provider_type FROM summary
  WHERE npi='1174706295';

-- Internal Medicine
SELECT provider_type FROM summary
  WHERE npi='1972607398';

-- Family Practice
SELECT provider_type FROM summary
  WHERE npi='1861487308';
