# Introduction
Dive into the data job market! Focusing on data analyst roles, this project explores top-paying jobs, in-demand skills, and where high demand meets high salary in data analytics.

SQL requires located here: [project_sql folder](/project_sql/)

# Background
Driven by a quest to navigate the data analyst job market more effectively, this project helped pinpoint top-paying and in-demand skills, streamlining the search find optimal jobs.

Data source: [SQL Course](https://lukebarousse.com/sql). These data compile detailed information on job titles, salaries, locations, and essential skills.

### The questions I wanted to answer through the SQL queries were:

1. What are the top-paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries
5. What are the most optimal skills to learn (in-demand + high-paying)?

# Tools I Used
For this project, I used the following tools:

- **SQL:** The backbone of the analysis, allowing me to query the database and find the key insights.
- **PostgreSQL:** The chosen database management system, ideal for handling the job posting data.
- **Visual Studio Code:** Used for database management and executing SQL queries.
- **Git & GitHub:** Version control system and used to share the project, including SQL scripts and analysis. 

# The Analysis
Each query for this project was aimed at investigating specific aspects of the data analyst job market.

### 1. Top Paying Data Analyst Jobs
To identify the highest-paying roles, I filtered data analyst positions by average yearly salary and location, focusing on remote jobs. This query highlights the high paying opportunities in the field.

```sql
SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC 
LIMIT 10
```

Here's the breakdown of the top Data Analyst jobs in 2023:
- **Wide Salary Range:** Top 10 highest paying data analyst roles span from $184,000 to $650,000, indicating significant salary potential in the field.
- **Diverse Employers:** Companies like SmartAsset, Meta, and AT&T are among those offering high salaries, showing a broad interest across different industries.
- **Job Title Variety:** There's a high diversity in job titles, from Data Analyst to Director of Analytics, reflecting varied roles, responsibilities, and specializations within data analytics.

![Top Paying Roles]()
**TO DO**
*Bar graph visualizing the salary for the top 10 salaries for data analysts: ChatGPT generated the Python code used to generate the plot based on my SQL query results.*

### 2. Top Paying Skills
To identify the skills associated with the highest-paying data analyst jobs, I joined the job postings table with the skills data table to gain insight into what skills employers value for high-paying roles. Specifically, I did the following:
- started by using the top 10 highest-paying Data Analyst jobs from first query.
- then identified the specific skills required for these roles.

```sql
WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        salary_year_avg,
        name AS company_name
    FROM
        job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst' AND
        job_location = 'Anywhere' AND
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC 
    LIMIT 10
)

SELECT
    top_paying_jobs.*,
    skills_dim.skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC
```

Here's the breakdown of the most demanded skills for top 10 highest paying data analyst jobs in 2023:
- **SQL:** is leading with a bold count of 8.
- **Python:** follows closely with a bold count of 7.
- **Tableau:** is also highly sought after, with a bold count of 6.
- **Other skills:** R, Snowflake, Pandas, and Excel show varying degrees of demand.

![Top Paying Skills]()
**TO DO**
*Bar graph visualizing the count of skills for the top 10 paying jobs for data analysts; ChatGPT generated the Python code used to generate the plot based on my SQL query results.*

### 3. In Demand Skills
This query helped determine the most in-demand skills by identifying the skills most frequently requested in job postings

```sql
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
```

Here's the breakdown of the most demanded skills for data analyst jobs in 2023:
| Skills    |   Demand Count |
|-----------|----------------|
| SQL       | 7291           |
| Excel     | 4611           |
| Python    | 4330           |
| Tableau   | 3745           |
| Power BI  | 2609           |

*Table of the demand for the top 5 skills in data analyst job postings.*

### 4. Skills Associated with Higher Salaries
This query explores the average salaries associated with different skills to reveal which skills are the highest paying.

```sql
SELECT
    skills,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home IS TRUE
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 25
```

**RESULTS:**

| Skills        |   Average Salary |
|---------------|------------------|
| pyspark       | 208,172          |
| bitbucket     | 189,155          |
| couchbase     | 160,515          |
| watson        | 160,515          |
| datarobot     | 155,486          |
| gitlab        | 154,500          |
| swift         | 153,750          |
| jupyter       | 152,777          |
| pandas        | 151,821          |
| elasticsearch | 145,000          |

*Table of the average salary for the top 10 paying skills for data analyst jobs.*

### 5. Most Optimal Skills
Combining insights from demand and salary data, this query aimed to identify skills that are both high demand and have high salaries, offering focus areas for skill development.

```sql
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
```

**Results:**

| Skills     | Demand Count  | Average Salary |
|------------|---------------|----------------|
| go         | 27            | 115,320        |
|confluence  | 11            | 114,210        |
|hadoop      | 22            | 113,193        |
|snowflake   | 37            | 112,948        |
|azure       | 34            | 111,225        |
|bigquery    | 13            | 109,654        |
|aws         | 32            | 108,317        |
|java        | 17            | 106,906        |
|ssis        | 12            | 106,683        |
|jira        | 20            | 104,918        |

*Table of the most optimal skills for data analyst jobs, sorted by salary.*

# What I learned
Throughout this project, I learned the following skills:
- **Query Building:** learned how to write basic and advanced SQL queries
- **Data Aggregation:** learned to summarize data using GROUP BY and aggregate functions like COUNT() and AVG()
- **Analysis:** improved analytic and problem-solving skills by learning to turn real-world questions into actionable and insightful SQL queries.

# Conclusions

### Insights
1. **Top-paying data analyst jobs**:: The highest-paying jobs for data analysts that allow remote work offer a wide range of salaries, the highest at $650,000!
2. **Skills for Top-Paying jobs**: High-paying data analyst jobs require advanced proficiency in SQL, suggesting it's a critical skill for earning a top salary.
3. **Most In-demand skills**: SQL is also the most demanded skill in the data analyst job market, thus making it essential for job seekers.
4. **Skills with higher salaries**: specialized skills, such as SVN and Solidity, are associated with the highest average salaries, indicating a premium on niche expertise.
5. **Optimal skills for job market value**: SQl leads in demand and offers for a high average salary, positioning it as one of the most optimal skills for data analysts to learn to maximize their market value.

### Closing Thoughts
This project enhanced my SQL skills and provided valuable insights into the data analyst job market. The findings from the analysis serve as a guide to prioritizing skill development and job search efforts. Aspiring data analysts can better position themselves in a competitive job market by focusing on high-demand, high-salary skills. This exploration highlights the importance of continuous learning and adaptation to emerging trends in the field of data analytics.