CREATE TABLE orders (
    order_id        BIGINT,
    user_id         BIGINT,
    restaurant_id   BIGINT,
    order_date      TIMESTAMP,
    order_amount    NUMERIC(10,2),
    discount_amount NUMERIC(10,2),
    delivery_cost   NUMERIC(10,2)
);


CREATE TABLE users (
    user_id      BIGINT,
    signup_date  DATE,
    city         VARCHAR(50),
    user_type    VARCHAR(20)
);


CREATE TABLE restaurants (
    restaurant_id    BIGINT,
    restaurant_name  VARCHAR(100),
    category         VARCHAR(50),
    city             VARCHAR(50),
    rating           NUMERIC(3,1)
);

select*from orders;
select*from restaurants;
select*from users;

select order_amount,order_id from orders 
where order_amount<0;

--cleaning orders table 

CREATE OR REPLACE VIEW vw_orders_clean AS
SELECT
    order_id,
    user_id,
    restaurant_id,
    CAST(order_date AS DATE) AS order_date,

    order_amount,

    CASE
        WHEN discount_amount > order_amount THEN order_amount
        ELSE discount_amount
    END AS discount_amount,

    COALESCE(
        delivery_cost,
        AVG(delivery_cost) OVER ()
    ) AS delivery_cost,

    order_amount
      - CASE
            WHEN discount_amount > order_amount THEN order_amount
            ELSE discount_amount
        END
      - COALESCE(delivery_cost, AVG(delivery_cost) OVER ()) AS profit

FROM orders
WHERE order_amount > 0;

select*from vw_orders_clean;

SELECT COUNT(*) FROM orders;
SELECT COUNT(*) FROM vw_orders_clean;


--users table cleaning 

CREATE OR REPLACE VIEW vw_users_clean AS
SELECT
    user_id,
    signup_date,

    -- Normalize city (NULL + casing)
    COALESCE(INITCAP(city), 'Unknown') AS city,

    -- User segmentation
    user_type
FROM users;

SELECT COUNT(*) FROM users;
SELECT COUNT(*) FROM vw_users_clean;

SELECT city, COUNT(*)
FROM vw_users_clean
GROUP BY city
ORDER BY COUNT(*) DESC;

--resaurants cleaning 

CREATE OR REPLACE VIEW vw_restaurants_clean AS
SELECT
    restaurant_id,
    restaurant_name,

    -- Normalize category casing
    INITCAP(category) AS category,

    city,

    -- Fill missing ratings using category average
    COALESCE(
        rating,
        AVG(rating) OVER (PARTITION BY INITCAP(category))
    ) AS rating
FROM restaurants;

SELECT COUNT(*) FROM restaurants;
SELECT COUNT(*) FROM vw_restaurants_clean;

SELECT category, COUNT(*)
FROM vw_restaurants_clean
GROUP BY category
ORDER BY COUNT(*) DESC;

--now creating view for checking profit leakage 

CREATE OR REPLACE VIEW vw_profit_leakage AS
SELECT
    r.city AS restaurant_city,
    r.category,
    u.user_type,

    COUNT(o.order_id) AS total_orders,
    SUM(o.order_amount) AS total_revenue,
    SUM(o.discount_amount) AS total_discount,
    SUM(o.delivery_cost) AS total_delivery_cost,
    SUM(o.profit) AS total_profit,

    ROUND(
        SUM(o.profit) / NULLIF(SUM(o.order_amount), 0) * 100,
        2
    ) AS profit_margin_pct

FROM vw_orders_clean o
JOIN vw_users_clean u
    ON o.user_id = u.user_id
JOIN vw_restaurants_clean r
    ON o.restaurant_id = r.restaurant_id

GROUP BY
    r.city,
    r.category,
    u.user_type;
SELECT *
FROM vw_profit_leakage
ORDER BY total_profit ASC
LIMIT 10;


--creating view for retentions and repeat customer

CREATE OR REPLACE VIEW vw_customer_retention AS
SELECT
    u.user_id,
    u.user_type,
    u.city,

    COUNT(o.order_id) AS total_orders,

    -- Repeat flag
    CASE
        WHEN COUNT(o.order_id) > 1 THEN 'Repeat'
        ELSE 'One-Time'
    END AS customer_type,

    SUM(o.order_amount) AS total_revenue,
    SUM(o.discount_amount) AS total_discount,
    SUM(o.profit) AS total_profit,

    -- Avg discount per order
    ROUND(
        AVG(o.discount_amount),
        2
    ) AS avg_discount_per_order

FROM vw_orders_clean o
JOIN vw_users_clean u
    ON o.user_id = u.user_id

GROUP BY
    u.user_id,
    u.user_type,
    u.city;
SELECT customer_type, COUNT(*) AS customers
FROM vw_customer_retention
GROUP BY customer_type;

--making a view for checking growth 

CREATE OR REPLACE VIEW vw_growth_split AS
WITH first_order AS (
    SELECT
        user_id,
        MIN(order_date) AS first_order_date
    FROM vw_orders_clean
    GROUP BY user_id
)
SELECT
    CASE
        WHEN o.order_date = f.first_order_date THEN 'New Customer'
        ELSE 'Repeat Customer'
    END AS customer_order_type,

    COUNT(o.order_id) AS total_orders,
    SUM(o.order_amount) AS total_revenue,
    SUM(o.profit) AS total_profit,

    ROUND(
        SUM(o.profit) / NULLIF(SUM(o.order_amount), 0) * 100,
        2
    ) AS profit_margin_pct

FROM vw_orders_clean o
JOIN first_order f
    ON o.user_id = f.user_id

GROUP BY
    customer_order_type;

SELECT * FROM vw_growth_split;
	



