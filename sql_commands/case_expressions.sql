SELECT
    job_title_short,
    job_location
FROM
    job_postings_fact

/* 

Label new column as follows:
- 'Anywhere' jobs as 'Remote'
- 'New York, NY' jobs as 'Local'
- Otherwise 'Onsite'

*/

SELECT
    job_title_short,
    job_location,
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM
    job_postings_fact;


SELECT
    COUNT(job_id) AS number_of_jobs,
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    location_category;

/* Practice Problem 1
I want to categorize the salaries from each job posting. To see if it fits
in my desired salary range.
-- Put salary into differet buckets
-- Define what's a high, standard, or low salary with our own conditions
-- Why? It is easy to determine which job postings are worth looking at based on salary.
Bucketing is a common practice in data analysis when viewing categories.
-- I only want to look at data analyst roles
-- Order from highest to lowest
*/

SELECT
    MIN(salary_year_avg),
    AVG(salary_year_avg),
    MAX(salary_year_avg)
FROM
    job_postings_fact;

SELECT
    job_title_short,
    salary_year_avg,
    CASE
        WHEN salary_year_avg >= 150000 THEN 'High'
        WHEN salary_year_avg >= 100000 THEN 'Standard'
        ELSE 'Low'
    END AS salary_category
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
ORDER BY
    salary_year_avg DESC NULLS LAST;
