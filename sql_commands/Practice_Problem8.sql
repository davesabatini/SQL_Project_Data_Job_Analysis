/* Practice Problem 8
Find job postings from the first quarter that have a salary greater
than $70k
- Combine job posting tables from the first quarter of 2023 (Jan-Mar)
- Gets job postings with an average yearly salary > $70,000
*/

SELECT
    q1_jobs.job_title_short,
    q1_jobs.job_location,
    q1_jobs.job_via,
    q1_jobs.job_posted_date::date,
    q1_jobs.salary_year_avg
FROM (
    SELECT *
    FROM january_jobs

    UNION ALL

    SELECT *
    FROM february_jobs

    UNION ALL

    SELECT *
    FROM march_jobs
) AS q1_jobs
WHERE
    q1_jobs.salary_year_avg > 70000 AND
    q1_jobs.job_title_short = 'Data Analyst'
ORDER BY
    q1_jobs.salary_year_avg DESC