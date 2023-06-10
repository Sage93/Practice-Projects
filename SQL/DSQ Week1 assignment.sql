DSQ Week1 assignment

-- Write a SQL query to find the actors who played a role in the movie 'Annie IDENTITY’. Return all the fields of the actor table.
select a.first_name, a.last_name from actor a 
inner join film_actor fa on a.actor_id = fa.actor_id
inner join film f on f.film_id = fa.film_id
where f.title like 'Annie Identity';

-- Which customer has the highest customer ID number, whose first name starts with an 'E' and has an address ID lower than 500?
select first_name, last_name from customer 
where first_name like "e%" and address_id<500 
order by customer_id desc limit 1;

-- Find the films which are rented by both Indian and Pakistani customers. (Hint: You can use CTE’s)
select  c.country, f.title from country c 
inner join city ci on c.country_id=ci.country_id
inner join address a on a.city_id=ci.city_id
inner join customer cu on cu.address_id=a.address_id
inner join inventory i on i.store_id=cu.store_id
inner join film f on f.film_id=i.film_id
group by cu.customer_id having c.country in ("India", "pakistan")
order by c.country desc;

-- Find the films (if any) which are rented by Indian customers and not rented by Pakistani customers.
select f.title from country c 
inner join city ci on c.country_id=ci.country_id
inner join address a on a.city_id=ci.city_id
inner join customer cu on cu.address_id=a.address_id
inner join inventory i on i.store_id=cu.store_id
inner join film f on f.film_id=i.film_id
group by cu.customer_id;
#having c.country <> "Pakistan";


-- Find the customers who paid a sum of 100 dollars or more, for all the rentals taken by them.
select c.first_name, sum(p.amount) as Total_Amt from customer c 
inner join payment p on p.customer_id=c.customer_id 
group by p.customer_id having sum(p.amount)>100;
