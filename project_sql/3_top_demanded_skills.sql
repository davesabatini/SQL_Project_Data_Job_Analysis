/*
Question: What are the most in-demand skills for data analysts?
- Join job postings to inner join table similar to query 2
- Identify the top 5 in-demand skills for a data analyst.
- Focus on all job postings
- Why? Retrieves the top 5 skills with the highest demand in the job market, 
    providing insights into the most valuable skills for job seekers.
NOTE: this is similar to the query we ran in Problem 7, but we are going
to solve it a different way.
*/

SELECT
    skills,
    COUNT(skills_job_dim.job_id) as demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_work_from_home IS TRUE
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5

/*
NOTE 1: any time we do an aggregation (e.g., COUNT) we have to do a GROUP BY

Note 2: Initial results (without the WHERE clause) show in-demand skills for
all jobs. Next we need to filter that down to Data Analyst jobs by 
inserting a WHERE claus

Note 3: we are looking at all jobs. Next we can insert another WHERE clause
to specify remote jobs
*/