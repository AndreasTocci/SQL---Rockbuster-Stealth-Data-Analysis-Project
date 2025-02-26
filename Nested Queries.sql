-- Main query: Gets country, all customer count, and top customer count
SELECT  
    D.country, 
    COUNT(DISTINCT A.customer_id) AS all_customer_count,
    COUNT(DISTINCT top_customers.customer_id) AS top_customer_count
FROM 
    customer A
    INNER JOIN address B ON A.address_id = B.address_id 
    INNER JOIN city C ON B.city_id = C.city_id
    INNER JOIN country D ON C.country_id = D.country_id 
    -- Left join to include countries even if they have no top customers
    LEFT JOIN (
        -- Subquery: Find the top 5 highest-paying customers from specific city-country pairs
        SELECT 
            B.customer_id,
            B.first_name,
            B.last_name,
            E.country,
            D.city,
            SUM(A.amount) AS total_amount_paid
        FROM 
            payment A
            INNER JOIN customer B ON A.customer_id = B.customer_id 
            INNER JOIN address C ON B.address_id = C.address_id 
            INNER JOIN city D ON C.city_id = D.city_id
            INNER JOIN country E ON D.country_id = E.country_id 
        WHERE 
            -- Filter to include only customers from the top 10 city-country pairs
            (E.country, D.city) IN (
                -- Subquery: Find the top 10 city-country pairs by customer count
                SELECT 
                    D.country, C.city
                FROM 
                    customer A
                    INNER JOIN address B ON A.address_id = B.address_id 
                    INNER JOIN city C ON B.city_id = C.city_id
                    INNER JOIN country D ON C.country_id = D.country_id 
                WHERE 
                    -- Filter to include only cities from the top 10 countries
                    D.country IN (
                        -- Subquery: Find the top 10 countries by customer count
                        SELECT 
                            D.country
                        FROM 
                            customer A
                            JOIN address B ON A.address_id = B.address_id 
                            JOIN city C ON B.city_id = C.city_id
                            JOIN country D ON C.country_id = D.country_id 
                        GROUP BY 
                            D.country
                        ORDER BY 
                            COUNT(A.customer_id) DESC  -- Countries with most customers first
                        LIMIT 10  -- Only the top 10 countries
                    )
                GROUP BY 
                    D.country, C.city
                ORDER BY 
                    COUNT(A.customer_id) DESC  -- City-country pairs with most customers first
                LIMIT 10  -- Only the top 10 city-country pairs
            )
        GROUP BY 
            B.customer_id, B.first_name, B.last_name, D.city, E.country 
        ORDER BY 
            total_amount_paid DESC  -- Customers with highest payment amounts first
        LIMIT 5  -- Only the top 5 highest-paying customers
    ) AS top_customers ON top_customers.country = D.country  -- Join condition links top customers to their countries
GROUP BY 
    D.country
ORDER BY 
    top_customer_count DESC;  -- Countries with most top customers first