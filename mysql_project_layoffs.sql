SELECT * FROM world_layoffs.layoffs;
--1. remove duplicates
--2. standardize the data
--3. null values or blank values
--4. remove columns/rows unnessary
--5. create table layoffs-staging

--how to remove duplicate--
create table layoffs_staging
like layoffs; 

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

update layoffs_staging2
set industry = 'Crypto'
where industry like 'Crypto%';

