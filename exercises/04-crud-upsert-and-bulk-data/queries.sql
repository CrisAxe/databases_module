SELECT title, length, rating
FROM film
WHERE rating = "PG-13" AND length > 120 
ORDER BY title;

SELECT first_name, last_name 
FROM actor
WHERE  last_name ILIKE '%son%'

SELECT rental_id, return_date
FROM rental
WHERE return_date IS NULL

SELECT rental_duration
FROM film
GROUP BY  rental_duration BETWEEN 3 AND 7
ORDER BY rental_duration ASC;

