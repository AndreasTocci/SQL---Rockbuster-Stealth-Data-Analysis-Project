-- Non-Numerical Descriptive Statistics for Film Table -- 
SELECT
MODE() WITHIN GROUP(ORDER BY rating) AS modal_rating,
MODE() WITHIN GROUP(ORDER BY language_id) AS modal_language_id
FROM film;