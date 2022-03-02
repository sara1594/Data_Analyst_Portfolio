
-- import files ("student_mat.csv" and "student_por.csv")
--Clean :Find duplicate students who belong to both math and Portuguese courses

Use Alcohol_comsumption
GO

-- Add a "course" column to both tables ("student_mat" and "student_por")

ALTER TABLE student_mat
ADD course varchar(20)

UPDATE student_mat
SET course = 'math'

SELECT * FROM student_mat

ALTER TABLE student_por
ADD course varchar(20)

UPDATE student_por
SET course = 'Portuguese'

SELECT * FROM student_por


-- Combine two tables

SELECT student_mat.* INTO all_students
FROM student_mat
UNION
SELECT student_por.*
FROM student_por;


--Clean: Remove duplicates in the tables

WITH DupCountTbl AS(
	SELECT school, sex, age, [address], famsize, Pstatus, Medu,
		Fedu, Mjob, Fjob, reason, nursery, internet,
		ROW_NUMBER() OVER (PARTITION BY school, sex, age, [address], famsize, Pstatus, Medu,
		Fedu, Mjob, Fjob, reason, nursery, internet
		ORDER BY 
		school, sex, age, [address], famsize, Pstatus, Medu,
		Fedu, Mjob, Fjob, reason, nursery, internet) AS dup_count
	FROM all_students
	)

--SELECT dup_count,count(*) AS each_num
--FROM DupCountTbl
--WHERE dup_count > 1		-- 382 duplicates
--GROUP BY dup_count 


-- Delete duplicates

DELETE FROM DupCountTbl 
WHERE dup_count > 1


--Clean :Find NULL data

SELECT SUM(CASE WHEN school IS NULL THEN 1 ELSE 0 END ) AS school_Null,
	SUM(CASE WHEN sex IS NULL THEN 1 ELSE 0 END) AS sex_Null,
	SUM(CASE WHEN age IS NULL THEN 1 ELSE 0 END) AS age_Null,
	SUM(CASE WHEN [address] IS NULL THEN 1 ELSE 0 END) AS address_Null,
	SUM(CASE WHEN famsize IS NULL THEN 1 ELSE 0 END) AS famsize_Null,
	SUM(CASE WHEN Pstatus IS NULL THEN 1 ELSE 0 END) AS Pstatus_Null,
	SUM(CASE WHEN Medu IS NULL THEN 1 ELSE 0 END) AS Medu_Null,
	SUM(CASE WHEN Fedu IS NULL THEN 1 ELSE 0 END) AS Fedu_Null,
	SUM(CASE WHEN Mjob IS NULL THEN 1 ELSE 0 END) AS Mjob_Null,
	SUM(CASE WHEN Fjob IS NULL THEN 1 ELSE 0 END) AS Fjob_Null,
	SUM(CASE WHEN reason IS NULL THEN 1 ELSE 0 END) AS reason_Null,
	SUM(CASE WHEN guardian IS NULL THEN 1 ELSE 0 END) AS guardian_Null,
	SUM(CASE WHEN traveltime IS NULL THEN 1 ELSE 0 END) AS traveltime_Null,
	SUM(CASE WHEN studytime IS NULL THEN 1 ELSE 0 END) AS studytime_Null,
	SUM(CASE WHEN failures IS NULL THEN 1 ELSE 0 END) AS failures_Null,
	SUM(CASE WHEN schoolsup IS NULL THEN 1 ELSE 0 END) AS schoolsup_Null,
	SUM(CASE WHEN famsup IS NULL THEN 1 ELSE 0 END) AS famsup_Null,
	SUM(CASE WHEN paid IS NULL THEN 1 ELSE 0 END) AS paid_Null,
	SUM(CASE WHEN activities IS NULL THEN 1 ELSE 0 END) AS activities_Null,
	SUM(CASE WHEN nursery IS NULL THEN 1 ELSE 0 END) AS nursery_Null,
	SUM(CASE WHEN higher IS NULL THEN 1 ELSE 0 END) AS higher_Null,
	SUM(CASE WHEN internet IS NULL THEN 1 ELSE 0 END) AS internet_Null,
	SUM(CASE WHEN romantic IS NULL THEN 1 ELSE 0 END) AS romantic_Null,
	SUM(CASE WHEN famrel IS NULL THEN 1 ELSE 0 END) AS famrel_Null,
	SUM(CASE WHEN freetime IS NULL THEN 1 ELSE 0 END) AS freetime_Null,
	SUM(CASE WHEN goout IS NULL THEN 1 ELSE 0 END) AS goout_Null,
	SUM(CASE WHEN Dalc IS NULL THEN 1 ELSE 0 END) AS Dalc_Null,
	SUM(CASE WHEN Walc IS NULL THEN 1 ELSE 0 END) AS Walc_Null,
	SUM(CASE WHEN health IS NULL THEN 1 ELSE 0 END) AS health_Null,
	SUM(CASE WHEN absences IS NULL THEN 1 ELSE 0 END) AS absences_Null,
	SUM(CASE WHEN G1 IS NULL THEN 1 ELSE 0 END) AS G1_Null,
	SUM(CASE WHEN G2 IS NULL THEN 1 ELSE 0 END) AS G2_Null,
	SUM(CASE WHEN G3 IS NULL THEN 1 ELSE 0 END) AS G3_Null
FROM all_students;

	-- No null value in the tables
	

-- Modify : Assign IDs to each students

ALTER TABLE all_students
ADD ID INT IDENTITY(1,1);

