-- Descriptive Statistics For Numerical Values in Film Table -- 
SELECT COUNT(*) AS count_rows,

-- release_year column --
MIN (release_year) AS earliest_release_year,
MAX (release_year) AS latest_release_year,
AVG (release_year) AS average_release_year,
COUNT (release_year) AS count_release_year,

-- rental_duration columnm --
MIN (rental_duration) AS minimum_rental_duration,
MAX (rental_duration) AS maximum_rental_duration,
AVG (rental_duration) AS average_rental_duration,
COUNT (rental_duration) AS count_rental_duration,

-- rental_rate column -- 
MIN (rental_rate) AS minimum_rental_rate,
MAX (rental_rate) AS maximum_rental_rate,
AVG (rental_rate) AS average_rental_rate,
COUNT (rental_rate) AS count_rental_rate,

-- length column -- 
MIN (length) AS minimum_film_length,
MAX (length) AS maximum_film_length,
AVG (length) AS average_film_length,
COUNT (length) AS count_film_length,

-- replacement_cost column --
MIN (replacement_cost) AS minimum_replacement_cost,
MAX (replacement_cost) AS maximum_replpacement_cost,
AVG (replacement_cost) AS average_replacement_cost,
COUNT (replacement_cost) AS count_replacement_cost
FROM film;