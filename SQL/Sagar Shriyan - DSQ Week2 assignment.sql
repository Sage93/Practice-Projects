-- Create an ER diagram or draw a schema for the given database.


-- We want to reward the user who has been around the longest, Find the 5 oldest users.
select * from users order by created_at limit 5;


-- To understand when to run the ad campaign, figure out the day of the week most users register on? 
select  dayname(created_at) as Max_reg_days, count(*) as No_of_days 
from users 
group by dayname(created_at) 
order by count(*) desc 
limit 2; 

-- OR

select dayname(created_at) as Max_reg_days, count(*) as No_of_days 
from users 
group by Max_reg_days
having  No_of_days = (select max(No_of_days) from 
(select dayname(created_at) as Max_reg_days, count(*) as No_of_days 
from users 
group by Max_reg_days)as max); 

-- To target inactive users in an email ad campaign, find the users who have never posted a photo.
select id, username from users where id not in (select user_id from photos);


-- Suppose you are running a contest to find out who got the most likes on a photo. Find out who won?
select u.username, p.id, count(*) as No_of_likes
from likes l
join photos p on p.id = l.photo_id
join users u on u.id = l.user_id
group by p.id
order by No_of_likes desc
limit 1;


-- The investors want to know how many times does the average user post.
select ((select count(*) from photos)/(select count(*) from users)) as avg_user_post;


-- A brand wants to know which hashtag to use on a post, and find the top 5 most used hashtags.
select t.tag_name, count(*) as Hashtag_count from tags t 
join photo_tags p on p.tag_id = t.id 
group by p.tag_id 
order by Hashtag_count desc limit 5;


-- To find out if there are bots, find users who have liked every single photo on the site.
select id, username as bots from users
join likes on likes.user_id = users.id
group by users.id
having count(*) = (select count(*) from photos);


-- To know who the celebrities are, find users who have never commented on a photo.
select id, username from users where id not in (select user_id from comments);


-- Now it's time to find both of them together, find the users who have never commented on any photo or have commented on every photo. 
select id, username from users where id not in (select user_id from comments)
union
select id, username from users u where id in
(select user_id from comments group by user_id 
having count(user_id) = (select count(id) from photos));
