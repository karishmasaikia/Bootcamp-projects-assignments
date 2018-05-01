use sakila;

-- * 1a.Display the first and last names of all actors from the table actor--
select first_name 'First Name', last_name 'Last Name'
from actor;

-- --* 1b.Display the first and last name of each actor in a single column in upper case letters-- 
-- --Name the column `Actor Name`--
select concat(first_name,' ', last_name) as `Actor Name` from actor;

-- * 2a.You need to find the ID number, first name, and last name of an actor, of whom you know only the 
-- first name, "Joe." What is one query would you use to obtain this information?
select actor_id, first_name, last_name
from actor
where first_name = 'Joe';

-- * 2b.Find all actors whose last name contain the letters `GEN`:
select * from actor where last_name like '%gen%' ;

-- * 2c.Find all actors whose last names contain the letters `LI`. 
-- This time, order the rows by last name and first name, in that order:
-- This sorts by the LastName field, then by the FirstName field if LastName matches.
select * from actor where last_name like '%li%' ORDER BY last_name, first_name;

-- * 2d.Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan
-- Bangladesh, and China:
-- The IN operator allows you to specify multiple values in a WHERE clause.
select country_id, country
from country
where country in ('Afghanistan' ,'Bangladesh' ,'China');

-- * 3a.Add a `middle_name` column to the table `actor`. Position it between `first_name` and `last_name`. 
-- Hint: you will need to specify the data type.
alter table actor
add middle_name varchar(30) null after first_name;

-- * 3b.You realize that some of these actors have tremendously long last names. Change the data type of 
-- the `middle_name` column to `blobs`.
alter table actor
modify column middle_name blob;

-- * 3c. Now delete the `middle_name` column.
alter table actor
drop column middle_name;

-- * 4a. List the last names of actors, as well as how many actors have that last name.
select distinct last_name, count(last_name) as 'last_name_count' from actor
group by last_name;


-- * 4b. List last names of actors and the number of actors who have that last name, but only for names 
-- that are shared by at least two actors
-- The HAVING clause was added to SQL because the WHERE keyword could not be used with aggregate functions.
select distinct last_name, count(last_name) as 'last_name_count' from actor
group by last_name
having last_name_count >= 2;

-- * 4c. Oh, no! The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`, 
-- the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.
update actor
set first_name = 'HARPO'
where first_name = 'GROUCHO' and last_name = 'WILLIAMS';

-- * 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` 
-- was the correct name after all! In a single query, if the first name of the actor is currently `HARPO`, 
-- change it to `GROUCHO`. Otherwise, change the first name to `MUCHO GROUCHO`, as that is 
-- exactly what the actor will be with the grievous error.
update actor
set first_name = case
	when first_name = 'HARPO' then first_name = 'GROUCHO'
	ELSE 'MUCHO GROUCHO'
    end
where actor_id = 172 ;  

-- * 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?  
-- describe sakila.address
create table `address`(
	`address_id` smallint(5) unsigned not null auto_increment,
    `address` varchar(50) not null,
    `address2` varchar(50) default null,
    `district` varchar(20) not null,
    `city_id` smallint(5) unsigned not null,
    `postal_code` varchar(10) default null,
    `phone` varchar(30) not null,
    `location` geometry not null,
    `last_update` timestamp default current_timestamp on update current_timestamp,
    primary key (`address_id`)
 ) engine=innodb default charset=latin1

-- * 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. 
-- Use the tables `staff` and `address`:
select staff.first_name, staff.last_name, address.address
from staff
inner join address on staff.address_id = address.address_id;

-- * 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. 
-- Use tables `staff` and `payment`. 
select staff.first_name, staff.last_name, sum(payment.amount) as 'amount_rung'
from staff
left join payment on staff.staff_id = payment.staff_id
where payment.payment_date like '2005-08%'
group by staff.first_name, staff.last_name;

-- * 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. 
-- Use inner join.

-- * 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
select film.title, count(inventory.film_id) as 'copies'
from film
inner join inventory on film.film_id = inventory.film_id
where film.title = 'Hunchback Impossible';
 
-- * 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by 
-- each customer. List the customers alphabetically by last name:   
select customer.last_name,sum(payment.amount) as 'customer_pay'
from customer
inner join payment on payment.customer_id = customer.customer_id
group by customer.customer_id 
order  by customer.last_name asc;


-- * 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
-- As an unintended consequence, films starting with the letters `K` and `Q` have also soared in 
-- popularity. Use subqueries to display the titles of movies starting with the letters `K` and `Q` 
-- whose language is English. 
select title 
from film
where (title like 'K%' or title like 'Q%')
and language_id = (select language_id from language where name='English');


-- * 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.
select first_name, last_name
from actor
where actor_id 
	in (select actor_id from film_actor where film_id
		in (select film_id from film where title = 'ALONE TRIP'));

-- * 7c. You want to run an email marketing campaign in Canada, for which you will need the names and 
-- email addresses of all Canadian customers. Use joins to retrieve this information. 
select first_name, last_name, email
from customer   
inner join address on address.address_id = customer.address_id
inner join city on city.city_id = address.city_id
inner join country on country.country_id = city.country_id

where country.country = 'Canada';
-- 
-- * 7d. Sales have been lagging among young families, and you wish to target all family movies for a 
-- promotion. Identify all movies categorized as famiy films.
select title from film
inner join film_category on film_category.film_id = film.film_id
inner join category on category.category_id = film_category.category_id
where category.name = 'family';

-- * 7e. Display the most frequently rented movies in descending order.
select count(rental_id) as 'rental_count', title from rental
inner join inventory on inventory.inventory_id = rental.inventory_id
inner join film on film.film_id = inventory.film_id
group by title 
order by rental_count desc;

-- * 7f. Write a query to display how much business, in dollars, each store brought in.
select sum(amount) as 'dollars' , store_id from payment
inner join staff on payment.staff_id = staff.staff_id
group by store_id
order by dollars;

-- * 7g. Write a query to display for each store its store ID, city, and country.
select store.store_id, city.city, country.country from store
inner join address on address.address_id = store.address_id
inner join city on city.city_id = address.city_id
inner join country on country.country_id = city.country_id;


-- * 7h. List the top five genres in gross revenue in descending order. (**Hint**: you may need to use the 
-- following tables: category, film_category, inventory, payment, and rental.)
select category.name, sum(payment.amount) as 'total' from category
inner join film_category on film_category.category_id = category.category_id
inner join inventory on inventory.film_id = film_category.film_id
inner join rental on rental.inventory_id = inventory.inventory_id
inner join payment on payment.rental_id = rental.rental_id
group by name
order by total desc
limit 5;

-- * 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query 
-- to create a view.
create view top_five_genres_rev as
	select category.name, sum(payment.amount) as 'total' from category
	inner join film_category on film_category.category_id = category.category_id
	inner join inventory on inventory.film_id = film_category.film_id
	inner join rental on rental.inventory_id = inventory.inventory_id
	inner join payment on payment.rental_id = rental.rental_id
	group by name
	order by total desc
	limit 5;
-- 
-- * 8b. How would you display the view that you created in 8a?
select * from top_five_genres_rev  ;  

-- * 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.
drop view if exists top_five_genres_rev
    
	




    

    


