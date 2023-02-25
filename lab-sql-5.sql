USE sakila;
# 1. Drop column `picture` from `staff`.
ALTER TABLE staff
DROP COLUMN picture;

# 2. A new person is hired to help Jon. Her name is TAMMY SANDERS, and she is a customer. Update the database accordingly.
SELECT * FROM customer
WHERE first_name = 'Tammy' AND last_name = 'Sanders';

SELECT * FROM staff
WHERE first_name = 'Jon';

INSERT INTO staff values(75,'TAMMY','SANDERS',79,'TAMMY.SANDERS@sakilacustomer.org',2,1,' ',' ','2006-02-15 04:57:20');

SELECT * FROM staff
WHERE first_name = 'Tammy' AND last_name = 'Sanders'; # Checking if it worked

# 3. Add rental for movie "Academy Dinosaur" by Charlotte Hunter from Mike Hillyer at Store 1. 
# You can use current date for the `rental_date` column in the `rental` table.
# **Hint**: Check the columns in the table rental and see what information you would need to add there. 
# You can query those pieces of information. For eg., you would notice that you need `customer_id` 
# information as well. 

SELECT customer_id FROM sakila.customer
WHERE first_name = 'CHARLOTTE' AND last_name = 'HUNTER'; # Result: 130

# Use similar method to get `inventory_id`, `film_id`, and `staff_id`
SELECT staff_id FROM staff
WHERE first_name = 'Mike' and last_name = 'Hillyer'; # Result: 1

SELECT store_id
FROM staff
WHERE staff_id = 1; # Result: 1

SELECT film_id FROM film
WHERE title = 'Academy Dinosaur'; # Result: 1

SELECT * FROM inventory
WHERE film_id = 1 AND store_id = 1 # Finding the last assigned inventory_id in the specific shop: 4
LIMIT 5; 

SELECT * FROM rental
# WHERE return_date IS NULL # To see if to put ' ' or NULL when dreating the value return_date
ORDER BY rental_id DESC # Finding the last assigned rental_id: 16049
LIMIT 5;

INSERT INTO rental values(16050, '2023-02-25 14:14:30', 5, 130, NULL, 1, '2023-02-25 14:14:30');

SELECT * FROM rental
ORDER BY rental_id DESC
LIMIT 3; # Checking if it worked

# 4. Delete non-active users, but first, create a _backup table_ `deleted_users` to store `customer_id`, `email`, and 
# the `date` for the users that would be deleted. Follow these steps:
#   - Check if there are any non-active users
SELECT DISTINCT active FROM sakila.customer;

#   - Create a table _backup table_ as suggested
SELECT * FROM customer 
ORDER BY customer_id DESC
LIMIT 5;

DROP table deleted_users;

CREATE table deleted_users(
customer_id int(3) default null,
email text,
date DATETIME not null
);
#   - Insert the non active users in the table _backup table_
SELECT * FROM customer
WHERE active = 0;

INSERT INTO deleted_users (customer_id, email, date)
SELECT customer_id, email, create_date # Selecting only those columns I want to extract. I used the create_date since I considered it the more interesting one of the two.
FROM customer
WHERE active = 0; # Unsing a WHERE condition instead of manually copying

SELECT * FROM deleted_users;

#   - Delete the non active users from the table customer
SET FOREIGN_KEY_CHECKS=0; # disable foreign key checks

DELETE FROM customer
WHERE active = 0;

SET FOREIGN_KEY_CHECKS=1; # enable foreign key checks

SELECT * FROM customer
WHERE active = 0; # Checking if it worked