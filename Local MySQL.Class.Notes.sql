
CREATE TABLE employee_demographics (
  employee_id INT NOT NULL,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  age INT,
  gender VARCHAR(10),
  birth_date DATE,
  PRIMARY KEY (employee_id)
);

CREATE TABLE employee_salary (
  employee_id INT NOT NULL,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  occupation VARCHAR(50),
  salary INT,
  dept_id INT
);


INSERT INTO employee_demographics (employee_id, first_name, last_name, age, gender, birth_date)
VALUES
(1,'Leslie', 'Knope', 44, 'Female','1979-09-25'),
(3,'Tom', 'Haverford', 36, 'Male', '1987-03-04'),
(4, 'April', 'Ludgate', 29, 'Female', '1994-03-27'),
(5, 'Jerry', 'Gergich', 61, 'Male', '1962-08-28'),
(6, 'Donna', 'Meagle', 46, 'Female', '1977-07-30'),
(7, 'Ann', 'Perkins', 35, 'Female', '1988-12-01'),
(8, 'Chris', 'Traeger', 43, 'Male', '1980-11-11'),
(9, 'Ben', 'Wyatt', 38, 'Male', '1985-07-26'),
(10, 'Andy', 'Dwyer', 34, 'Male', '1989-03-25'),
(11, 'Mark', 'Brendanawicz', 40, 'Male', '1983-06-14'),
(12, 'Craig', 'Middlebrooks', 37, 'Male', '1986-07-27');


INSERT INTO employee_salary (employee_id, first_name, last_name, occupation, salary, dept_id)
VALUES
(1, 'Leslie', 'Knope', 'Deputy Director of Parks and Recreation', 75000,1),
(2, 'Ron', 'Swanson', 'Director of Parks and Recreation', 70000,1),
(3, 'Tom', 'Haverford', 'Entrepreneur', 50000,1),
(4, 'April', 'Ludgate', 'Assistant to the Director of Parks and Recreation', 25000,1),
(5, 'Jerry', 'Gergich', 'Office Manager', 50000,1),
(6, 'Donna', 'Meagle', 'Office Manager', 60000,1),
(7, 'Ann', 'Perkins', 'Nurse', 55000,4),
(8, 'Chris', 'Traeger', 'City Manager', 90000,3),
(9, 'Ben', 'Wyatt', 'State Auditor', 70000,6),
(10, 'Andy', 'Dwyer', 'Shoe Shiner and Musician', 20000, NULL),
(11, 'Mark', 'Brendanawicz', 'City Planner', 57000, 3),
(12, 'Craig', 'Middlebrooks', 'Parks Director', 65000,1);



CREATE TABLE parks_departments (
  department_id INT NOT NULL AUTO_INCREMENT,
  department_name varchar(50) NOT NULL,
  PRIMARY KEY (department_id)
);

INSERT INTO parks_departments (department_name)
VALUES
('Parks and Recreation'),
('Animal Control'),
('Public Works'),
('Healthcare'),
('Library'),
('Finance');


variables * from employee_salary; 
 


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
row_number() over(partition by gender order by dem.last_name, dem.first_name) as rows_ranking
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
    
    --ctes --实现递归，突破查询极限 -- don't understand this part yet

with cte_example as 
(
SELECT gender, avg(salary), max(salary),min(salary),count(salary)
FROM parks_and_recreation.employee_demographics as dem
inner join parks_and_recreation.employee_salary as sal
	on sal.employee_id = dem.employee_id
group by gender
)
select *
from cte_example;  

with cte_example as 
(
SELECT gender, avg(salary) as avg_sal, max(salary) as max_sal, min(salary) as min_sal, count(salary) as count_sal
FROM parks_and_recreation.employee_demographics as dem
inner join parks_and_recreation.employee_salary as sal
	on sal.employee_id = dem.employee_id
group by gender
)
select avg(avg_sal)
from cte_example; 

with cte_example as 
(
SELECT employee_id, gender, birth_date
FROM parks_and_recreation.employee_demographics as dem
where birth_date > '1985-01-01'
), 
cte_example2 as 
(
select employee_id, salary
from employee_salary
where salary > 50000
)
select * 
from cte_example
join cte_example2
on cte_example.employee_id = cte_example2.employee_id

with cte_example (Gender, Avg_sal, Max_sal, Min_sal, Count_sal) as 
(
SELECT gender, avg(salary), max(salary), min(salary), count(salary)
FROM parks_and_recreation.employee_demographics as dem
inner join parks_and_recreation.employee_salary as sal
	on sal.employee_id = dem.employee_id
group by gender
)
select *
from cte_example;   

--temporary tables --
create temporary table temp_table
(first_name varchar(50), 
last_name varchar(50), 
favorate_movie varchar(100)
);
select *
from temp_table;
insert into temp_table (first_name, last_name, favorate_movie )
values
('Frank', 'Wei', 'Godfather'), 
('Ray', 'Wei', 'The Wild Robot'), 
('Kay', 'Wei', 'Demon Hunter'),
('Jay', 'Yuan', 'It"s is a Wonderful Life'); 
truncate table temp_table

create temporary table salary_over_50k
select *
from employee_salary
where salary >=50000;
select*
from salary_over_50ksalary_over_50k`salary_over_50k`

--stored procedures --
create procedure salary_over_50k()
select *
from employee_salary
where salary >=50000;

call salary_over_50k();

delimiter $$
create procedure salary2_over_50k()
begin
	select *
	from employee_salary
	where salary >=50000;
	select *
	from employee_salary
	where dept_id = 1;
end $$
delimiter ;

CALL  salary2_over_50k()

--parameters, there should be a whole lot more behind this--
delimiter $$
create procedure salary3_over_50k(p_employee_id INT)
begin
	select salary
	from employee_salary
	where employee_id=p_employee_id;
end $$
delimiter ;

call salary3_over_50k(5); 

--trigger and events --

select first_name, last_name, 'Senior Woman' as layoff_group
from employee_demographics 

select first_name, last_name,  'High Pay' as layoff_group
from employee_salary

delimiter $$
create trigger employee_insert
	after insert on employee_salary
    for each row
begin
insert into employee_demographics (employee_id, first_name, last_name)
values (new.employee_id, new.first_name, new.last_name);
end $$
delimiter ;

--for existing difference, this will not help--
insert into employee_salary (employee_id, first_name, last_name, occupation, salary, dept_id)
values(2, Ron, Swanson, 'Director of Parks and Recreation', 70000, 1)

--for new employees in the employee_salary table, this triggers the change in the employee_demographics table--
insert into employee_salary (employee_id, first_name, last_name, occupation, salary, dept_id)
values(13, 'Jean-Ralphio', 'Saperstein', 'Exntertainment 720 CEO', 1000000, null)

insert into employee_salary (employee_id, first_name, last_name, occupation, salary, dept_id)
values(14, 'LT', 'Saperstein', 'Blue Owl CFO', 700000, null); 

delimiter $$
create event delete_retirees
on schedule every 24 MINUTE
do 
begin
	delete 
	from employee_demographics 
    where age >= 60; 
end $$
delimiter ;;

DROP EVENT delete_retirees;
show events

--data cleaning--

show triggers
drop trigger employee_insert
show variables like 'event%'
