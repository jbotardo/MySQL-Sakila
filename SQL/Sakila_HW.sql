USE sakila;

-- 1a. Display the first and last names of all actors from the table `actor`.

SELECT
	first_name, last_name
FROM
	actor;
    
-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`.

SELECT
	actor_id,
    CONCAT_WS(' ', UPPER(first_name), UPPER(last_name)) AS 'Actor Name'
FROM
	actor;
    
-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
 SELECT
	actor_id, first_name, last_name
From
	actor
WHERE
	first_name = 'Joe';
    
    
-- 2b. Find all actors whose last name contain the letters `GEN`:

SELECT
	actor_id, first_name, last_name
FROM
	actor
WHERE
	last_name LIKE '%gen%';
    
-- * 2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:
SELECT
	last_name, first_name
FROM
	actor
WHERE
	last_name LIKE '&Li&';
    
-- 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:

SELECT
	country_id, country
FROM
	country
WHERE
	country IN ("Afghanistan", "Bangladesh", "China");
    
-- 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table `actor` named `description` and use the data type `BLOB` (Make sure to research the type `BLOB`, as the difference between it and `VARCHAR` are significant).

ALTER TABLE actor
ADD COLUMN description BLOB;

-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the `description` column.

ALTER TABLE actor
DROP COLUMN description;

-- 4a. List the last names of actors, as well as how many actors have that last name.

SELECT
	last_name, COUNT(last_name) AS total
FROM
	actor
GROUP BY
	last_name;
    
-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors.

SELECT
	last_name, COUNT(last_name) AS total
FROM
	actor
GROUP BY
	last_name
HAVING total >= 2;

-- 4c. The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`. Write a query to fix the record.

UPDATE
	actor
SET
	first_name = "Harpo"
WHERE
	first_name = "Groucho" AND last_name = "Williams";
    
-- 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all! In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.

SELECT * FROM 
	actor
Where 
	first_name = "Harpo";
    
-- 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?
SHOW CREATE TABLE address;

-- 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:

SELECT
	first_name, last_name, address
From
	staff s
    
    JOIN
    address a ON s.address_id = a.address_id;
    
-- 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`.

SELECT
	first_name, last_name, SUM(AMOUNT) AS 'Total Amount'
FROM
	staff s 
    
INNER JOIN
	payment p
ON
	s.staff_id = p.staff_id
GROUP BY
	p.staff_id;
    
-- 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.

SELECT
	title, COUNT(actor_id) AS 'Actor Count'
FROM
	film f
INNER JOIN 
	film_actor fa 
ON
	f.film_id = fa.film_id
GROUP BY 
	title;
    
-- 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?

SELECT
	title, COUNT(inventory_id) AS 'Number of Copies'
FROM
	film f
INNER JOIN
	inventory i
ON
	f.film_id = i.film_id
WHERE
	title = 'Hunchback Impossible';
    
-- 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name:

SELECT
	first_name, last_name, SUM(AMOUNT) AS 'Total Paid'
FROM
	customer c
    
JOIN
	payment p ON c.customer_id = p.customer_id
    
GROUP BY
	first_name, last_name

ORDER BY
	last_name;
    
-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.

SELECT
	title
FROM
	film
WHERE
	title LIKE 'q%'
    OR title LIKE 'k%'
    AND language_id IN (SELECT language_id
    FROM
		language
	WHERE
		name = 'English');

-- 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.

SELECT
	first_name, last_name
FROM
	actor
WHERE
	actor_id IN (SELECT actor_id
    FROM
		film_actor
	WHERE
		film_id IN (SELECT film_id
        FROM 
			film
		WHERE
			title = 'Alone Trip'));
            
-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT
	a.first_name, a.last_name, a.email
FROM
	customer as a
INNER JOIN
	address as b ON b.address_id = a.address_id
INNER JOIN
	city as c ON c.city_id = b.city_id
INNER JOIN
	country as d ON d.country_id = c.country_id
WHERE
	country = 'CANADA';
    
-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as _family_ films.
SELECT
	title
FROM
	film
WHERE
	film_id IN (SELECT film_id
    FROM 
		film_category
    WHERE
		category_id IN (SELECT category_id
        FROM 
			category
        WHERE
			name = 'family'));
            
--  7e. Display the most frequently rented movies in descending order.
SELECT
	title, COUNT(*)
FROM
	payment p
JOIN
	rental r ON p.rental_id = r.rental_id
JOIN
	inventory i ON r.inventory_id = i.inventory_id
JOIN
	film f ON i.film_id = f.film_id
GROUP BY title
ORDER BY COUNT(*) DESC;

-- 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT
	c.store_id, SUM(a.amount) as SALES
FROM
	payment as a
INNER JOIN
	staff as b ON b.staff_id = a.staff_id
INNER JOIN
	store as c ON c.store_id = b.store_id
GROUP BY
	c.store_id;
    
-- 7g. Write a query to display for each store its store ID, city, and country.
SELECT
	store_id, city, country
FROM
	store s
    JOIN
		address a ON s.address_id = a.address_id
	JOIN
		city c ON a.city_id = c.city_id
	JOIN
		country co ON c.country_id = co.country_id;
        
-- 7h. List the top five genres in gross revenue in descending order. (**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT
	a.name as Category, SUM(e.amount) as Sales
FROM
	category as a
INNER JOIN
	film_category as b ON b.category_id = a.category_id
INNER JOIN
	inventory as c ON c.film_id = b.film_id
INNER JOIN
	rental as d ON d.inventory_id = c.inventory_id
INNER JOIN
	payment as e ON e.rental_id = d.rental_id
GROUP BY Category
ORDER BY Sales DESC
LIMIT 5;

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW top_5_genres AS
	SELECT 
		a.name AS Category, SUM(e.amount) as Sales
    FROM 
		category as a
    INNER JOIN
		film_category as b ON b.category_id = a.category_id
	INNER JOIN
		inventory as c ON c.film_id = b.film_id
	INNER JOIN
		rental as d ON d.inventory_id = c.inventory_id
	INNER JOIN
		payment as e ON e.rental_id = d.rental_id
	GROUP BY
		Category
	ORDER BY 
		Sales DESC
	LIMIT 5;
    
-- 8b. How would you display the view that you created in 8a?
SELECT * FROM top_5_genres;

--  8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.
DROP VIEW top_5_genres;


        