# Load data into the table and remove unnecessary columns. 

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



# Reduce the number of job titles by putting similar titles into one category.

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
    
    
    
# Add the Continent column to the table.

SELECT
	company_location,
	COUNT(company_location) AS location_count
FROM
	data_science_job_salary
GROUP BY company_location
ORDER BY location_count DESC;

ALTER TABLE data_science_job_salary
ADD COLUMN continent CHAR(2) AFTER company_location;

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



#Q1: Did the average salary of data science jobs increase as years went by?

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



#Q2: Is it true that the higher experience level employees had, the more they were paid in data science jobs?

SELECT
	experience_level,
    COUNT(experience_level) AS experience_level_count
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
    ROUND(AVG(salary_in_usd)) AS salary
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
        
        
        
#Q3: Which type of employees was given the highest salary in different job roles?

SELECT
	employment_type,
    COUNT(employment_type) AS employment_type_count
FROM
	data_science_job_salary
GROUP BY employment_type
ORDER BY
	CASE
		WHEN employment_type = "PT" THEN 1
        WHEN employment_type = "FT" THEN 2
        WHEN employment_type = "CT" THEN 3
		ELSE 4
	END;
    
SELECT
	employment_type,
    ROUND(AVG(salary_in_usd)) AS salary
FROM
	data_science_job_salary
GROUP BY employment_type
ORDER BY
	CASE
		WHEN employment_type = "PT" THEN 1
        WHEN employment_type = "FT" THEN 2
        WHEN employment_type = "CT" THEN 3
        ELSE 4
	END;

SELECT
	job_title,
	employment_type,
	ROUND(AVG(salary_in_usd)) AS salary
FROM
	data_science_job_salary
GROUP BY
	job_title,
    employment_type
ORDER BY
	job_title,
    CASE
		WHEN employment_type = "PT" THEN 1
        WHEN employment_type = "FT" THEN 2
        WHEN employment_type = "CT" THEN 3
        ELSE 4
	END;

SELECT
	*
FROM
	(SELECT
		job_title,
		employment_type,
		ROUND(AVG(salary_in_usd)) AS salary
	FROM
		data_science_job_salary
	GROUP BY
		job_title,
		employment_type
	ORDER BY
		job_title,
		CASE
			WHEN employment_type = "PT" THEN 1
			WHEN employment_type = "FT" THEN 2
			WHEN employment_type = "CT" THEN 3
			ELSE 4
		END) salary
WHERE (job_title, salary) IN
	(SELECT
		job_title,
		MAX(salary) AS salary
	FROM
		(SELECT
			job_title,
			employment_type,
			ROUND(AVG(salary_in_usd)) AS salary
		FROM
			data_science_job_salary
		GROUP BY
			job_title,
			employment_type
		ORDER BY
			job_title,
			CASE
				WHEN employment_type = "PT" THEN 1
				WHEN employment_type = "FT" THEN 2
				WHEN employment_type = "CT" THEN 3
				ELSE 4
			END) salary
	GROUP BY job_title);



#Q4: Did working in companies or from home have a huge influence on employees' salary in different job roles?

SELECT
	remote_ratio,
    COUNT(remote_ratio) AS ratio_count
FROM
	data_science_job_salary
GROUP BY remote_ratio;

SELECT
	remote_ratio,
	work_year,
    COUNT(remote_ratio) AS ratio_count
FROM
	data_science_job_salary
GROUP BY remote_ratio, work_year
ORDER BY remote_ratio;

SELECT
	remote_ratio,
    ROUND(AVG(salary_in_usd)) AS salary
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

SELECT
	*
FROM
	(SELECT
		job_title,
		remote_ratio,
		ROUND(AVG(salary_in_usd)) AS salary
	FROM
		data_science_job_salary
	GROUP BY job_title, remote_ratio
	ORDER BY job_title) salary
WHERE (job_title, salary) IN
	(SELECT
		job_title,
        MAX(salary)
	FROM
		(SELECT
			job_title,
			remote_ratio,
			ROUND(AVG(salary_in_usd)) AS salary
		FROM
			data_science_job_salary
		GROUP BY job_title, remote_ratio
		ORDER BY job_title) salary
	GROUP BY job_title
    ORDER BY job_title);
    
SELECT
    remote_ratio,
    COUNT(remote_ratio) AS ratio_count
FROM
	(SELECT
		*
	FROM
		(SELECT
			job_title,
			remote_ratio,
			ROUND(AVG(salary_in_usd)) AS salary
		FROM
			data_science_job_salary
		GROUP BY job_title, remote_ratio
		ORDER BY job_title) salary
	WHERE (job_title, salary) IN
		(SELECT
			job_title,
			MAX(salary)
		FROM
			(SELECT
				job_title,
				remote_ratio,
				ROUND(AVG(salary_in_usd)) AS salary
			FROM
				data_science_job_salary
			GROUP BY job_title, remote_ratio
			ORDER BY job_title) salary
		GROUP BY job_title
		ORDER BY job_title)) highest_salary
GROUP BY remote_ratio
ORDER BY remote_ratio;



#Q5: Which continent gave people better salary in different job roles?

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
    ROUND(AVG(salary_in_usd)) AS salary
FROM
	data_science_job_salary
GROUP BY job_title, continent
ORDER BY job_title;

SELECT
	*
FROM
	(SELECT
		job_title,
		continent,
		ROUND(AVG(salary_in_usd)) AS salary
	FROM
		data_science_job_salary
	GROUP BY job_title, continent
	ORDER BY job_title) salary
WHERE (job_title, salary) IN
	(SELECT
		job_title,
        MAX(salary)
	FROM
		(SELECT
			job_title,
			continent,
			ROUND(AVG(salary_in_usd)) AS salary
		FROM
			data_science_job_salary
		GROUP BY job_title, continent
		ORDER BY job_title) salary
	GROUP BY job_title
    ORDER BY job_title);



#Q6: Compared with local residents, did people from other countries earn less money in data science jobs?

SELECT
	COUNT(*) AS local_employee_count
FROM
	data_science_job_salary
WHERE employee_residence = company_location;

SELECT
	COUNT(*) AS foreign_employee_count
FROM
	data_science_job_salary
WHERE employee_residence <> company_location;

SELECT
	ROUND(AVG(salary_in_usd)) local_employee_salary
FROM
	data_science_job_salary
WHERE employee_residence = company_location;
	
SELECT
	ROUND(AVG(salary_in_usd)) AS foreign_employee_salary
FROM
	data_science_job_salary
WHERE employee_residence <> company_location;



#Q7: Did employees in bigger companies earn more money in data science jobs?

SELECT
	company_size,
    COUNT(company_size) AS company_size_count
FROM
	data_science_job_salary
GROUP BY company_size
ORDER BY company_size;

SELECT
	company_size,
    ROUND(AVG(salary_in_usd)) AS salary
FROM
	data_science_job_salary
GROUP BY company_size
ORDER BY company_size;
