-- pull out all customer names from customer table whose names start with either 'm' or 'n' using regexp
select * from customer where first_name rlike '^[m|n]'; 
select * from customer where first_name rlike '^[mn]';

-- find all actor first name which have 'er' in it using regexp
select first_name from actor where first_name rlike '[e][r]'; 
select first_name from actor where first_name rlike 'er'; 

-- list all customers with name ending with 'f' or 's'
select * from customer where first_name rlike '[f|s]$';

-- find sum of amt paid by customer with payment id 155
select sum(amount) as Total_amt from payment where payment_id = 155;

-- Categorize the films into cheap(<=2), moderate(2-5) and expensive(>5) according to their rental rate (use film table)
select title, rental_rate,
case 
when rental_rate <=2 then 'cheap'
when rental_rate <=5 then 'moderate'  
-- when rental_rate between 2 and 5 then 'moderate'
when rental_rate >5 then 'expensive'
end category
from film
order by category;

-- list all actors having 2nd character of their name as a.
select first_name from actor where first_name rlike '^[a-z][a]';
select first_name from actor where first_name rlike '^.a';    -- '.' acts as '_' in rlike

-- Create a temporary table of films with rating as NC-17(use film table or film_list).
create temporary table temp (select * from film where rating = 'NC-17');
select * from temp;

-- Find the average length of the films with rating = NC-17 using CTE
with CTE as (select rating, avg(length) from film where rating = 'NC-17')
Select * from CTE;

-- create a temporary table of films with rating as G(use film table or film_list).
create temporary table temp (select * from film where rating = 'G');
select * from temp;

-- Create a temporary table of all inactive customers from customer table.
create temporary table temp (select * from customer where active = False);
select * from temp;

-- Create a temporary table of all active customers from customer table.
create temporary table temp (select * from customer where active = True);
select * from temp;

-- Find the films rented in the month of august.
select f.title, r.rental_date from rental r 
join inventory i on r.inventory_id=i.inventory_id
join film f on f.film_id=i.film_id
where month(rental_date) = 8
group by f.film_id;

-- Find the customer id who paid the maximum total amount for all rentals.
select customer_id, sum(amount) as Total_amt from payment 
group by customer_id order by total_amt desc limit 1;

-- Joins
select p.customer_id, sum(amount) as Total_amt from payment p 
join rental r on p.rental_id=r.rental_id 
join customer c on c.customer_id=r.customer_id
group by customer_id order by Total_amt desc limit 1;

-- Sub-queries
select customer_id, sum(amount) from payment where customer_id in (select customer_id from rental where customer_id in (
select customer_id from customer)) group by customer_id order by sum(amount) desc limit 1;

-- Using CTE 
with cte1 as (select customer.customer_id from rental join customer 
on rental.customer_id=customer.customer_id group by customer_id)

select payment.customer_id,sum(amount) from payment join cte1 
on payment.customer_id=cte1.customer_id group by customer_id order by sum(amount) desc limit 1;

-- Which actor acted in maximum films?
select a.first_name, count(*) as No_of_movies from film f
join film_actor fa on fa.film_id=f.film_id
join actor a on a.actor_id=fa.actor_id
group by first_name order by no_of_movies desc limit 1;

-- which actor acted in minimum number of films
select a.first_name, count(*) as No_of_movies from film f
join film_actor fa on fa.film_id=f.film_id
join actor a on a.actor_id=fa.actor_id
group by first_name order by no_of_movies limit 1;

-- Using regular expressions, pull the customers from customer table whose last name ends with 'ez'
select * from customer where last_name rlike 'ez$';

-- Find the average length of the films with rating = PG. (use film table)
select title, avg(length) as avg_length, rating from film where rating = 'PG';

-- Find the count of items of inventory at each store
select  s.store_id, count(*) as count_items from store s 
join inventory i on s.store_id = i.store_id group by s.store_id;

-- Find the average replacement cost of the films with rating = PG.(use film table)
select rating, avg(replacement_cost) as Avg_replacement_cost from film where rating = 'PG';

-- Find the maximum and minimum replacement cost of the films with rating = PG.(use film table)
select max(replacement_cost), min(replacement_cost) from film where rating = 'PG';

-- Find the movies whose total rental amount is less than 5 dollars
select f.title, sum(p.amount) as total_rental_amt from payment p 
join rental r on r.customer_id=p.customer_id
join inventory i on i.inventory_id=r.inventory_id
join film f on f.film_id=i.film_id
group by p.rental_id having total_rental_amt < 5;

-- Find the movies whose rental charge is less than 5 dollars.
select f.title, p.amount from payment p 
join rental r on r.customer_id=p.customer_id
join inventory i on i.inventory_id=r.inventory_id
join film f on f.film_id=i.film_id
group by f.title having p.amount < 5;

-- Find the movies whose rental amount is more than 2 dollars.
select f.title, p.amount from payment p 
join rental r on r.customer_id=p.customer_id
join inventory i on i.inventory_id=r.inventory_id
join film f on f.film_id=i.film_id
group by f.title having p.amount > 2;

-- Using like, pull the customers from customer table whose last name ends with ‘er’.
select * from customer where last_name like '%er';

-- Find the sum of the amounts paid by the customer from payment with id = 14642
select customer_id, sum(amount) as total_amt from payment where payment_id = 14642;

-- Find the movies in which the actor with id = 5 acted.
select title, actor_id from film f join film_actor fa on fa.film_id=f.film_id where actor_id = 5;

-- Create a temporary table of in indian customers
create temporary table temp (select cu.customer_id, cu.first_name, c.country from country c 
join city ci on ci.country_id=c.country_id
join address a on a.city_id=ci.city_id
join customer cu on cu.address_id=a.address_id
where country = 'India');
select * from temp;

-- Find the sum of the amounts paid by each customer.(use payment table)
select customer_id, sum(amount) as total_amt from payment group by customer_id;

-- Using regular expressions, pull the customers from customer table whose last name starts with 'An’.
select * from customer where last_name rlike '^an';

-- Find the average replacement cost of the films
select avg(replacement_cost) from film;

-- Find the number of movies rented by customer_id = 5
select customer_id, count(amount) as no_of_movies_rented from payment group by customer_id having customer_id = 5;

-- Find the sum of the amounts paid by the customer from payment with id = 130
select customer_id, payment_id, sum(amount) from payment group by payment_id having payment_id = 130;

-- select all film details having the word 'king' in it
select * from film where title like "%king%";
select * from film where title rlike "king";

-- Find the count of films for each rating
select rating, count(title) as count_of_films from film group by rating;

-- Find the customer id who rented most films.
select customer_id, count(amount) as no_of_film_rented from payment group by customer_id order by no_of_film_rented desc limit 1;

-- Find the customer id who rented least films
select customer_id, count(amount) as no_of_film_rented from payment group by customer_id order by no_of_film_rented limit 1;

-- Using regular expressions, pull the customers from customer table whose last name ends with ‘her’.
select * from customer where last_name rlike 'her$';

-- Find the sum of the amounts paid by each customer.(use payment table)
select customer_id, sum(amount) as Sum_of_amt from payment group by customer_id;