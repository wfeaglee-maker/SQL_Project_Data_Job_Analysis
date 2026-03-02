select 
first_name, 
last_name, 
birth_date, 
age, 
(age - 10) * 10
from employee_demographics; 
#pemdas

select distinct gender 
from employee_demographics; 

select * 
from employee_demographics
where gender = "Male";

SELECT * 
FROM parks_and_recreation.employee_salary
where salary >= 50000;

--
SELECT * 
FROM parks_and_recreation.employee_demographics
where gender != 'Male';

SELECT * 
FROM parks_and_recreation.employee_demographics
where birth_date > '1984-12-01';

--logical operators and or not --

SELECT * 
FROM parks_and_recreation.employee_demographics
where birth_date > '1984-12-01' or gender != 'male';

SELECT * 
FROM parks_and_recreation.employee_demographics
where birth_date > '1984-12-01' and gender != 'male';

SELECT * 
FROM parks_and_recreation.employee_demographics
where (first_name = 'Leslie' and age = 44) or age > 55;

--like statement--%, _ --
SELECT * 
FROM parks_and_recreation.employee_demographics
where first_name like 'a%';

SELECT * 
FROM parks_and_recreation.employee_demographics
where first_name like 'a___%';

SELECT * 
FROM parks_and_recreation.employee_demographics
where birth_date like '1989%';

--group by, order by --
SELECT gender 
FROM parks_and_recreation.employee_demographics
group by gender; 

SELECT gender, count(*) 
FROM parks_and_recreation.employee_demographics
group by gender; 

SELECT gender, avg(age), min(age), max(age), count(*) 
FROM parks_and_recreation.employee_demographics
group by gender; 

--notice how null is used in screening, is not null --
SELECT dept_id, sum(salary) as total_salary
FROM parks_and_recreation.employee_salary
where dept_id is not null
group by dept_id
order by dept_id, total_salary desc; 

SELECT occupation, avg(salary) 
FROM parks_and_recreation.employee_salary
group by occupation
order by avg(salary) desc;

SELECT gender, avg(age), min(age), max(age), count(*) 
FROM parks_and_recreation.employee_demographics
group by gender
order by gender, avg(age);

-- having after group by will make logic sense, for aggregation columns --
SELECT gender, avg(age) 
FROM parks_and_recreation.employee_demographics
group by gender
having avg(age) > 40; 

SELECT occupation, avg(salary) 
FROM parks_and_recreation.employee_salary
where occupation like '%manager%'
group by occupation
having avg(salary) > 75000;

SELECT *
FROM parks_and_recreation.employee_demographics
order by age desc
limit 5;

SELECT *
FROM parks_and_recreation.employee_demographics
order by age desc
limit 3, 1; 

--aliasing
SELECT gender, avg(age) as avg_age
FROM parks_and_recreation.employee_demographics
group by gender
having avg_age > 40; 

SELECT occupation, avg(salary), gender 
FROM parks_and_recreation.employee_salary
inner join parks_and_recreation.employee_demographics 
	on parks_and_recreation.employee_salary.employee_id = parks_and_recreation.employee_demographics.employee_id
group by occupation, gender; 

SELECT * 
FROM parks_and_recreation.employee_salary as sal
inner join parks_and_recreation.employee_demographics as dem
	on sal.employee_id = dem.employee_id;

SELECT * 
FROM parks_and_recreation.employee_salary as sal
inner join parks_and_recreation.employee_demographics as dem
	on sal.employee_id = dem.employee_id;
--notice the output difference between left join and right join on employee_id = 2 --    
SELECT sal.employee_id, age, occupation 
FROM parks_and_recreation.employee_salary as sal
left join parks_and_recreation.employee_demographics as dem
	on sal.employee_id = dem.employee_id;
    
SELECT sal.employee_id, age, occupation 
FROM parks_and_recreation.employee_salary as sal
right join parks_and_recreation.employee_demographics as dem
	on sal.employee_id = dem.employee_id;
    
--self join--
SELECT 
emp1.employee_id as emp_santa,
emp1.first_name as first_name_santa, 
emp1.last_name as last_name_santa, 
emp2.employee_id as emp_name,
emp2.first_name as first_name_emp, 
emp2.last_name as last_name_emp
FROM parks_and_recreation.employee_salary as emp1
join parks_and_recreation.employee_salary as emp2
	on emp1.employee_id + 1 = emp2.employee_id
 
 --join multiple tables --
SELECT sal.employee_id,  sal.first_name, sal.last_name, age, gender, birth_date, occupation, salary, dept_id, department_name
FROM parks_and_recreation.employee_salary as sal 
left join parks_and_recreation.employee_demographics as dem
	on sal.employee_id = dem.employee_id
inner join parks_and_recreation.parks_departments as park 
	on sal.dept_id = park.department_id; 
--union, while going beyond existing columns, i.e. adding aggregate or ranking columns, running against the combined table--
select first_name, last_name, ROW_NUMBER() OVER (ORDER BY first_name, last_name) AS row_num
from(
select first_name, last_name 
from employee_demographics 
union all
select first_name, last_name 
from employee_salary) combined; 


select first_name, last_name 
from employee_demographics 
union 
select first_name, last_name 
from employee_salary;

select first_name, last_name 
from employee_demographics 
union all
select first_name, last_name 
from employee_salary;

select first_name, last_name, 'Senior Man' as layoff_group
from employee_demographics 
where age > 40 and gender = 'male'
union 
select first_name, last_name, 'Senior Woman' as layoff_group
from employee_demographics 
where age > 40 and gender = 'female'
union
select first_name, last_name,  'High Pay' as layoff_group
from employee_salary
where salary > 70000
order by first_name, last_name

select first_name, last_name, count(*) as group_count
from(
	select first_name, last_name, 'Senior Man' as layoff_group
	from employee_demographics 
	where age > 40 and gender = 'male'
	union all
	select first_name, last_name, 'Senior Woman' as layoff_group
	from employee_demographics 
	where age > 40 and gender = 'female'
	union all
	select first_name, last_name,  'High Pay' as layoff_group
	from employee_salary
	where salary > 70000
	) as combined
group by first_name, last_name
having count(*) >= 2; 

--string functions, length, upper, lower, trim, ltrim, rtrim, left, right, substring, replace, concat --
select length ('skyfall');

select upper(first_name), upper(last_name), length(last_name)
from employee_demographics
order by length(last_name); 

select first_name, left(first_name,4)
from employee_demographics;

select first_name, last_name, substring(birth_date, 6, 2) as month_of_date
from employee_demographics
order by month_of_date

SELECT 
    MONTH(birth_date) AS month_of_date,
    COUNT(*) AS total_people
FROM employee_demographics
GROUP BY MONTH(birth_date)
ORDER BY month_of_date;

select first_name, replace(first_name, 'a', 'z')
FROM employee_demographics
		
select first_name, locate('An',first_name)
FROM employee_demographics      

select first_name, last_name, concat( first_name, ' ', last_name) as full_name
FROM employee_demographics; 

--case when % sign has it own meaning, cannot be used in multiplication--
select first_name, last_name, age,
case 
	when age <= 30 then 'Young'
    when age between 31 and 50 then 'Old'
    else "on Death's Door"
    end as age_bracket
FROM employee_demographics; 

select first_name, last_name, age,
case 
	when age <= 30 then 'Young'
    when age between 31 and 50 then 'Old'
    else "on Death's Door"
    end as age_bracket
FROM employee_demographics; 

select first_name, last_name, salary, 
case
	when salary < 50000 then salary + salary * 0.05
	when salary >= 50000 then salary + salary * 0.07
end as new_salary, 
case 
	when dept_id = 6 then salary * 0.1 
end as bonus
from employee_salary; 

when dept_id = 6 then salary + salary * 10% as new_salary

--subquery; where*** in () one column only--


where employee_id in 
	(select employee_id
    from employee_salary
    where dept_id =1);
    
select first_name, last_name, salary, 
(select avg(salary)
from employee_salary) as group_avg_salary
from employee_salary
having salary > group_avg_salary
order by salary desc; 

select avg (`max(age)`), avg(`min(age)`)
from (
select gender, min(age), max(age), avg(age), count(age)
FROM employee_demographics  
group by gender) as gender_diff

--window function, running total --

SELECT gender, avg(salary) as avg_salary
FROM parks_and_recreation.employee_demographics as dem
inner join parks_and_recreation.employee_salary as sal
	on sal.employee_id = dem.employee_id
group by gender;     

SELECT dem.first_name, dem.last_name, gender, avg(salary) over(partition by gender)
FROM parks_and_recreation.employee_demographics as dem
inner join parks_and_recreation.employee_salary as sal
	on sal.employee_id = dem.employee_id; 

SELECT dem.first_name, dem.last_name, gender, sum(salary) over(partition by gender)
FROM parks_and_recreation.employee_demographics as dem
inner join parks_and_recreation.employee_salary as sal
	on sal.employee_id = dem.employee_id; 

SELECT dem.first_name, dem.last_name, gender, salary, sum(salary) over(partition by gender order by sal.employee_id) as rolling_total
FROM parks_and_recreation.employee_demographics as dem
inner join parks_and_recreation.employee_salary as sal
	on sal.employee_id = dem.employee_id; 
    
SELECT dem.first_name, dem.last_name, gender, salary,
row_number() over(partition by gender) as rows_ranking
FROM parks_and_recreation.employee_demographics as dem
inner join parks_and_recreation.employee_salary as sal
	on sal.employee_id = dem.employee_id; 
    
SELECT dem.first_name, dem.last_name, gender, salary,
row_number() over(partition by gender order by salary) as rows_num,
rank() over(partition by gender order by salary) as rows_ranking
FROM parks_and_recreation.employee_demographics as dem
inner join parks_and_recreation.employee_salary as sal
	on sal.employee_id = dem.employee_id; 
  
SELECT dem.first_name, dem.last_name, gender, salary,
row_number() over(partition by gender order by salary) as rows_num,
rank() over(partition by gender order by salary) as rows_ranking,
dense_rank() over(partition by gender order by salary) as rows_ranking
FROM parks_and_recreation.employee_demographics as dem
inner join parks_and_recreation.employee_salary as sal
	on sal.employee_id = dem.employee_id;     