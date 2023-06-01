## Introduction
In this technological era, an increasing popularity of IT-related jobs can be felt. For people who are keen to join the IT family and land a data science job to work with data, this project aims at showing salary pattern and more important information in this field to help people make better decisions when choosing their future career.
## Data
The data used in this project is from a dataset downloaded in Kaggle called data science job salaries. The link to the dataset is as follows:

* [Data Science Job Salaries](https://www.kaggle.com/datasets/ruchi798/data-science-job-salaries?select=ds_salaries.csv)

The column names included in the dataset are:

* **work_year**: The year the salary was paid.
* **experience_level**: The experience level in the job during the year with the following possible values: EN Entry-level / Junior, MI Mid-level / Intermediate, SE Senior-level / Expert, EX Executive-level / Director
* **employment_type**: The type of employement for the role: PT Part-time, FT Full-time, CT Contract, FL Freelance
* **job_title**: The role worked in during the year.
* **salary**:	The total gross salary amount paid.
* **salary_currency**: The currency of the salary paid as an ISO 4217 currency code.
* **salary_in_usd**: The salary in USD (FX rate divided by avg. USD rate for the respective year via fxdata.foorilla.com).
* **employee_residence**: Employee's primary country of residence in during the work year as an ISO 3166 country code.
* **remote_ratio**: The overall amount of work done remotely, possible values are as follows: 0 No remote work (less than 20%), 50 Partially remote, 100 Fully remote (more than 80%)
* **company_location**: The country of the employer's main office or contracting branch as an ISO 3166 country code.
* **company_size**: The average number of people that worked for the company during the year: S less than 50 employees (small), M 50 to 250 employees (medium), L more than 250 employees (large)
