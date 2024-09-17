-- Get jobs and companies from January
SELECT
    job_title_short,
    company_id,
    job_location
FROM
    january_jobs

UNION

-- Get jobs and companies from February
SELECT
    job_title_short,
    company_id,
    job_location
FROM
    february_jobs

UNION

-- Get jobs and companies from March
SELECT
    job_title_short,
    company_id,
    job_location
FROM
    march_jobs

-- UNION ALL examples

-- Get jobs and companies from January
SELECT
    job_title_short,
    company_id,
    job_location
FROM
    january_jobs

UNION ALL

-- Get jobs and companies from February
SELECT
    job_title_short,
    company_id,
    job_location
FROM
    february_jobs

UNION ALL

-- Get jobs and companies from March
SELECT
    job_title_short,
    company_id,
    job_location
FROM
    march_jobs


/* UNION operators
- UNION
- UNION ALL

Practice problem 1
- Get the corresponding skill and skill type for each job posting in q1
- Includes those without any skills, too
- Why? Look at the skills and the type for each job in the first quarter that has
salary > $70,000
*/

WITH q1_job_skills AS (
    SELECT
        skill_id
    FROM
        skills_job_dim
    WHERE
        job_id IN (
            SELECT job_id
            FROM january_jobs
            WHERE salary_year_avg > 70000
            UNION ALL
            SELECT job_id
            FROM february_jobs
            WHERE salary_year_avg > 70000
            UNION ALL
            SELECT job_id
            FROM march_jobs
            WHERE salary_year_avg > 70000
        )
)

SELECT
    skills_dim.skill_id,
    skills_dim.skills AS skill_name
FROM q1_job_skills
INNER JOIN skills_dim ON q1_job_skills.skill_id = skills_dim.skill_id
