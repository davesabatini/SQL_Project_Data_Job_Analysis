SELECT job_posted_date
FROM job_postings_fact
LIMIT 10

SELECT
    '2023-02-19'::DATE,
    '123'::INTEGER,
    'true'::BOOLEAN,
    '3.14'::REAL;

SELECT
    job_title_short AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS DATE,
    EXTRACT(MONTH FROM job_posted_date) AS date_month,
    EXTRACT(YEAR FROM job_posted_date) AS date_year
FROM
    job_postings_fact
LIMIT 5;

SELECT
    COUNT(job_id) AS job_posted_count,
    EXTRACT(MONTH FROM job_posted_date) AS month
FROM
    job_postings_fact
WHERE 
    job_title_short = 'Data Analyst'
GROUP BY
    month
ORDER BY
    job_posted_count DESC;



-- Practice problem 1
-- Write a query to find the average salary both yearly (salary_year_avg) and hourly
-- (salary_hour_avg) for job postings that were posted after June 1, 2023. Group
-- results by job schedule type
SELECT
    job_schedule_typeCOUNT(job_id),
    AVG(salary_year_avg),
    AVG(salary_hour_avg)
FROM
    job_postings_fact
WHERE 
    job_posted_date::DATE > '2023-06-01'::DATE
GROUP BY
    job_schedule_type

-- Practice problem 2
-- Write a query to count the number of job postings for each month in 2023,
-- adjusting the job_posted_date to be in 'America/New_York' time zone before
-- extracting (hint) the month. Assume the job_posted_date is stored in UTC.
-- Group by and order by the month.
SELECT
    count(job_id),
    EXTRACT(MONTH FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York') AS month
FROM
    job_postings_fact
WHERE
    EXTRACT(YEAR FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York') = '2023'
GROUP BY
    month
ORDER BY
    month;



-- Practice problem 3
-- Write a query to find companies (including company name) that have posted 
-- jobs offering health insurance, where these postings were made in the second
-- quarter of 2023. Use date extraction to filter by quarter
SELECT
    DISTINCT cd.name,
    jpf.job_title_short,
    jpf.job_posted_date::DATE AS job_date,
    EXTRACT(MONTH FROM jpf.job_posted_date) as date_month,
    EXTRACT(YEAR FROM jpf.job_posted_date) as date_year
FROM
    job_postings_fact jpf, company_dim cd
WHERE
    job_health_insurance = TRUE and
    jpf.company_id = cd.company_id and
    EXTRACT(YEAR FROM jpf.job_posted_date) = '2023' and
    EXTRACT(MONTH FROM jpf.job_posted_date) in (4,5,6)
ORDER BY
    cd.name;


-- Practice problem 6
CREATE TABLE january_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1;

CREATE TABLE february_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 2;

CREATE TABLE march_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 3;

SELECT job_posted_date
FROM march_jobs;