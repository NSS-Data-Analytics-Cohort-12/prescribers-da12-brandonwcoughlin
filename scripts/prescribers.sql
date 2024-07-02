-- ## Prescribers Database

-- For this exericse, you'll be working with a database derived from the [Medicare Part D Prescriber Public Use File](https://www.hhs.gov/guidance/document/medicare-provider-utilization-and-payment-data-part-d-prescriber-0). More information about the data is contained in the Methodology PDF file. See also the included entity-relationship diagram.

-- 1. 
--     a. Which prescriber had the highest total number of claims (totaled over all drugs)? Report the npi and the total number of claims.

-- select p1.nppes_provider_first_name as first_name,
-- 	p1.nppes_provider_last_org_name as last_name,
-- 	p2.total_claim_count,
-- 	p1.npi
-- from prescriber as p1
-- join prescription as p2
-- 	on p1.npi = p2.npi
-- group by first_name, last_name, p2.total_claim_count, p1.npi
-- order by p2.total_claim_count desc;

-- David Coffey - 4538 - 1912011792

--     b. Repeat the above, but this time report the nppes_provider_first_name, nppes_provider_last_org_name, specialty_description, and the total number of claims.

-- select p1.nppes_provider_first_name as first_name,
-- 	p1.nppes_provider_last_org_name as last_name,
-- 	p2.total_claim_count,
-- 	p1.specialty_description,
-- 	p2.total_claim_count_ge65
-- from prescriber as p1
-- join prescription as p2
-- 	on p1.npi = p2.npi	
-- group by first_name, last_name, p2.total_claim_count, p1.specialty_description, p2.total_claim_count_ge65
-- order by p2.total_claim_count desc;

-----The above was my first try before researching the group by clause.

-- select p1.nppes_provider_first_name as first_name,
-- 	p1.nppes_provider_last_org_name as last_name,
-- 	count(p2.total_claim_count) as claim_count,
-- 	p1.specialty_description
-- from prescriber as p1
-- join prescription as p2
-- 	on p1.npi = p2.npi	
-- group by first_name, last_name, p1.specialty_description, p2.total_claim_count_ge65
-- order by claim_count desc;

-----The above is my answer after researching the group by clause.

-- 2. 
--     a. Which specialty had the most total number of claims (totaled over all drugs)?

-- select p1.specialty_description,
-- 	count(p2.total_claim_count) as claim_count
-- from prescriber as p1
-- join prescription as p2
-- on p1.npi = p2.npi
-- group by p1.specialty_description
-- order by claim_count desc;

-----I feel like I used Group By well here. This is when I started understanding a bit more. 

-----Nurse Practicioner - 164609

--     b. Which specialty had the most total number of claims for opioids?

-- select p1.specialty_description,
-- 	count(d.opioid_drug_flag) as opioid_count
-- from prescriber as p1
-- join prescription as p2
-- on p1.npi = p2.npi
-- join drug as d
-- on p2.drug_name = d.drug_name
-- where d.opioid_drug_flag like 'Y'
-- group by p1.specialty_description
-- order by opioid_count desc;

-----Nurse Practicioner

--     c. **Challenge Question:** Are there any specialties that appear in the prescriber table that have no associated prescriptions in the prescription table?

-- SELECT DISTINCT specialty_description
-- FROM prescriber
-- WHERE specialty_description NOT IN (
-- 	SELECT specialty_description
-- 	FROM prescriber
-- 	INNER JOIN prescription
-- 	USING(npi)
-- );

--     d. **Difficult Bonus:** *Do not attempt until you have solved all other problems!* For each specialty, report the percentage of total claims by that specialty which are for opioids. Which specialties have a high percentage of opioids?

-- SELECT
-- 	specialty_description,
-- 	SUM(
-- 		CASE WHEN opioid_drug_flag = 'Y' THEN total_claim_count
-- 		ELSE 0
-- 	END
-- 	) as opioid_claims,
-- 	SUM(total_claim_count) AS total_claims,
-- 	SUM(
-- 		CASE WHEN opioid_drug_flag = 'Y' THEN total_claim_count
-- 		ELSE 0
-- 	END
-- 	) * 100.0 /  SUM(total_claim_count) AS opioid_percentage
-- FROM prescriber
-- INNER JOIN prescription
-- USING(npi)
-- INNER JOIN drug
-- USING(drug_name)
-- GROUP BY specialty_description
-- ORDER BY opioid_percentage DESC;


-- 3. 
--     a. Which drug (generic_name) had the highest total drug cost?

-- select d.generic_name,
-- 	p2.total_drug_cost
-- from drug as d
-- join prescription as p2
-- on d.drug_name = p2.drug_name
-- order by p2.total_drug_cost desc;

-- Pirfenidone - 2829174.3

--     b. Which drug (generic_name) has the hightest total cost per day? **Bonus: Round your cost per day column to 2 decimal places. Google ROUND to see how this works.**

-- SELECT 
-- 	generic_name, 
-- 	SUM(total_drug_cost) / SUM(total_day_supply) AS total_cost_per_day
-- FROM prescription
-- INNER JOIN drug
-- USING(drug_name)
-- GROUP BY generic_name
-- ORDER BY total_cost_per_day DESC;

-- 4. 
--     a. For each drug in the drug table, return the drug name and then a column named 'drug_type' which says 'opioid' for drugs which have opioid_drug_flag = 'Y', says 'antibiotic' for those drugs which have antibiotic_drug_flag = 'Y', and says 'neither' for all other drugs. **Hint:** You may want to use a CASE expression for this. See https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-case/ 

-- select drug_name, opioid_drug_flag, antibiotic_drug_flag,
-- 	case when opioid_drug_flag = 'Y' then 'opioid'
-- 	when antibiotic_drug_flag = 'Y' then 'antibiotic'
-- 	else 'neither' end as neither
-- from drug
-- order by drug_name

--     b. Building off of the query you wrote for part a, determine whether more was spent (total_drug_cost) on opioids or on antibiotics. Hint: Format the total costs as MONEY for easier comparision.

-- select
-- 	case when opioid_drug_flag = 'Y' then 'opioid'
-- 	when antibiotic_drug_flag = 'Y' then 'antibiotic'
-- 	else 'neither' end as neither,
-- 	sum(total_drug_cost) as total_cost
-- from drug
-- join prescription
-- on drug.drug_name = prescription.drug_name
-- group by neither
-- order by total_cost

-- 5. 
--     a. How many CBSAs are in Tennessee? **Warning:** The cbsa table contains information for all states, not just Tennessee.

-- SELECT COUNT(*)
-- FROM cbsa
-- INNER JOIN fips_county
-- USING(fipscounty)
-- WHERE state = 'TN';	

-----42

--     b. Which cbsa has the largest combined population? Which has the smallest? Report the CBSA name and total population. (this will be a union)

-- SELECT cbsaname, SUM(population) AS total_population
-- FROM cbsa 
-- INNER JOIN population
-- USING(fipscounty)
-- GROUP BY cbsaname
-- ORDER BY total_population DESC;

-- select cbsaname, min(population) as min_pop
-- from cbsa
-- join fips_county
-- on cbsa.fipscounty = fips_county.fipscounty
-- join population
-- on fips_county.fipscounty = population.fipscounty
-- 	group by cbsaname
-- order by min_pop asc;

-----Nashville-Davidson--Murfreesboro--Franklin,TN - 8773


--     c. What is the largest (in terms of population) county which is not included in a CBSA? Report the county name and population.

-- SELECT county, population
-- FROM fips_county
-- INNER JOIN population
-- USING(fipscounty)
-- WHERE fipscounty NOT IN (
-- 	SELECT fipscounty
-- 	FROM cbsa
-- )
-- ORDER BY population DESC;

-- 6. 
--     a. Find all rows in the prescription table where total_claims is at least 3000. Report the drug_name and the total_claim_count.

-- select drug_name,
-- 	total_claim_count
-- from prescription
-- where total_claim_count >= 3000

--     b. For each instance that you found in part a, add a column that indicates whether the drug is an opioid.

-- select p2.drug_name,
-- 	p2.total_claim_count,
-- 	d.opioid_drug_flag
-- from prescription as p2
-- join drug as d
-- on p2.drug_name = d.drug_name	
-- where p2.total_claim_count >= 3000
-- order by p2.drug_name


--     c. Add another column to you answer from the previous part which gives the prescriber first and last name associated with each row.

-- select p2.drug_name,
-- 	p2.total_claim_count,
-- 	d.opioid_drug_flag,
-- 	p1.nppes_provider_first_name,
-- 	p1.nppes_provider_last_org_name
-- from prescription as p2
-- join drug as d
-- on p2.drug_name = d.drug_name
-- join prescriber as p1
-- on p2.npi = p1.npi	
-- where p2.total_claim_count >= 3000
-- order by p2.drug_name

-- 7. The goal of this exercise is to generate a full list of all pain management specialists in Nashville and the number of claims they had for each opioid. **Hint:** The results from all 3 parts will have 637 rows.

--     a. First, create a list of all npi/drug_name combinations for pain management specialists (specialty_description = 'Pain Management) in the city of Nashville (nppes_provider_city = 'NASHVILLE'), where the drug is an opioid (opiod_drug_flag = 'Y'). **Warning:** Double-check your query before running it. You will only need to use the prescriber and drug tables since you don't need the claims numbers yet.

-- select npi, specialty_description, drug_name
-- from prescriber, drug
-- where upper(specialty_description) = 'PAIN MANAGEMENT'
-- 	and upper(nppes_provider_city) = 'NASHVILLE'
-- 	and opioid_drug_flag = 'Y'
-- order by drug_name


--     b. Next, report the number of claims per drug per prescriber. Be sure to include all combinations, whether or not the prescriber had any claims. You should report the npi, the drug name, and the number of claims (total_claim_count).

-- SELECT npi, drug_name, total_claim_count
-- FROM prescriber
-- CROSS JOIN drug
-- LEFT JOIN prescription
-- USING(npi, drug_name)
-- WHERE nppes_provider_city = 'NASHVILLE'
-- AND specialty_description = 'Pain Management'
-- AND opioid_drug_flag = 'Y';

--     c. Finally, if you have not done so already, fill in any missing values for total_claim_count with 0. Hint - Google the COALESCE function.

-- SELECT npi, drug_name, COALESCE(total_claim_count, 0)
-- FROM prescriber
-- CROSS JOIN drug
-- LEFT JOIN prescription
-- USING(npi, drug_name)
-- WHERE nppes_provider_city = 'NASHVILLE'
-- AND specialty_description = 'Pain Management'
-- AND opioid_drug_flag = 'Y';
