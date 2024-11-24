/*
Recap:
- In query 3 we looked at the most in demand skills (i.e., the most sought-after
    skills based on how frequently they appear in job postings)
- In query 4 we looked at the top paying skills by looking at the avg salary for 
    each of those skills

Query 5 builds off and combines these previous two queries. The easiest way to 
approach this is to build a CTE for Query 3 and a CTE for Query 4 and combine them

Answer: What are the most optimal skills to learn (aka it's in high demand and a high-paying skill)?
- Identify skills in high demand and associated with high average salaries for Data Analyst roles
- Concentrate on remote positions with specified salaries
- Why? Targets skills that offer job security (high demand) and financial benefits (high salaries),
    offering strategic insights for career development in data analysis.

NOTE 1: it's best practice to combine tables based on the key itself, either the 
    Primary or Foreign Key... In this case, we'll combine based on the skill_ID
NOTE 2: No need to limit the query results in the CTE (remove the LIMIT statement)
NOTE 3: No need to order the results in the CTE (remove the ORDER BY statement)
NOTE 4: Group by skill_id instead of by skills
NOTE 5: we use an INNER JOIN because we only care about what exists in both of these
tables. Combine the tables (Temporary Result Sets) using skill_id
NOTE 6: When you define multiple CTEs, you group them together. You only use the WITH
    statement once and separate each CTE by a comma
*/

-- Define CTE for Query 3 and Query 4
WITH skills_demand AS (
    SELECT
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) as demand_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home IS TRUE
    GROUP BY
        skills_dim.skill_id
), average_salary AS (
    SELECT
        skills_job_dim.skill_id,
        ROUND(AVG(salary_year_avg), 0) AS avg_salary
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home IS TRUE
    GROUP BY
        skills_job_dim.skill_id
)

SELECT
    skills_demand.skill_id,
    skills_demand.skills,
    skills_demand.demand_count,
    average_salary.avg_salary
FROM
    skills_demand
INNER JOIN average_salary ON skills_demand.skill_id = average_salary.skill_id
WHERE
    demand_count > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25;


/* Rewrite the same query more concisely

NOTE: you can't put an aggregation method inside of a WHERE clause,
    so we add a HAVING clause
*/
SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home IS TRUE
GROUP BY
    skills_dim.skill_id
HAVING
    COUNT(skills_job_dim.job_id) > 10
    -- demand_count > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25;