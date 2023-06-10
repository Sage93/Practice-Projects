CASE Expressions,Common Table Expressions (CTE) and recursive CTE

select * from emp;
-- case statements are alternative to if else if in programming
SELECT *,
CASE
WHEN esal <= 100000 THEN esal * 1.2
ELSE esal * 1.1
END inc_sal
FROM emp;



select a.actor_id, a.first_name, aa.awards,
case
when awards='Emmy' or awards='oscar' or awards='tony' then 1
when awards='Emmy,Tony' or awards='Oscar,Tony' or awards='Emmy, Oscar' then 2
when awards='Emmy,Tony, Oscar' then 3
else 0
end award_count
from actor_award aa 
right outer join actor a on a.actor_id=aa.actor_id;



-- Write a query to give a cashback to customers based on thier total amount paid till date. If total amt > 100$ give 10% cashback, else 5% cashback

with temp_tbl as           -- with cte_name as (select stmnt to get data into this CTE)
(select customer_id, sum(amount) as total_amt from payment
group by customer_id)
select * from customer where customer_id in (
select customer_id from  temp_tbl where total_amt > 100);
select * from temp_tbl;


select * from customer where customer_id in (
select customer_id from payment group by customer_id having sum(amount)>
(select max(amount) from payment));



use mavenmovies;
with max_val as (select avg(amount) from payment),
cust_amt as(select customer_id, sum(amount) as total from payment
group by customer_id having sum(amount)>(select * from max_val))
select * from cust_amt;



-- select all customer names having amount > 100 dollars
create temporary table cust_100 as (
select customer_id, sum(amount) from payment group by customer_id having sum(amount)>100);
select * from cust_100;

select first_name from customer where customer_id in (select customer_id from cust_100);



-- co related subquery
select customer_id, avg(amount), staff_id from payment p1
group by customer_id, staff_id having avg(amount)> (
select avg(amount) from payment p2 where p1.staff_id=p2.staff_id);



select * from orderdetails;
select * from orders o join orderdetails od using(ordernumber);  -- instead of on o.orderNumber=od.orderNumber;



use classicmodls;

WITH topsales2003 AS (
SELECT salesRepEmployeeNumber, employeeNumber, SUM(quantityOrdered * priceEach) sales
FROM orders
INNER JOIN orderdetails on orders.orderNumber=orderdetails.orderNumber
INNER JOIN customers USING (customerNumber)
WHERE YEAR(shippedDate) = 2003 AND status = 'Shipped'
GROUP BY salesRepEmployeeNumber
ORDER BY sales DESC LIMIT 5)
SELECT employees.employeeNumber, firstName, lastName, sales FROM employees
JOIN topsales2003 on employees.employeeNumber=topsales2003.employeeNumber 
where topsales2003.sales > 300000;
    


WITH salesrep AS (
SELECT employeeNumber, CONCAT(firstName, ' ', lastName) AS salesrepName
FROM employees WHERE jobTitle = 'Sales Rep'),
customer_salesrep AS (
SELECT customerName, salesrepName FROM customers
INNER JOIN salesrep ON employeeNumber = salesrepEmployeeNumber)
-- salesrep is the CTE used in another CTE just like inner and outer subquery
SELECT * FROM customer_salesrep ORDER BY customerName;



-- recursive cte
use classicmodels;

with recursive rs as (select employeenumber, firstname, 1  as m_level, reportsto as manager_name 
from employees where reportsTo is null 
union all
select e.employeenumber, e.firstname, m_level+1, e.reportsto as manager_name  from employees e
join rs on  e.reportsto=rs.employeenumber)
select rse.firstname as emp,rsm.firstname as mgr, rse.m_level emp_level, rsm.m_level m_level  from rs as rse 
join rs as rsm on rse.manager_name=rsm.employeenumber;



WITH RECURSIVE employee_paths AS (
SELECT employeeNumber, reportsTo managerNumber, officeCode, 1 lvl
FROM employees WHERE reportsTo IS NULL
UNION ALL
SELECT e.employeeNumber, e.reportsTo, e.officeCode, lvl+1 FROM employees e
INNER JOIN employee_paths ep ON ep.employeeNumber = e.reportsTo)
SELECT employeeNumber, managerNumber, lvl, city FROM employee_paths ep
INNER JOIN offices o USING (officeCode)
ORDER BY lvl, city;