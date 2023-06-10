DSQ week 2 mentorship

-- Views can be created, dropped, altered and updated
-- Views make it easy to read data which is required frequently

create view indian_customers as
(select f.film_id, c.customer_id from rental r, customer c, address a, city ci, country co, inventory i, film f where
r.customer_id=c.customer_id and
c.address_id=a.address_id and
a.city_id=ci.city_id and
ci.country_id=co.country_id and
r.inventory_id=i.inventory_id and
i.film_id=f.film_id and country='India');

select * from indian_customers;

-- create a view
create view cities_of_india as
select * from city where country_id=(select country_id from country where country='India');

select * from cities_of_india where city like 'M%';  # select from a view

select * from city where city='Mysore';

update cities_of_india set city_id=35000 where city_id=350;  # update a view

drop view cities_of_india;

# Relational DB : ACID properties (Atomicity, Consistency, Isolation and Durability)
-- Atomicity : A transaction should be done completely or not at all
-- consistency: once data is updated, shd be correct everywhere
-- Isolation: any parellel transaction shd not interfere with each other
-- durability: transaction are commited

select * from emp;
update emp set esal=esal*1.2 where mgr is not null;
select * from emp;
update emp set esal=esal*2 where mgr is null;
rollback;

-- users trying to fetch mobile phone details in price range 10-15k

create view budget_mobiles as
(select * from electronics where category='mobiles' 
and price between 10000 and 15000);

select * from budget_mobiles;

update budget_mobiles set stock=0 where mobile_id=101;

-- write a stored procedure to calculate bonus amount based on current sal and ,manager
-- if manager then bonus is 10% of current sal
-- if emp then bonus is 5% of curren sal
-- if salary is less than 1 lakh add extra bonus of 2 %

CREATE PROCEDURE bonus(in p_empid int, out p_bonus int)
BEGIN
declare v_manager int;
select esal, mgr into p_bonus, v_manager from emp where empid=p_empid;
if v_manager is not null then
 if p_bonus<100000 then
 set p_bonus= p_bonus*0.07;
else 
 set p_bonus= p_bonus*0.05;
end if;
else
 if p_bonus<100000 then
 set p_bonus= p_bonus*0.12;
else 
 set p_bonus= p_bonus*0.10;
end if;
end if;
END

select * from emp;

call bonus(1,@bonus);
select @bonus;

-- Write a procedure to show employees their salary for next 10 years if avg hike is 10% PA.
CREATE DEFINER=`root`@`localhost` PROCEDURE `next_10_sal`(in p_empid int, 
out p_10th_sal int)
BEGIN
declare v_year int;
declare v_current_sal int;
set v_year=0;
select esal into v_current_sal from emp where empid=p_empid;
while v_year<10 do
set v_current_sal= v_current_sal*1.1;
set v_year=v_year+1;
select v_current_sal, v_year;
end while;
set p_10th_sal=v_current_sal;
END
call next_10_sal(1,@last_sal);
select @last_sal;

CREATE PROCEDURE count_cities(
in p_country_name varchar(50))
BEGIN
declare p_count int;
select count(*) into p_count from city where country_id=(
select country_id from country where country=p_country_name);
select p_count;
select p_country_name,p_count;
END

call count_cities()

CREATE PROCEDURE city_count_hardcode()
BEGIN
select count(*) from city where country_id=(select country_id  from country where country = 'India');
END

call city_count_hardcode()

-- Calculate the total number of Rental days per customer-- do not use sub-queries
select customer_id, datediff(return_date, rental_date) as Rental_days from rental group by customer_id order by customer_id;

-- Create a procedure for odd numbers 1 to 10
CREATE PROCEDURE odd()
BEGIN
declare num int default 1;
declare res varchar(50);
set res = num 
while num < 10 do
set num = num + 2;
set res = num;
end while;
select res;
END

call odd();

-- List the film title with the category Name
select f.title, c.name from film f 
join film_category fc on f.film_id = fc.film_id
join category c on c.category_id = fc.category_id;

-- List the number of films by each category
select c.name, count(*) as No_of_films from film f 
join film_category fc on f.film_id = fc.film_id
join category c on c.category_id = fc.category_id
group by c.name;

-- List the movies which were never rented out
select f.title from film f 
join inventory i on f.film_id=i.film_id
join rental r on r.inventory_id=i.inventory_id
where datediff(return_date,rental_date)=0;