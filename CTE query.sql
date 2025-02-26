-- This SQL query is used to Find the Top 5 Customers that are present in the Top 10 Cities of the Top 10 Countries --

-- This CTE was used to find Top 10 Countries by Customer_ID count to find distinct customer count --

WITH top_10_countries AS (
	SELECT D.country
	FROM customer A
	JOIN address B ON A.address_id = B.address_id
	JOIN city C ON B.city_id = C.city_id
	JOIN country D ON C.country_id = D.country_id
	GROUP BY D.country
	ORDER BY COUNT (A.customer_id) DESC
	LIMIT 10
	),

-- The results of the top_10_countries CTE above was then used to find the Top 10 Cities within the Top 10 Countries --

top_10_cities AS (
	SELECT D.country, C.city
	FROM customer A
	INNER JOIN address B ON A.address_id = B.address_id
	INNER JOIN city C ON B.city_id = C.city_id
	INNER JOIN country D ON C.country_id = D.country_id
	WHERE (D.country) IN (SELECT country FROM top_10_countries)
	GROUP BY D.country, C.city
	ORDER BY COUNT (A.customer_id) DESC
	LIMIT 10
	),

-- This CTE Takes the result of the above CTE to find the total_amount_paid --
customer_payments AS (
	SELECT B.customer_id,
	       B.first_name,
           B.last_name,
           E.country,
           D.city,
           SUM(A.amount) AS total_amount_paid
	FROM payment A
	INNER JOIN customer B ON A.customer_id = B.customer_id
	INNER JOIN address C ON B.address_id = C.address_id
	INNER JOIN city D ON C.city_id = D.city_id
	INNER JOIN country E ON D.country_id = E.country_id
	WHERE (E.country, D.city) IN (SELECT country, city FROM top_10_cities)
	GROUP BY  B.customer_id, B.first_name, B.last_name, E.country, D.city
)

-- Here we Select the final CTE made and Select the first_name, last_name, country, city and total_amount paid, placing a limit of 5 to find the Top 5 Customers --
SELECT *
FROM customer_payments
ORDER BY total_amount_paid DESC
LIMIT 5;