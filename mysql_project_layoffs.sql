SELECT * FROM world_layoffs.layoffs;
--1. remove duplicates
--2. standardize the data
--3. null values or blank values
--4. remove columns/rows unnessary
--5. create table layoffs-staging

--how to remove duplicate--
CREATE TABLE layoffs_staging
LIKE layoffs; 

insert layoffs_staging 
select *
from layoffs; 

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

insert into layoffs_staging2
    SELECT *,
        row_number() OVER(
            PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions
        ) AS row_num
    FROM layoffs_staging; 
    
select *
from layoffs_staging2
where row_num > 1; 

delete
from layoffs_staging2
where row_num > 1; 

--standardizing data--

select distinct(trim(company))
from layoffs_staging2;

select company, trim(company)
from layoffs_staging2;

update layoffs_staging2
set company = trim(company); 
select *
from layoffs_staging2;

select distinct(industry)
from layoffs_staging2
order by industry;

--中英文单引号还不一样--
select *
from layoffs_staging2
where industry like 'Crypto%'

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

select *
from layoffs_staging2
where country like 'United States%'
order by country desc; 

UPDATE layoffs_staging2 
SET 
    country = TRIM(TRAILING '.' FROM country)
WHERE
    country LIKE 'United States%';

SELECT DISTINCT(country)
FROM layoffs_staging2
ORDER BY country;

SELECT 
    date, STR_TO_DATE(date, '%m/%d/%Y')
FROM
    layoffs_staging2; 

UPDATE layoffs_staging2 
SET date = STR_TO_DATE(date, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE; 

--nulls and blank value--

select *
from layoffs_staging2
where total_laid_off is null; 

UPDATE layoffs_staging2 
SET industry = 'Travel'
WHERE company = 'Airbnb'; 

select *
from layoffs_staging2
where company = 'Bally''s Interactive'; 

select *
from layoffs_staging2
where industry is null;

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = ''; 

select t1.industry, t2.industry
from layoffs_staging2 t1
join layoffs_staging2 t2
on t1.company = t2.company
where t1.industry is null or t1.industry = ''
and t2.industry is not null; 

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL AND t2.industry IS NOT NULL; 

select *
from layoffs_staging2
where company like 'Bally%';

select *
from layoffs_staging2
where total_laid_off is null and percentage_laid_off is null; 

DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL; 

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

--explore data --

select max(total_laid_off), avg(percentage_laid_off)
from layoffs_staging2;

--median total_laid_off --
SELECT AVG(total_laid_off) AS median
FROM (
    SELECT total_laid_off,
           ROW_NUMBER() OVER (ORDER BY total_laid_off) AS rn,
           COUNT(*)     OVER ()                        AS cnt
    FROM layoffs_staging2
    WHERE total_laid_off IS NOT NULL
) AS ranked
WHERE rn IN (FLOOR((cnt + 1) / 2), CEIL((cnt + 1) / 2));

select industry, location, sum(total_laid_off), sum(funds_raised_millions)
from layoffs_staging2
where percentage_laid_off = 1
group by location, industry; 

select *
from layoffs_staging2
where percentage_laid_off = 1
order by funds_raised_millions desc;

select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

select industry, sum(total_laid_off)
from layoffs_staging2
group by industry
order by sum(total_laid_off) desc; 

select location, sum(total_laid_off)
from layoffs_staging2
where total_laid_off is not null
group by location
order by sum(total_laid_off) desc;

select min(`date`), MAX(`date`)
from layoffs_staging2

select country, sum(total_laid_off)
from layoffs_staging2
where total_laid_off is not null
group by country
order by sum(total_laid_off) desc;

select month(`date`), sum(total_laid_off)
from layoffs_staging2
where total_laid_off is not null and `date` is not null
group by month(`date`)
order by sum(total_laid_off) desc;

select `date`, sum(total_laid_off)
from layoffs_staging2
where total_laid_off is not null and `date` is not null
group by `date`
order by `date`;

select year(`date`), sum(total_laid_off)
from layoffs_staging2
where total_laid_off is not null and `date` is not null
group by year(`date`)
order by 1 desc;

select stage, sum(total_laid_off)
from layoffs_staging2
where total_laid_off is not null
group by stage
order by 1 desc;

select month(`date`), sum(total_laid_off)
from layoffs_staging2
where total_laid_off is not null and `date` is not null
group by month(`date`)
order by sum(total_laid_off) desc;

select substring(`date`,6,2) as `month`, sum(total_laid_off)
from layoffs_staging2
group by `month`; 

select substring(`date`,1,7) as `month`, sum(total_laid_off)
from layoffs_staging2
where substring(`date`,1,7) is not null
group by `month`
order by 1 asc;

with rolling_total as (
 select substring(`date`,1,7) as `month`, sum(total_laid_off) as total_laid_off
from layoffs_staging2
where substring(`date`,1,7) is not null
group by `month`
order by 1 asc
)
select `month`, total_laid_off, sum(total_laid_off) over(order by `month`) as rolling_total_laid_off
from rolling_total

select company, year(`date`),sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
order by sum(total_laid_off) desc;

with company_year (company, year, total_laid_off)as 
(
select company, year(`date`),sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
), 
company_year_rank as (
select *, DENSE_RANK() over (partition by year order by total_laid_off desc) as ranking
from company_year
where year is not null
)
select *
from company_year_rank
where ranking <= 3
