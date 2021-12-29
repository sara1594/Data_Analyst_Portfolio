-- Clean and organize the table 'jobs_jp' to match with the data structure of 'jobs_us'
-- Using ROUND, SELECT INTO, COALESCE, WHERE clause and JOIN

SELECT * FROM pay_jp

--Create a new column of median annual income in US dollar using weighted average

SELECT job_titles, ROUND(((([avg_salary(y/1000/month)] *10*12 +  [avg_bonus_and_incentives(yen/1000)]*10) * [number_of_workers(person/10)]*10)+ (([avg_salary(y/1000/month)1] *10*12 + [avg_bonus_and_incentives(yen/1000)1]*10)*[number_of_workers(person/10)1]*10) + (([avg_salary(y/1000/month)2] *10*12 +  [avg_bonus_and_incentives(yen/1000)2]*10)*[number_of_workers(person/10)2]*10) + (([avg_salary(y/1000/month)3] *10*12 +  [avg_bonus_and_incentives(yen/1000)3]*10)*[number_of_workers(person/10)3]*10))/(([number_of_workers(person/10)]+[number_of_workers(person/10)1]+[number_of_workers(person/10)2]+[number_of_workers(person/10)3])*10),0) AS pay
FROM pay_jp
WHERE (job_titles is not NULL)

--Create a new table 'pay_jp_combined' with median pay for each job titles

SELECT job_titles, ROUND(((([avg_salary(y/1000/month)] *10*12 +  [avg_bonus_and_incentives(yen/1000)]*10) * [number_of_workers(person/10)]*10)+ (([avg_salary(y/1000/month)1] *10*12 + [avg_bonus_and_incentives(yen/1000)1]*10)*[number_of_workers(person/10)1]*10) + (([avg_salary(y/1000/month)2] *10*12 +  [avg_bonus_and_incentives(yen/1000)2]*10)*[number_of_workers(person/10)2]*10) + (([avg_salary(y/1000/month)3] *10*12 +  [avg_bonus_and_incentives(yen/1000)3]*10)*[number_of_workers(person/10)3]*10))/(([number_of_workers(person/10)]+[number_of_workers(person/10)1]+[number_of_workers(person/10)2]+[number_of_workers(person/10)3])*10),0) AS pay
INTO pay_jp_combined 
FROM pay_jp
WHERE (job_titles is not NULL)

SELECT *
FROM pay_jp_combined

-- Check NULLs in pay column 

SELECT *
FROM pay_jp_combined
WHERE pay is NULL

-- See which data is missing

SELECT * 
FROM pay_jp
WHERE job_titles = 'Flight Attendants' or job_titles = 'Film and Video Editors and Camera Operators'

-- Use COALESCE to recalculate the pay rows including that have NULL

SELECT  job_titles, ROUND(((([avg_salary(y/1000/month)] *10*12 +  [avg_bonus_and_incentives(yen/1000)]*10) * [number_of_workers(person/10)]*10)+ (([avg_salary(y/1000/month)1] *10*12 + [avg_bonus_and_incentives(yen/1000)1]*10)*[number_of_workers(person/10)1]*10) + (([avg_salary(y/1000/month)2] *10*12 +  [avg_bonus_and_incentives(yen/1000)2]*10)*[number_of_workers(person/10)2]*10) + ((COALESCE([avg_salary(y/1000/month)3],0) *10*12 +  COALESCE([avg_bonus_and_incentives(yen/1000)3],0)*10)* COALESCE([number_of_workers(person/10)3],0)*10)) / (([number_of_workers(person/10)]+[number_of_workers(person/10)1]+[number_of_workers(person/10)2] + COALESCE([number_of_workers(person/10)3],0))*10),0) AS pay
FROM pay_jp
WHERE (job_titles is not NULL)

SELECT job_titles, ROUND(((([avg_salary(y/1000/month)] *10*12 +  [avg_bonus_and_incentives(yen/1000)]*10) * [number_of_workers(person/10)]*10)+ (([avg_salary(y/1000/month)1] *10*12 + [avg_bonus_and_incentives(yen/1000)1]*10)*[number_of_workers(person/10)1]*10) + (([avg_salary(y/1000/month)2] *10*12 +  [avg_bonus_and_incentives(yen/1000)2]*10)*[number_of_workers(person/10)2]*10) + ((COALESCE([avg_salary(y/1000/month)3],0) *10*12 +  COALESCE([avg_bonus_and_incentives(yen/1000)3],0)*10)* COALESCE([number_of_workers(person/10)3],0)*10)) / (([number_of_workers(person/10)]+[number_of_workers(person/10)1]+[number_of_workers(person/10)2] + COALESCE([number_of_workers(person/10)3],0))*10),0) AS pay
INTO jobs_jp_cleaned
FROM pay_jp
WHERE (job_titles is not NULL)

SELECT * FROM jobs_jp_cleaned

-- Combine two tables

SELECT * FROM pay_us

SELECT *
FROM jobs_jp_cleaned
JOIN pay_us
ON pay_us.job_titles = jobs_jp_cleaned.job_titles

--Check if the "Nurse" row is populated correctly

SELECT *
FROM jobs_jp_cleaned
INNER JOIN pay_us
ON pay_us.job_titles = jobs_jp_cleaned.job_titles
WHERE pay_us.median_pay is not NULL and jobs_jp_cleaned.pay is not NULL and pay_us.job_titles like 'Nurse %'

-- Display data for exporting

SELECT *
FROM jobs_jp_cleaned
INNER JOIN pay_us
ON pay_us.job_titles = jobs_jp_cleaned.job_titles
WHERE pay_us.median_pay is not NULL and jobs_jp_cleaned.pay is not NULL
ORDER BY pay_us.jobtitle_no
