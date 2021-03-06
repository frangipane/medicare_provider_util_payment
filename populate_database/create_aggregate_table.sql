CREATE TABLE summary (
npi                             varchar(10) PRIMARY KEY,    --"National Provider Identifier"       
nppes_provider_last_org_name    varchar(70),    --"Last Name/Organization Name of the Provider"
nppes_provider_first_name 	varchar(20),    --"First Name of the Provider"
nppes_provider_mi		character(1),	--"Middle Initial of the Provider"
nppes_credentials 		varchar(20),	--"Credentials of the Provider"
nppes_provider_gender 		character(1),	--"Gender of the Provider"
nppes_entity_code 		character(1),	--"Entity Type of the Provider"
nppes_provider_street1 		varchar(55),	--"Street Address 1 of the Provider"
nppes_provider_street2 		varchar(55),    --"Street Address 2 of the Provider"
nppes_provider_city 		varchar(40),	--"City of the Provider"
nppes_provider_zip 		varchar(20),	--"Zip Code of the Provider"
nppes_provider_state 		character(2),	--"State Code of the Provider"
nppes_provider_country 		character(2),	--"Country Code of the Provider"
provider_type	 		varchar(43),	--"Provider Type of the Provider"
medicare_participation_indicator character(1), 	--"Medicare Participation Indicator"
number_of_hcpcs 		int,            --"Number of HCPCS"
total_services 			numeric(11,2),	--"Number of Services"
total_unique_benes 		int,		--"Number of Medicare Beneficiaries"
total_submitted_chrg_amt 	numeric(11,2),	--"Total Submitted Charge Amount"
total_medicare_allowed_amt      numeric(11,2),	--"Total Medicare Allowed Amount"
total_medicare_payment_amt 	numeric(11,2),	--"Total Medicare Payment Amount"
total_medicare_stnd_amt		numeric(11,2),	--"Total Medicare Standardized Payment Amount"
drug_suppress_indicator 	character(1),	--"Drug Suppress Indicator"
number_of_drug_hcpcs 		int,		--"Number of HCPCS Associated With Drug Services"
total_drug_services 		numeric(11,2),		--"Number of Drug Services"
total_drug_unique_benes 	int,		--"Number of Medicare Beneficiaries With Drug Services"
total_drug_submitted_chrg_amt 	numeric(11,2),	--"Total Drug Submitted Charge Amount"
total_drug_medicare_allowed_amt numeric(11,2),	--"Total Drug Medicare Allowed Amount"
total_drug_medicare_payment_amt numeric(11,2),	--"Total Drug Medicare Payment Amount"
total_drug_medicare_stnd_amt 	numeric(11,2),	--"Total Drug Medicare Standardized Payment Amount"
med_suppress_indicator 		character(1),	--"Medical Suppress Indicator"
number_of_med_hcpcs 		int,		--"Number of HCPCS Associated With Medical Services"
total_med_services 		numeric(11,2),		--"Number of Medical Services"
total_med_unique_benes 		int,		--"Number of Medicare Beneficiaries With Medical Services"
total_med_submitted_chrg_amt 	numeric(11,2),	--"Total Medical Submitted Charge Amount"
total_med_medicare_allowed_amt 	numeric(11,2),	--"Total Medical Medicare Allowed Amount"
total_med_medicare_payment_amt 	numeric(11,2),	--"Total Medical Medicare Payment Amount"
total_med_medicare_stnd_amt 	numeric(11,2),	--"Total Medical Medicare Standardized Payment Amount"
beneficiary_average_age		int,            --"Average Age of Beneficiaries"
beneficiary_age_less_65_count 	int,            --"Number of Beneficiaries Age Less 65"
beneficiary_age_65_74_count 	int,            --"Number of Beneficiaries Age 65 to 74"
beneficiary_age_75_84_count	int,		--"Number of Beneficiaries Age 75 to 84"
beneficiary_age_greater_84_count int,           --"Number of Beneficiaries Age Greater 84"
beneficiary_female_count 	int,		--"Number of Female Beneficiaries"
beneficiary_male_count		int,		--"Number of Male Beneficiaries"
beneficiary_race_white_count 	int,            --"Number of Non-Hispanic White Beneficiaries"
beneficiary_race_black_count 	int,            --"Number of Black or African American Beneficiaries"
beneficiary_race_api_count	int,		--"Number of Asian Pacific Islander Beneficiaries"
beneficiary_race_hispanic_count int,            --"Number of Hispanic Beneficiaries"
beneficiary_race_natind_count 	int,	        --"Number of American Indian/Alaska Native Beneficiaries"
beneficiary_race_other_count	int,            --"Number of Beneficiaries With Race Not Elsewhere Classified"
beneficiary_nondual_count 	int,		--"Number of Beneficiaries With Medicare Only Entitlement"
beneficiary_dual_count 		int,		--"Number of Beneficiaries With Medicare & Medicaid Entitlement"
beneficiary_cc_afib_percent	int,		--"Percent (%) of Beneficiaries Identified With Atrial Fibrillation"
beneficiary_cc_alzrdsd_percent 	int,            --"Percent (%) of Beneficiaries Identified With Alzheimers Disease or Dementia"
beneficiary_cc_asthma_percent 	int,            --"Percent (%) of Beneficiaries Identified With Asthma"
beneficiary_cc_cancer_percent	int,            --"Percent (%) of Beneficiaries Identified With Cancer"
beneficiary_cc_chf_percent 	int,		--"Percent (%) of Beneficiaries Identified With Heart Failure"
beneficiary_cc_ckd_percent 	int,		--"Percent (%) of Beneficiaries Identified With Chronic Kidney Disease"
beneficiary_cc_copd_percent	int,		--"Percent (%) of Beneficiaries Identified With Chronic Obstructive Pulmonary Disease"
beneficiary_cc_depr_percent 	int,            --"Percent (%) of Beneficiaries Identified With Depression"
beneficiary_cc_diab_percent 	int,            --"Percent (%) of Beneficiaries Identified With Diabetes"
beneficiary_cc_hyperl_percent	int,            --"Percent (%) of Beneficiaries Identified With Hyperlipidemia"
beneficiary_cc_hypert_percent 	int,    	--"Percent (%) of Beneficiaries Identified With Hypertension"
beneficiary_cc_ihd_percent 	int,		--"Percent (%) of Beneficiaries Identified With Ischemic Heart Disease"
beneficiary_cc_ost_percent	int,		--"Percent (%) of Beneficiaries Identified With Osteoporosis"
beneficiary_cc_raoa_percent 	int,            --"Percent (%) of Beneficiaries Identified With Rheumatoid Arthritis / Osteoarthritis"
beneficiary_cc_schiot_percent 	int,	        --"Percent (%) of Beneficiaries Identified With Schizophrenia / Other Psychotic Disorders"
beneficiary_cc_strk_percent	int,		--"Percent (%) of Beneficiaries Identified With Stroke"
beneficiary_average_risk_score	numeric(6,4)	--"Average HCC Risk Score of Beneficiaries"
);
