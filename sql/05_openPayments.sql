-- 5064 distinct medical oncologists
-- (out of 66,585 rows)
SELECT COUNT(DISTINCT Physician_Profile_ID)
  FROM openpayments_general_payments
  WHERE Physician_Specialty ILIKE '%Medical Oncology%';

-- 384 distinct drug/biologicals1 that are covered
SELECT COUNT(DISTINCT Name_of_Associated_Covered_Drug_or_Biological1)
  FROM openpayments_general_payments
  WHERE Physician_Specialty ILIKE '%Medical Oncology%'
  AND Product_Indicator = 'Covered';

-- 400 distinct drug/biologicals1 (all types)
SELECT COUNT(DISTINCT Name_of_Associated_Covered_Drug_or_Biological1)
  FROM openpayments_general_payments
  WHERE Physician_Specialty ILIKE '%Medical Oncology%';

-- 20 of the most frequently occurring drug/biological1 payments for medical oncology
/*
 name_of_associated_covered_drug_or_biological1 | cnt  
------------------------------------------------+------
 Abraxane                                       | 4329
 Revlimid                                       | 3705
 YERVOY                                         | 3112
 Avastin                                        | 2596
 AFINITOR                                       | 2154
 GILOTRIF                                       | 2066
 SPRYCEL                                        | 1965
 ALIMTA                                         | 1933
 ERBITUX                                        | 1876
 Perjeta                                        | 1724
 JAKAFI                                         | 1518
 VOTRIENT                                       | 1369
 Zytiga                                         | 1188
 XTANDI                                         | 1064
 INLYTA                                         | 1024
 VELCADE                                        |  943
 ARZERRA                                        |  905
 XALKORI                                        |  861
 Neulasta                                       |  839
 Rituxan                                        |  787
*/
SELECT Name_of_Associated_Covered_Drug_or_Biological1, COUNT(*) AS cnt
  FROM openpayments_general_payments
  WHERE Physician_Specialty ILIKE '%Medical Oncology%'
  AND Product_Indicator = 'Covered'
  GROUP BY Name_of_Associated_Covered_Drug_or_Biological1
  ORDER BY 2 DESC
  LIMIT 20;

-- Medical oncologists claimed "Injection, paclitaxel protein-bound particles, 1 mg"
-- 64 times in payments table.
SELECT COUNT(*) FROM payments
  WHERE hcpcs_code = 'J9264'
  AND provider_type = 'Medical Oncology';

-- generic paclitaxel (Injection, paclitaxel, 30 mg): hcpcs_code = J9265
-- claimed 359 times in payments table.
SELECT COUNT(*) FROM payments
  WHERE hcpcs_code = 'J9265'
  AND provider_type = 'Medical Oncology';

-- 20 of the most frequently occurring drug/biological1 payments for orthopedic surgeons
/*
 name_of_associated_covered_drug_or_biological1 |  cnt   
------------------------------------------------+--------
                                                | 231323
 DUEXIS                                         |   7448
 Xartemis XR                                    |   6674
 CELEBREX                                       |   4855
 VIMOVO                                         |   3912
 FORTEO                                         |   3761
 ZORVOLEX                                       |   2828
 ELIQUIS                                        |   2314
 XIAFLEX                                        |   2288
 Exparel                                        |   2148
 FLECTOR PATCH                                  |   1558
 OXYCONTIN                                      |   1492
 Xarelto                                        |   1462
 UE - Aequalis Ascend Flex                      |   1029
 Ofirmev                                        |    901
 Equinoxe                                       |    877
 Spinal Implant                                 |    771
 Prolia                                         |    737
 Pennsaid 2 percent Topical Solution            |    656
 AMRIX                                          |    636
*/
SELECT Name_of_Associated_Covered_Drug_or_Biological1, COUNT(*) AS cnt
  FROM openpayments_general_payments
  WHERE Physician_Specialty ILIKE 'Allopathic & Osteopathic Physicians|Orthopaedic Surgery%'
  AND Product_Indicator = 'Covered'
  GROUP BY Name_of_Associated_Covered_Drug_or_Biological1
  ORDER BY 2 DESC
  LIMIT 20;


-- some examples of physician specialties with 'orthopaed' in them
/*
Allopathic & Osteopathic Physicians|Orthopaedic Surgery|Adult Reconstructive Orthopaedic Surgery
Allopathic & Osteopathic Physicians|Orthopaedic Surgery|Foot and Ankle Surgery
Allopathic & Osteopathic Physicians|Orthopaedic Surgery
Allopathic & Osteopathic Physicians|Orthopaedic Surgery|Orthopaedic Surgery of the Spine
Allopathic & Osteopathic Physicians|Orthopaedic Surgery|Orthopaedic Trauma
*/
SELECT DISTINCT Physician_Specialty
  FROM openpayments_general_payments
  WHERE Physician_Specialty ILIKE '%orthopaed%'
  LIMIT 5;

-- 22,214 distinct orthopedic surgeons in open payments
SELECT COUNT(DISTINCT Physician_Profile_ID)
  FROM openpayments_general_payments
  WHERE Physician_Specialty ILIKE 'Allopathic & Osteopathic Physicians|Orthopaedic Surgery%';

-- celebrex, a pain med : hcpcs_code = J3490
-- occurs in conjunction with payments to orthopedic surgeons 4855 times
SELECT COUNT(*)
  FROM openpayments_general_payments
  WHERE Physician_Specialty ILIKE 'Allopathic & Osteopathic Physicians|Orthopaedic Surgery%'
  AND Product_Indicator = 'Covered'
  AND Name_of_Associated_Covered_Drug_or_Biological1 ILIKE '%celebrex%';


-- celebrex is claimed 62 times by orthopedic surgeons in medicare payments table
SELECT COUNT(*)
  FROM payments
  WHERE hcpcs_code = 'J3490'
  AND provider_type = 'Orthopedic Surgery';


-- Duexis, pain med: hcpcs_code = J8499
-- the most often occuring drug/biological in open payments to orthopedic surgeons
-- Occurs 0 times in payments table!
SELECT COUNT(*)
  FROM payments
  WHERE hcpcs_code = 'J8499'
  AND provider_type = 'Orthopedic Surgery';


-- Xartemis XR (oxycodone based), 2nd most frequently occuring in open payments database
-- for orthopedic surgeons
-- hcpcs_code is also lumped under J8499.  This code does not appear in medicare payments table.



-- Top 20 device/medical supply open payments to orthopedic surgeons.
/*
 name_of_associated_covered_device_or_medical_supply1 |  cnt  
------------------------------------------------------+-------
                                                      | 55296
 TRAUMA & EXTREMITIES                                 | 13606
 Spine                                                | 12460
 KNEES                                                | 11195
 HIPS                                                 | 10908
 Trauma                                               |  7559
 Ortho-Knees                                          |  6346
 HIP                                                  |  6255
 ThoracoLumbar                                        |  6030
 Extremities                                          |  5999
 EUFLEXXA                                             |  5847
 Knee                                                 |  5087
 Thoracolumbar - TL Therapies                         |  4587
 ALL ARTHREX PRODUCT LINES                            |  4230
 FootandAnkle                                         |  4158
 Osteoarthritis of the knee                           |  4139
 Orthopedics                                          |  4083
 Sports Medicine                                      |  3677
 Spinal Implant                                       |  3501
 Ultrasound Bone Healing                              |  3257
*/
SELECT Name_of_Associated_Covered_Device_or_Medical_Supply1, COUNT(*) AS cnt
  FROM openpayments_general_payments
  WHERE Physician_Specialty ILIKE 'Allopathic & Osteopathic Physicians|Orthopaedic Surgery%'
  AND Product_Indicator = 'Covered'
  GROUP BY Name_of_Associated_Covered_Device_or_Medical_Supply1
  ORDER BY 2 DESC
  LIMIT 20;

-- EUFLEXXA: hcpcs_code is J7323
-- occurs 5847 times in open payments
-- claimed 1550 times in medicare payments table
SELECT COUNT(*)
  FROM payments
  WHERE hcpcs_code = 'J7323'
  AND provider_type = 'Orthopedic Surgery';

-- euflexxa claimed by 1550 distinct othorpedic surgeons
SELECT COUNT(DISTINCT npi)
  FROM payments
  WHERE hcpcs_code = 'J7323'
  AND provider_type = 'Orthopedic Surgery';


-- 2068 distinct orthopedic surgeons received open payments for euflexxa
SELECT COUNT(DISTINCT Physician_Profile_ID)
  FROM openpayments_general_payments
  WHERE Physician_Specialty ILIKE 'Allopathic & Osteopathic Physicians|Orthopaedic Surgery%'
  AND Name_of_Associated_Covered_Device_or_Medical_Supply1 ='EUFLEXXA' ;
