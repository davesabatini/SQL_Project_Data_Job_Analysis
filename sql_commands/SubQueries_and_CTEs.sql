SELECT *
FROM ( --subquery starts here
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
    ) AS january_jobs;
    -- Subquery ends here


WITH january_jobs AS ( -- CTE definition starts here
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
)
 -- CTE definition ends here

SELECT *
FROM january_jobs;


SELECT
    company_id,
    job_no_degree_mention
FROM
    job_postings_fact
WHERE
    job_no_degree_mention = TRUE; 


SELECT
    company_id,
    name as company_name
FROM 
    company_dim
WHERE company_id IN(
    SELECT
        company_id
    FROM
        job_postings_fact
    WHERE
        job_no_degree_mention = TRUE
    ORDER BY
        company_id
)


/*
Find the companies that have the most job openings.
- Get the total number of job postings per company id (job_postings_fact)
- Return the total number of jobs with the company name (company_dim)
*/


 /*   NOTE: anytime we use an aggregation function, we need to specify the GROUP BY function
 to indicate how we are grouping it.  */

 WITH company_job_count AS (
    SELECT
        company_id,
        COUNT(company_id) AS total_jobs
    FROM
        job_postings_fact
    GROUP BY
        company_id
 )

-- SELECT *
-- FROM company_job_count;

 SELECT
    company_dim.name AS company_name,
    company_job_count.total_jobs
 FROM
    company_dim
 LEFT JOIN company_job_count ON company_job_count.company_id = company_dim.company_id
 ORDER BY
    total_jobs DESC

/* Practice Problem 1
Identify the top 5 skills that are most frequently mentioned in job postings.
Use a subquery to find the skill IDs with the highest counts in the skills_job_dim
table and then join this result with the skills_dim table to get the skill names.
*/
WITH skill_count AS (
    SELECT 
        skill_id,
        COUNT(job_id) AS num_jobs_per_skill
    FROM
        skills_job_dim
    GROUP BY
        skill_id
    ORDER BY
        num_jobs_per_skill DESC
    LIMIT 5
)

SELECT
    skills_dim.skill_id,
    skills_dim.skills
FROM
    skills_dim
RIGHT JOIN skill_count ON skill_count.skill_id = skills_dim.skill_id

/* Practice Problem 2
Determine the size category ("Small", "Medium", or "Large") for each company by first
identifying the number of job postings they have. Use a subquery to calculate the total
job postings per company. A company is considered "Small" if it has less than 10 job 
postings, "Medium" if the number of job postings is between 10 and 50, and "Large"
if it has more than 50 job postings. Implement a subquery to aggregate job counts per
company before classifying them based on size.
*/

WITH job_counts AS (
    SELECT
        company_id,
        count(job_id) num_jobs_per_company
    FROM
        job_postings_fact
    GROUP BY
        company_id
)

SELECT
    company_id,
    CASE
        WHEN num_jobs_per_company < 10 THEN 'Small'
        WHEN num_jobs_per_company < 50 THEN 'Medium'
        ELSE 'Large'
    END AS size_category
FROM
    job_counts