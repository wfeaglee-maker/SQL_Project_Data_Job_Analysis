--- create table ---
create TABLE job_applied(
    job_id INT NOT NULL,
    application_sent_date DATE NOT NULL,
    custom_resume boolean,
    resume_file_name VARCHAR(255),
    cover_letter_sent boolean,
    cover_letter_file_name VARCHAR(255),
    status VARCHAR(50)
);
select * from job_applied;


--- insert table ---
insert into job_applied
(job_id, 
application_sent_date,
custom_resume,
resume_file_name, 
cover_letter_sent, 
cover_letter_file_name, 
status)
VALUEs(1,
'2024-02-01', 
true, 
'resume_01.pdf', 
true, 
'cover_letter_01.pdf', 
'submitted'); 

---add column ---
alter table job_applied
add column contact_name text;

select * FROM job_applied

--- Update table content ---
Update job_applied
SET contact_name = 'Erlich Bachman'
WHERE job_id = '1'

---rename column ---
alter table job_applied
rename column contact to contact_name;
select * FROM job_applied

--- change column ---
alter table job_applied
alter column contact_name type text;
select * FROM job_applied

--- drop column ---
alter table job_applied
drop column contact_name;
select * FROM job_applied

--- drop table ---
drop table job_applied;

---date functions ---
select 
job_posted_date
from job_postings_fact  
 limit 10
       
--
select '2023-02-19'::date + 1
select '2023-02-19'::date; 

select '2023-02-19'::date + INTERVAL '1 MONTH'
select '2023-02-19'::date + INTERVAL '1 WEEK'

SELECT
'2023-02-19'::date,
'123'::integer,
'true'::boolean,
'3.14'::real; 
--
select 
job_title_short as title, 
job_location as location, 
job_posted_date as date 
FROM job_postings_fact
LIMIT 10;

--adjust time stamp to date only--
select 
job_title_short as title, 
job_location as location, 
job_posted_date:: DATE as date 
FROM job_postings_fact;

--
select 
job_title_short as title, 
job_location as location, 
job_posted_date:: DATE as date
FROM job_postings_fact
LIMIT 10;

--timezone conversion--
select 
job_title_short as title, 
job_location as location, 
job_posted_date at TIME ZONE 'UTC' at TIME ZONE 'EST' as date
FROM job_postings_fact
LIMIT 10;

--extract year, month, day--
select 
job_title_short as title, 
job_location as location, 
job_posted_date at TIME ZONE 'UTC' at TIME ZONE 'EST' as date,
EXTRACT(Month FROM job_posted_date) AS date_month,
EXTRACT(Day FROM job_posted_date) AS date_day
FROM job_postings_fact
LIMIT 10;

--extract month, group by month--
select job_id,
EXTRACT(Month FROM job_posted_date) AS date_month
FROM job_postings_fact
GROUP BY job_id, date_month
ORDER BY date_month ASC

--
select count(job_id) as job_posted_count,
EXTRACT(Month FROM job_posted_date) AS date_month
FROM job_postings_fact
where job_title_short = 'Data Analyst'
GROUP BY date_month 
ORDER BY job_posted_count desc

--
select *
from job_postings_fact
where EXTRACT(Month FROM job_posted_date) = 1
limit 10;


--create sub table ---

-- January
CREATE TABLE january_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1;

-- February
CREATE TABLE february_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 2;

-- March
CREATE TABLE march_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 3;

--test march_jobs table--
select job_posted_date
from march_jobs

--case expression --

select 
    job_title_short,
    job_location,
    CASE
        WHEN job_location = 'New York, NY' THEN 'Local'
        WHEN job_location = 'Anywhere' THEN 'Remote'
        ELSE 'On site'
    END AS location_category
FROM job_postings_fact
ORDER BY location_category

select 
    count(job_id) as number_of_jobs,
    job_location,
    CASE
        WHEN job_location = 'New York, NY' THEN 'Local'
        WHEN job_location = 'Anywhere' THEN 'Remote'
        ELSE 'On site'
    END AS location_category
FROM job_postings_fact
group by location_category, job_location
order by number_of_jobs desc;

select 
    count(job_id) as number_of_jobs,
     CASE
        WHEN job_location = 'New York, NY' THEN 'Local'
        WHEN job_location = 'Anywhere' THEN 'Remote'
        ELSE 'On site'
    END AS location_category
FROM job_postings_fact

group by location_category
order by number_of_jobs desc;

--subquery and CTE --

select *
from (
      SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
) AS january_jobs;

with january_jobs AS (
      SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
)
select *
from january_jobs;

select 
company_id,
name as company_name
from company_dim
where company_id IN (
        select company_id
        from job_postings_fact
        where job_no_degree_mention = true
    );

select 
company_id,
job_no_degree_mention
from job_postings_fact
where job_no_degree_mention = true
order by company_id

select count(job_id) as job_count,
company_id
from job_postings_fact
where company_id IN (
        select company_id
        from company_dim
      
    )
group by company_id;

 SELECT company_dim.company_id,
       company_dim.name AS company_name,
       COUNT(job_id) AS job_count
FROM company_dim
inner JOIN job_postings_fact
  ON company_dim.company_id = job_postings_fact.company_id
GROUP BY company_dim.company_id, company_dim.name
ORDER BY company_dim.company_id;   

SELECT c.company_id,
       c.name AS company_name,
       COUNT(j.job_id) AS job_count
FROM company_dim AS c
LEFT JOIN job_postings_fact AS j
  ON j.company_id = c.company_id
GROUP BY c.company_id, c.name
ORDER BY job_count DESC;

select *
from company_dim
limit 100

with company_job_counts AS (
    SELECT company_id, 
    count(*) as total_jobs
    from job_postings_fact
    group by company_id)
select 
    d.name as company_name,
    f.total_jobs
from company_dim as d
left join company_job_counts f
  ON d.company_id = f.company_id
order by f.total_jobs DESC;


with skill_counts AS (
    SELECT skill_id, 
    count(*) as total_skills
    from job_postings_fact
    group by company_id)

select 
    job_postings.job_id,
    skills_to_job.skill_id,
    job_postings.job_work_from_home
    from skills_job_dim as skills_to_job
    inner join job_postings_fact as job_postings
        ON skills_to_job.job_id = job_postings.job_id
        where job_postings.job_work_from_home = true
group by skills_to_job.skill_id, job_postings.job_id;

with remote_job_skills AS (
select 
        skills_to_job.skill_id,
    count (*) as total_remote_jobs
    from skills_job_dim as skills_to_job
    inner join job_postings_fact as job_postings
        ON skills_to_job.job_id = job_postings.job_id
        where job_postings.job_work_from_home = true and 
        job_postings.job_title_short ='Data Analyst'
group by skills_to_job.skill_id)
select 
    skills.skill_id,
    skills.skills,
    remote_job_skills.total_remote_jobs as remote_data_analyst_jobs
from skills_dim as skills
INNER JOIN remote_job_skills
  ON skills.skill_id = remote_job_skills.skill_id
order by remote_job_skills.total_remote_jobs DESC
LIMIT 5;

--union operators--

select * 
from (
    select 
    job_title_short,
    company_id,
    job_location,
    salary_year_avg
    from 
    january_jobs
    UNION ALL
    select 
    job_title_short,
    company_id,
    job_location,
    salary_year_avg
    from
    february_jobs
    UNION ALL
    select 
    job_title_short,
    company_id,
    job_location,
    salary_year_avg
    from
    march_jobs
) as first_quarter_jobs
where salary_year_avg IS NOT NULL and salary_year_avg > 70000

--compare to the above syntax, notice the repetitive code--
select 
job_title_short,
company_id,
job_location,
salary_year_avg
from 
january_jobs
where salary_year_avg IS NOT NULL and salary_year_avg > 70000
UNION all
select 
job_title_short,
company_id,
job_location,
salary_year_avg
from
february_jobs
where salary_year_avg IS NOT NULL and salary_year_avg > 70000
UNION all
select 
job_title_short,
company_id,
job_location,
salary_year_avg
from
march_jobs
where salary_year_avg IS NOT NULL and salary_year_avg > 70000
ORDER BY salary_year_avg DESC;


select
    
    job_title_short,
    job_location,
    salary_year_avg,
    job_via,
    job_posted_date:: DATE
from (
    select *
    from january_jobs
    UNION ALL
    select *
    from february_jobs
    UNION ALL
    select *
    from march_jobs
) as first_quarter_jobs
where salary_year_avg > 70000 and 
job_title_short = 'Data Analyst'
ORDER BY salary_year_avg ASC;

--find top 5 skills for remote data analyst jobs--

select
    
    job_title_short,
    job_location,
    salary_year_avg,
    job_via,
    job_posted_date:: DATE
from (
    select *
    from january_jobs
    UNION ALL
    select *
    from february_jobs
    UNION ALL
    select *
    from march_jobs
) as first_quarter_jobs
where salary_year_avg > 70000 and 
job_title_short = 'Data Scientist'
ORDER BY salary_year_avg ASC;

--find top paying jobs--
select
    j.job_id,
    j.job_title,
    company_dim.name as company_name,
    j.job_location,
    j.job_schedule_type,
    j.salary_year_avg,
    j.job_posted_date:: DATE
    from job_postings_fact as j
left join company_dim
on j.company_id = company_dim.company_id    
where salary_year_avg IS NOT NULL AND
job_title_short = 'Data Analyst' AND
job_location = 'Anywhere'
ORDER BY salary_year_avg DESC
LIMIT 10; 


with top_paying_data_analyst_jobs AS (
select
    j.job_id,
    j.job_title,
    company_dim.name as company_name,
    j.job_schedule_type,
    j.salary_year_avg
from job_postings_fact as j
left join company_dim
on j.company_id = company_dim.company_id    
where salary_year_avg IS NOT NULL AND
job_title_short = 'Data Analyst' AND
job_location = 'Anywhere'
ORDER BY salary_year_avg DESC
LIMIT 10) 
select top_paying_data_analyst_jobs.*,
skills_dim.skills
from top_paying_data_analyst_jobs
INNER join skills_job_dim
  on top_paying_data_analyst_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim
  ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY salary_year_avg DESC;

-- [
--   {
--     "job_id": 552322,
--     "job_title": "Associate Director- Data Insights",
--     "company_name": "AT&T",
--     "job_schedule_type": "Full-time",
--     "salary_year_avg": "255829.5",
--     "skills": "sql"
--   },
  {
    "job_id": 552322,
    "job_title": "Associate Director- Data Insights",
    "company_name": "AT&T",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "255829.5",
    "skills": "python"
  },
  {
    "job_id": 552322,
    "job_title": "Associate Director- Data Insights",
    "company_name": "AT&T",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "255829.5",
    "skills": "r"
  },
  {
    "job_id": 552322,
    "job_title": "Associate Director- Data Insights",
    "company_name": "AT&T",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "255829.5",
    "skills": "azure"
  },
  {
    "job_id": 552322,
    "job_title": "Associate Director- Data Insights",
    "company_name": "AT&T",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "255829.5",
    "skills": "databricks"
  },
  {
    "job_id": 552322,
    "job_title": "Associate Director- Data Insights",
    "company_name": "AT&T",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "255829.5",
    "skills": "aws"
  },
  {
    "job_id": 552322,
    "job_title": "Associate Director- Data Insights",
    "company_name": "AT&T",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "255829.5",
    "skills": "pandas"
  },
  {
    "job_id": 552322,
    "job_title": "Associate Director- Data Insights",
    "company_name": "AT&T",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "255829.5",
    "skills": "pyspark"
  },
  {
    "job_id": 552322,
    "job_title": "Associate Director- Data Insights",
    "company_name": "AT&T",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "255829.5",
    "skills": "jupyter"
  },
  {
    "job_id": 552322,
    "job_title": "Associate Director- Data Insights",
    "company_name": "AT&T",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "255829.5",
    "skills": "excel"
  },
  {
    "job_id": 552322,
    "job_title": "Associate Director- Data Insights",
    "company_name": "AT&T",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "255829.5",
    "skills": "tableau"
  },
  {
    "job_id": 552322,
    "job_title": "Associate Director- Data Insights",
    "company_name": "AT&T",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "255829.5",
    "skills": "power bi"
  },
  {
    "job_id": 552322,
    "job_title": "Associate Director- Data Insights",
    "company_name": "AT&T",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "255829.5",
    "skills": "powerpoint"
  },
  {
    "job_id": 99305,
    "job_title": "Data Analyst, Marketing",
    "company_name": "Pinterest Job Advertisements",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "232423.0",
    "skills": "sql"
  },
  {
    "job_id": 99305,
    "job_title": "Data Analyst, Marketing",
    "company_name": "Pinterest Job Advertisements",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "232423.0",
    "skills": "python"
  },
  {
    "job_id": 99305,
    "job_title": "Data Analyst, Marketing",
    "company_name": "Pinterest Job Advertisements",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "232423.0",
    "skills": "r"
  },
  {
    "job_id": 99305,
    "job_title": "Data Analyst, Marketing",
    "company_name": "Pinterest Job Advertisements",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "232423.0",
    "skills": "hadoop"
  },
  {
    "job_id": 99305,
    "job_title": "Data Analyst, Marketing",
    "company_name": "Pinterest Job Advertisements",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "232423.0",
    "skills": "tableau"
  },
  {
    "job_id": 1021647,
    "job_title": "Data Analyst (Hybrid/Remote)",
    "company_name": "Uclahealthcareers",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "217000.0",
    "skills": "sql"
  },
  {
    "job_id": 1021647,
    "job_title": "Data Analyst (Hybrid/Remote)",
    "company_name": "Uclahealthcareers",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "217000.0",
    "skills": "crystal"
  },
  {
    "job_id": 1021647,
    "job_title": "Data Analyst (Hybrid/Remote)",
    "company_name": "Uclahealthcareers",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "217000.0",
    "skills": "oracle"
  },
  {
    "job_id": 1021647,
    "job_title": "Data Analyst (Hybrid/Remote)",
    "company_name": "Uclahealthcareers",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "217000.0",
    "skills": "tableau"
  },
  {
    "job_id": 1021647,
    "job_title": "Data Analyst (Hybrid/Remote)",
    "company_name": "Uclahealthcareers",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "217000.0",
    "skills": "flow"
  },
  {
    "job_id": 168310,
    "job_title": "Principal Data Analyst (Remote)",
    "company_name": "SmartAsset",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "205000.0",
    "skills": "sql"
  },
  {
    "job_id": 168310,
    "job_title": "Principal Data Analyst (Remote)",
    "company_name": "SmartAsset",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "205000.0",
    "skills": "python"
  },
  {
    "job_id": 168310,
    "job_title": "Principal Data Analyst (Remote)",
    "company_name": "SmartAsset",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "205000.0",
    "skills": "go"
  },
  {
    "job_id": 168310,
    "job_title": "Principal Data Analyst (Remote)",
    "company_name": "SmartAsset",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "205000.0",
    "skills": "snowflake"
  },
  {
    "job_id": 168310,
    "job_title": "Principal Data Analyst (Remote)",
    "company_name": "SmartAsset",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "205000.0",
    "skills": "pandas"
  },
  {
    "job_id": 168310,
    "job_title": "Principal Data Analyst (Remote)",
    "company_name": "SmartAsset",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "205000.0",
    "skills": "numpy"
  },
  {
    "job_id": 168310,
    "job_title": "Principal Data Analyst (Remote)",
    "company_name": "SmartAsset",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "205000.0",
    "skills": "excel"
  },
  {
    "job_id": 168310,
    "job_title": "Principal Data Analyst (Remote)",
    "company_name": "SmartAsset",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "205000.0",
    "skills": "tableau"
  },
  {
    "job_id": 168310,
    "job_title": "Principal Data Analyst (Remote)",
    "company_name": "SmartAsset",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "205000.0",
    "skills": "gitlab"
  },
  {
    "job_id": 731368,
    "job_title": "Director, Data Analyst - HYBRID",
    "company_name": "Inclusively",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "189309.0",
    "skills": "sql"
  },
  {
    "job_id": 731368,
    "job_title": "Director, Data Analyst - HYBRID",
    "company_name": "Inclusively",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "189309.0",
    "skills": "python"
  },
  {
    "job_id": 731368,
    "job_title": "Director, Data Analyst - HYBRID",
    "company_name": "Inclusively",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "189309.0",
    "skills": "azure"
  },
  {
    "job_id": 731368,
    "job_title": "Director, Data Analyst - HYBRID",
    "company_name": "Inclusively",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "189309.0",
    "skills": "aws"
  },
  {
    "job_id": 731368,
    "job_title": "Director, Data Analyst - HYBRID",
    "company_name": "Inclusively",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "189309.0",
    "skills": "oracle"
  },
  {
    "job_id": 731368,
    "job_title": "Director, Data Analyst - HYBRID",
    "company_name": "Inclusively",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "189309.0",
    "skills": "snowflake"
  },
  {
    "job_id": 731368,
    "job_title": "Director, Data Analyst - HYBRID",
    "company_name": "Inclusively",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "189309.0",
    "skills": "tableau"
  },
  {
    "job_id": 731368,
    "job_title": "Director, Data Analyst - HYBRID",
    "company_name": "Inclusively",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "189309.0",
    "skills": "power bi"
  },
  {
    "job_id": 731368,
    "job_title": "Director, Data Analyst - HYBRID",
    "company_name": "Inclusively",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "189309.0",
    "skills": "sap"
  },
  {
    "job_id": 731368,
    "job_title": "Director, Data Analyst - HYBRID",
    "company_name": "Inclusively",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "189309.0",
    "skills": "jenkins"
  },
  {
    "job_id": 731368,
    "job_title": "Director, Data Analyst - HYBRID",
    "company_name": "Inclusively",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "189309.0",
    "skills": "bitbucket"
  },
  {
    "job_id": 731368,
    "job_title": "Director, Data Analyst - HYBRID",
    "company_name": "Inclusively",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "189309.0",
    "skills": "atlassian"
  },
  {
    "job_id": 731368,
    "job_title": "Director, Data Analyst - HYBRID",
    "company_name": "Inclusively",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "189309.0",
    "skills": "jira"
  },
  {
    "job_id": 731368,
    "job_title": "Director, Data Analyst - HYBRID",
    "company_name": "Inclusively",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "189309.0",
    "skills": "confluence"
  },
  {
    "job_id": 310660,
    "job_title": "Principal Data Analyst, AV Performance Analysis",
    "company_name": "Motional",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "189000.0",
    "skills": "sql"
  },
  {
    "job_id": 310660,
    "job_title": "Principal Data Analyst, AV Performance Analysis",
    "company_name": "Motional",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "189000.0",
    "skills": "python"
  },
  {
    "job_id": 310660,
    "job_title": "Principal Data Analyst, AV Performance Analysis",
    "company_name": "Motional",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "189000.0",
    "skills": "r"
  },
  {
    "job_id": 310660,
    "job_title": "Principal Data Analyst, AV Performance Analysis",
    "company_name": "Motional",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "189000.0",
    "skills": "git"
  },
  {
    "job_id": 310660,
    "job_title": "Principal Data Analyst, AV Performance Analysis",
    "company_name": "Motional",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "189000.0",
    "skills": "bitbucket"
  },
  {
    "job_id": 310660,
    "job_title": "Principal Data Analyst, AV Performance Analysis",
    "company_name": "Motional",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "189000.0",
    "skills": "atlassian"
  },
  {
    "job_id": 310660,
    "job_title": "Principal Data Analyst, AV Performance Analysis",
    "company_name": "Motional",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "189000.0",
    "skills": "jira"
  },
  {
    "job_id": 310660,
    "job_title": "Principal Data Analyst, AV Performance Analysis",
    "company_name": "Motional",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "189000.0",
    "skills": "confluence"
  },
  {
    "job_id": 1749593,
    "job_title": "Principal Data Analyst",
    "company_name": "SmartAsset",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "186000.0",
    "skills": "sql"
  },
  {
    "job_id": 1749593,
    "job_title": "Principal Data Analyst",
    "company_name": "SmartAsset",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "186000.0",
    "skills": "python"
  },
  {
    "job_id": 1749593,
    "job_title": "Principal Data Analyst",
    "company_name": "SmartAsset",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "186000.0",
    "skills": "go"
  },
  {
    "job_id": 1749593,
    "job_title": "Principal Data Analyst",
    "company_name": "SmartAsset",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "186000.0",
    "skills": "snowflake"
  },
  {
    "job_id": 1749593,
    "job_title": "Principal Data Analyst",
    "company_name": "SmartAsset",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "186000.0",
    "skills": "pandas"
  },
  {
    "job_id": 1749593,
    "job_title": "Principal Data Analyst",
    "company_name": "SmartAsset",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "186000.0",
    "skills": "numpy"
  },
  {
    "job_id": 1749593,
    "job_title": "Principal Data Analyst",
    "company_name": "SmartAsset",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "186000.0",
    "skills": "excel"
  },
  {
    "job_id": 1749593,
    "job_title": "Principal Data Analyst",
    "company_name": "SmartAsset",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "186000.0",
    "skills": "tableau"
  },
  {
    "job_id": 1749593,
    "job_title": "Principal Data Analyst",
    "company_name": "SmartAsset",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "186000.0",
    "skills": "gitlab"
  },
  {
    "job_id": 387860,
    "job_title": "ERM Data Analyst",
    "company_name": "Get It Recruit - Information Technology",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "184000.0",
    "skills": "sql"
  },
  {
    "job_id": 387860,
    "job_title": "ERM Data Analyst",
    "company_name": "Get It Recruit - Information Technology",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "184000.0",
    "skills": "python"
  },
  {
    "job_id": 387860,
    "job_title": "ERM Data Analyst",
    "company_name": "Get It Recruit - Information Technology",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "184000.0",
    "skills": "r"
  }
-- ]

with remote_job_skills AS (
select 
        skills_to_job.skill_id,
    count (*) as total_remote_jobs
    from skills_job_dim as skills_to_job
    inner join job_postings_fact as job_postings
        ON skills_to_job.job_id = job_postings.job_id
        where job_postings.job_work_from_home = true and 
        job_postings.job_title_short ='Data Analyst'
group by skills_to_job.skill_id)
select 
    skills.skill_id,
    skills.skills,
    remote_job_skills.total_remote_jobs as remote_data_analyst_jobs
from skills_dim as skills
INNER JOIN remote_job_skills
  ON skills.skill_id = remote_job_skills.skill_id
order by remote_job_skills.total_remote_jobs DESC
LIMIT 5;

--top demand skills--

select *
from job_postings_fact
INNER join skills_job_dim
  on skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim
  ON skills_job_dim.skill_id = skills_dim.skill_id
limit 10;