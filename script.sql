CREATE SCHEMA IF NOT EXISTS data_science_job_salary;
USE data_science_job_salary;

CREATE TABLE IF NOT EXISTS data_science_job_salary(
	id SMALLINT,
	work_year SMALLINT,
	experience_level CHAR(2),
	employment_type CHAR(2),
	job_title VARCHAR(50),
	salary INT,
	salary_currency CHAR(3),
	salary_in_usd INT,
	employee_residence CHAR(2),
	remote_ratio TINYINT,
	company_location CHAR(2),
	company_size ENUM("S", "M", "L"),
PRIMARY KEY (id)
);

SHOW VARIABLES LIKE "secure_file_priv";
SHOW VARIABLES LIKE "local_infile";

SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE "C:\\Users\\Andrew Hsu\\OneDrive\\Desktop\\Aquarium\\IT\\Data analysis projects\\Data science job salaries\\ds_salaries.csv"
INTO TABLE data_science_job_salary
FIELDS TERMINATED BY ","
LINES TERMINATED BY "\n"
IGNORE 1 ROWS;

SELECT * FROM data_science_job_salary;

ALTER TABLE data_science_job_salary
DROP COLUMN salary,
DROP COLUMN salary_currency;



SELECT
	job_title,
    COUNT(job_title) AS job_count
FROM
	data_science_job_salary
GROUP BY job_title
ORDER BY job_count DESC;

UPDATE data_science_job_salary
SET
	job_title = "Machine Learning Engineer"
WHERE
	(job_title REGEXP "^M.*L.+Engineer$" OR job_title = "Machine Learning Developer") AND  id <> -1;
    
UPDATE data_science_job_salary
SET
	job_title = "Lead Data Analyst"
WHERE
	job_title = "Data Analytics Lead" AND  id <> -1;
    
UPDATE data_science_job_salary
SET
	job_title = "Data Engineer"
WHERE
	job_title = "Big Data Engineer" AND id <> -1;
    
UPDATE data_science_job_salary
SET
	job_title = "Data Architect"
WHERE
	job_title = "Big Data Architect" AND id <> -1;
    
UPDATE data_science_job_salary
SET
	job_title = "Data Scientist"
WHERE
	job_title = "Applied Data Scientist" AND id <> -1;
    
UPDATE data_science_job_salary
SET
	job_title = "Machine Learning Scientist"
WHERE
	job_title = "Applied Machine Learning Scientist" AND id <> -1;
    
UPDATE data_science_job_salary
SET
	job_title = "Lead Data Scientist"
WHERE
	job_title REGEXP ".+Data Scientist" AND id <> -1;
    
UPDATE data_science_job_salary
SET
	job_title = "Lead Data Engineer"
WHERE
	job_title LIKE "Principal%Engineer" AND id <> -1;
    
UPDATE data_science_job_salary
SET
	job_title = "Lead Data Analyst"
WHERE
	job_title LIKE "Principal%Analyst" AND id <> -1;
    
UPDATE data_science_job_salary
SET
	job_title = "Analytics Engineer"
WHERE
	job_title = "Data Analytics Engineer" AND id <> -1;
    
UPDATE data_science_job_salary
SET
	job_title = "Computer Vision Engineer"
WHERE
	job_title = "Computer Vision Software Engineer" AND id <> -1;
    
UPDATE data_science_job_salary
SET
	job_title = "Data Engineer"
WHERE
	(job_title = "Data Science Engineer" OR job_title = "Cloud Data Engineer") AND id <> -1;
    
UPDATE data_science_job_salary
SET
	job_title = "BI Data Analyst"
WHERE
	job_title REGEXP "^[BMP].*Data Analyst$" AND id <> -1;

UPDATE data_science_job_salary
SET
	job_title = "Data Analyst"
WHERE
	job_title REGEXP "^F.*Data Analyst$" AND id <> -1;
    
    
    
SELECT
	company_location,
	COUNT(company_location) AS location_count
FROM
	data_science_job_salary
GROUP BY company_location
ORDER BY location_count DESC;

ALTER TABLE data_science_job_salary
ADD COLUMN continent VARCHAR(20) AFTER company_location;

UPDATE data_science_job_salary
SET
	continent = "NA"
WHERE
	company_location IN ("US", "CA", "MX", "AS", "HN") AND id <> -1;

UPDATE data_science_job_salary
SET
	continent = "EU"
WHERE
	company_location IN (
		"GB", "DE", "FR", "ES", "GR", "PL", "NL", "AT", "PT", "LU", "DK", "IT", "BE", "RU", "SI", "CH",
        "CZ", "HU", "UA", "MT", "HR", "RO", "MD", "EE", "IE"
	) AND id <> -1;
    
UPDATE data_science_job_salary
SET
	continent = "AS"
WHERE
	company_location IN ("IN", "JP", "AE", "PK", "TR", "CN", "IL", "IR", "SG", "VN", "IQ", "MY") AND
    id <> -1;
    
UPDATE data_science_job_salary
SET
	continent = "SA"
WHERE
	company_location IN ("BR", "CL", "CO") AND id <> -1;
    
UPDATE data_science_job_salary
SET
	continent = "OC"
WHERE
	company_location IN ("AU", "NZ") AND id <> -1;
    
UPDATE data_science_job_salary
SET
	continent = "AF"
WHERE
	company_location IN ("NG", "KE", "DZ") AND id <> -1;



#Q1: Does the average salary of different job roles increase as years go by?

SELECT
	work_year,
    COUNT(work_year) AS year_count
FROM
	data_science_job_salary
GROUP BY work_year;

SELECT
	work_year,
    ROUND(AVG(salary_in_usd)) AS salary
FROM
	data_science_job_salary
GROUP BY work_year;

SELECT
	*,
    CASE
		WHEN salary_difference > 0 THEN "T"
        WHEN salary_difference < 0 THEN "F"
        ELSE "-"
	END AS salary_increasing
FROM
	(SELECT
		work_year,
		job_title,
		ROUND(AVG(salary_in_usd)) AS salary,
		LAG(ROUND(AVG(salary_in_usd))) OVER (PARTITION BY job_title ORDER BY work_year) AS previous_salary,
		ROUND(AVG(salary_in_usd))-LAG(ROUND(AVG(salary_in_usd))) OVER (PARTITION BY job_title ORDER BY work_year) AS salary_difference
	FROM
		data_science_job_salary
	GROUP BY work_year, job_title
	ORDER BY job_title, work_year) salary_difference;

SELECT
	salary_increasing,
    COUNT(salary_increasing) AS symbol_count
FROM
	(SELECT
		*,
		CASE
			WHEN salary_difference > 0 THEN "T"
			WHEN salary_difference < 0 THEN "F"
			ELSE "-"
		END AS salary_increasing
	FROM
		(SELECT
			work_year,
			job_title,
			ROUND(AVG(salary_in_usd)) AS salary,
			LAG(ROUND(AVG(salary_in_usd))) OVER (PARTITION BY job_title ORDER BY work_year) AS previous_salary,
			ROUND(AVG(salary_in_usd))-LAG(ROUND(AVG(salary_in_usd))) OVER (PARTITION BY job_title ORDER BY work_year) AS salary_difference
		FROM
			data_science_job_salary
		GROUP BY work_year, job_title
		ORDER BY job_title, work_year) salary_difference) salary_trend
WHERE salary_increasing <> "-"
GROUP BY salary_increasing
ORDER BY salary_increasing DESC;



#Q2: Is it true that the higher experience level employees have, the more they're paid in different job roles?

SELECT
	experience_level,
    COUNT(experience_level)
FROM
	data_science_job_salary
GROUP BY experience_level
ORDER BY
	CASE
		WHEN experience_level = "EN" THEN 1
        WHEN experience_level = "MI" THEN 2
        WHEN experience_level = "SE" THEN 3
		ELSE 4
	END;
    
SELECT
	experience_level,
    ROUND(AVG(salary_in_usd))
FROM
	data_science_job_salary
GROUP BY experience_level
ORDER BY
	CASE
		WHEN experience_level = "EN" THEN 1
        WHEN experience_level = "MI" THEN 2
        WHEN experience_level = "SE" THEN 3
        ELSE 4
	END;

SELECT
	*,
    CASE
		WHEN salary_difference > 0 THEN "T"
        WHEN salary_difference < 0 THEN "F"
        ELSE "-"
	END AS salary_increasing
FROM
	(SELECT
		job_title,
		experience_level,
		ROUND(AVG(salary_in_usd)) AS salary,
		LAG(ROUND(AVG(salary_in_usd))) OVER (PARTITION BY job_title ORDER BY
		CASE
			WHEN experience_level = "EN" THEN 1
			WHEN experience_level = "MI" THEN 2
			WHEN experience_level = "SE" THEN 3
			ELSE 4
		END) AS salary_in_previous_level,
		ROUND(AVG(salary_in_usd))-LAG(ROUND(AVG(salary_in_usd))) OVER (PARTITION BY job_title ORDER BY
		CASE
			WHEN experience_level = "EN" THEN 1
			WHEN experience_level = "MI" THEN 2
			WHEN experience_level = "SE" THEN 3
			ELSE 4
		END) AS salary_difference
	FROM
		data_science_job_salary
	GROUP BY 
		job_title,
		experience_level
	ORDER BY 
		job_title,
		CASE
			WHEN experience_level = "EN" THEN 1
			WHEN experience_level = "MI" THEN 2
			WHEN experience_level = "SE" THEN 3
			ELSE 4
		END) salary_difference;
        
SELECT
	salary_increasing,
    COUNT(salary_increasing)
FROM
	(SELECT
		*,
		CASE
			WHEN salary_difference > 0 THEN "T"
			WHEN salary_difference < 0 THEN "F"
			ELSE "-"
		END AS salary_increasing
	FROM	
		(SELECT
			job_title,
			experience_level,
			ROUND(AVG(salary_in_usd)) AS salary,
			LAG(ROUND(AVG(salary_in_usd))) OVER (PARTITION BY job_title ORDER BY
			CASE
				WHEN experience_level = "EN" THEN 1
				WHEN experience_level = "MI" THEN 2
				WHEN experience_level = "SE" THEN 3
				ELSE 4
			END) AS salary_in_previous_level,
			ROUND(AVG(salary_in_usd))-LAG(ROUND(AVG(salary_in_usd))) OVER (PARTITION BY job_title ORDER BY
			CASE
				WHEN experience_level = "EN" THEN 1
				WHEN experience_level = "MI" THEN 2
				WHEN experience_level = "SE" THEN 3
				ELSE 4
			END) AS salary_difference
		FROM
			data_science_job_salary
		GROUP BY 
			job_title,
			experience_level
		ORDER BY 
			job_title,
			CASE
				WHEN experience_level = "EN" THEN 1
				WHEN experience_level = "MI" THEN 2
				WHEN experience_level = "SE" THEN 3
				ELSE 4
			END) salary_difference) salary_trend
WHERE salary_increasing <> "-"
GROUP BY salary_increasing;
        
        
        
#Q3: Which type of employees is given the highest salary in different job roles?

SELECT
	job_title,
	employment_type,
	ROUND(AVG(salary_in_usd)) AS salary
FROM
	data_science_job_salary
GROUP BY job_title, employment_type
ORDER BY job_title;





#Q4: Does working in companies or from home have a huge influence on employees' salary in different job roles?

SELECT
	remote_ratio,
    ROUND(AVG(salary_in_usd))
FROM
	data_science_job_salary
GROUP BY remote_ratio;

SELECT
	job_title,
	remote_ratio,
    ROUND(AVG(salary_in_usd)) AS salary
FROM
	data_science_job_salary
GROUP BY job_title, remote_ratio
ORDER BY job_title;



#Q5: In which continent an employee works can earn the highest salary?

SELECT
	continent,
    COUNT(continent) AS continent_count
FROM
	data_science_job_salary
GROUP BY continent;

SELECT
	continent,
    ROUND(AVG(salary_in_usd)) AS salary
FROM
	data_science_job_salary
GROUP BY continent;

SELECT
	job_title,
    continent,
    ROUND(AVG(salary_in_usd))
FROM
	data_science_job_salary
GROUP BY job_title, continent
ORDER BY job_title;



#Q6: Do employees in bigger companies earn more money?

SELECT
	company_size,
    ROUND(AVG(salary_in_usd))
FROM
	data_science_job_salary
GROUP BY company_size
ORDER BY
	CASE
		WHEN company_size = "S" THEN 1
        WHEN company_size = "M" THEN 2
        ELSE 3
	END;
    
SELECT
	job_title,
    company_size,
    ROUND(AVG(salary_in_usd))
FROM
	data_science_job_salary
GROUP BY
	job_title,
    company_size
ORDER BY
	job_title,
    CASE
		WHEN company_size = "S" THEN 1
        WHEN company_size = "M" THEN 2
        ELSE 3
	END;