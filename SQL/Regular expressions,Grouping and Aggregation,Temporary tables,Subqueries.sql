# DDL - Create, Alter, Drop, Truncate
# DML - Insert, Update, Delete, Selectactor_awardactor

use mavenmovies;
select * from actor;

-- starting with P 
select * from actor where first_name like 'P%';
select * from actor where first_name regexp '^p';

-- ends with E 
select * from actor where first_name like '%e';
select * from actor where first_name regexp 'e$';

-- has AL anywhere in it
select * from actor where first_name like '%AL%';
select * from actor where first_name regexp 'al+';

-- like % _
-- regexp 
* (0 or more occurance of the pattern), 
+ (1 or more occurance of the pattern), 
? zero or one character match;

one character match, 
b%t [aei]
b_t;

create table test1(objname varchar(10));
insert into test1 values('cat'),('bat'),('bet'),('beg'),('bit'),('but'),('bot');
insert into test1 values('butti');
select * from test1;

-- underscore equivaluent is . (dot) in rlike
select * from test1 where objname like '_a_' or objname like '_e_' or objname like '_i_';

select * from test1 where objname rlike '[iou]?[t]{2}'; -- will match any1 or more of i,o,u and 2 instance of t

-- Regexp
--  [abc] any character between the square brackets
-- [^abc] any character at this position except the ones mentioned in square brackets
-- ^a starts with a
-- b$ ends with b
-- [a-p] range of values can be matched
-- [^a-p] range of values should not be there
-- *(0 or more), ?(0 or 1), + (1 or more) how many occurance of pattern do you expect
-- multiple pattern
-- digits [0-9][0-9][0-9] counted number of occurance

-- Aggregate functions
-- Are used for calculation of sum/avg/count/min/max of all values in a column - always the output is 1 row
 use mavenmovies;
select * from payment;
select staff_id, customer_id, count(amount), sum(amount), min(amount) , max(amount), avg(amount) 
from payment where amount > 1 group by customer_id, staff_id having count(*) > 10 order by count(*);

-- grouping is needed only when aggregation is needed
-- use all column names in select  for grouping as well
-- FJWGHSDO
-- From, Join, Where, Group by, Having(filter for aggregated data), select, distinct, order by

-- Subquery
select * from payment where amount = 11.99; -- hardcoding 
select max(amount) from payment;

select * from payment where amount = (select max(amount) from payment);

-- Independent Subqueries (Inner subquery is independent of outer subquery)
-- inner subquery may return exactly 1 row can use =
-- else use 'in' for comparision --1 or multiple rows, or multiple rows
-- Corelated Subqueries (inner query is dependent on outer query for some data)
-- when aggregate comparision is required, subqueries to be used
-- when subqueries cannot be used--> when data in select is needed from multiple tables, then joins are must

-- write a query to get the maximum staff sales count
-- oracle format-- select max(count(*)) from payment group by staff_id;
select * from staff where staff_id in (select staff_id from payment group by staff_id having count(*)=(select max(count) from (
select count(staff_id) as count from payment group by staff_id) as count_tab));

-- select the second highest paying customer OR
-- max which is not equal to max
select max(amount) from payment where amount = (select max(amount) from payment where amount <>(select Max(amount) from payment));

select distinct amount from payment order by amount desc limit 3;

create table emp(
empid int primary key,
ename varchar(20) not null,
esal int,
mgr int);

alter table emp add constraint emp_mgr_reln foreign key(mgr) references emp(empid); -- self referencing fk
insert into emp values(1,'Sneha', 100000, null), (2,'Neha', 150000, 1), (3,'Rishi', 200000, 2);
insert into emp values(4,'Raj',50000,3);

select * from emp;

-- show details of emp whose salary > neha's salary
select * from emp e where e.mgr in (select m.empid from emp m where e.esal > m.esal);

-- Select details of all emp whose salary is greater than their managers
select e.ename, e.esal as emp_salary, m.ename,m.esal as mgr_salary from emp e join emp m on e.mgr=m.empid;