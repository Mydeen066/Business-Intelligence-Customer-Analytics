SELECT * FROM customers;
SELECT * FROM products;
SELECT * FROM orders;
SELECT * FROM order_items;
SELECT * FROM website_sessions;
SELECT * FROM customer_activity;

SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM products;
SELECT COUNT(*) FROM orders;
SELECT COUNT(*) FROM order_items;
SELECT COUNT(*) FROM website_sessions;
SELECT COUNT(*) FROM customer_activity;

SELECT 'customers' AS table_name, COUNT(*) AS row_count FROM customers
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL
SELECT 'website_sessions', COUNT(*) FROM website_sessions
UNION ALL
SELECT 'customer_activity', COUNT(*) FROM customer_activity;

SELECT 
	SUM(customer_id IS NULL) AS missing_customers,
    SUM(signup_date IS NULL) AS missing_signup_date,
    SUM(age IS NULL) AS missing_age,
    SUM(gender IS NULL) AS missing_gender,
    SUM(city IS NULL) AS missing_city,
    SUM(state IS NULL) AS missing_state,
    SUM(acquisition_channel IS NULL) AS missing_acquisition_channel
FROM customers

SELECT 
	SUM(product_id IS NULL) AS missing_product_id,
    SUM(product_name IS NULL) AS missing_product_name,
    SUM(category IS NULL) AS missing_category,
    SUM(brand IS NULL) AS missing_brand,
    SUM(unit_price IS NULL) AS missing_unit_price,
    SUM(unit_cost IS NULL) AS missing_unit_cost,
    SUM(rating IS NULL) AS missing_rating
FROM products

SELECT
    SUM(order_id IS NULL) AS missing_order_id,
    SUM(customer_id IS NULL) AS missing_customer_id,
    SUM(order_date IS NULL) AS missing_order_date,
    SUM(order_status IS NULL) AS missing_status,
    SUM(payment_method IS NULL) AS missing_payment,
    SUM(device IS NULL) AS missing_device,
    SUM(sales_channel IS NULL) AS missing_channel
FROM orders;

SELECT 
	SUM(order_id IS NULL) AS missing_order_id,
    SUM(product_id IS NULL) AS missing_product_id,
    SUM(quantity IS NULL) AS missing_quantity,
    SUM(unit_selling_price IS NULL) AS missing_unit_selling_price,
    SUM(discount_pct IS NULL) AS missing_discount_pct,
    SUM(revenue IS NULL) AS missing_revenue,
    SUM(profit IS NULL) AS missing_profit
FROM order_items

SELECT 
	SUM(session_id IS NULL) AS missing_session_id,
    SUM(customer_id IS NULL) AS missing_customer_id,
    SUM(session_date IS NULL) AS missing_session_date,
    SUM(device IS NULL) AS missing_device,
    SUM(traffic_source IS NULL) AS missing_traffic_source,
    SUM(landing_page IS NULL) AS missing_landing_page,
    SUM(pages_viewed IS NULL) AS missing_pages_viewed,
    SUM(session_duration_seconds IS NULL) AS missing_session_duration_seconds,
    SUM(added_to_cart IS NULL) AS missing_added_to_cart,
    SUM(checkout_started IS NULL) AS missing_checkout_started,
    SUM(purchase_completed IS NULL) AS missing_purchase_completed,
    SUM(bounced IS NULL) AS missing_bounced
FROM website_sessions

SELECT 
	SUM(activity_id IS NULL) AS missing_activity_id,
    SUM(customer_id IS NULL) AS missing_customer_id,
    SUM(activity_date IS NULL) AS missing_activity_date,
    SUM(activity_type IS NULL) AS missing_activity_type,
    SUM(device IS NULL) AS missing_device
FROM customer_activity

SELECT customer_id, COUNT(*) as count
FROM customers GROUP BY customer_id HAVING COUNT(*) > 1

SELECT product_id, COUNT(*) as count
FROM products GROUP BY product_id HAVING COUNT(*) > 1

SELECT order_id, COUNT(*) as count
FROM orders GROUP BY order_id HAVING COUNT(*) > 1

SELECT session_id, COUNT(*) as count
FROM website_sessions GROUP BY session_id HAVING COUNT(*) > 1

SELECT activity_id, COUNT(*) as count
FROM customer_activity GROUP BY activity_id HAVING COUNT(*) > 1

SELECT COUNT(*) AS invalid_orders FROM orders o
LEFT JOIN customers c ON c.customer_id = o.customer_id WHERE c.customer_id IS NULL

SELECT COUNT(*) AS invalid_order_items FROM order_items oi
LEFT JOIN orders o ON oi.order_id = o.order_id WHERE o.order_id IS NULL

SELECT COUNT(*) AS invalid_session FROM website_sessions ws
LEFT JOIN customers c ON c.customer_id = ws.customer_id WHERE c.customer_id IS NULL

SELECT COUNT(*) AS invalid_activity FROM customer_activity ca
LEFT JOIN customers c ON c.customer_id = ca.customer_id WHERE c.customer_id IS NULL

SELECT * FROM customers WHERE age < 18 or age > 100

SELECT * FROM customers WHERE signup_date > CURRENT_DATE()

SELECT * FROM products WHERE unit_price <= 0 or unit_cost < 0 or rating > 5 or rating < 0

SELECT * FROM orders WHERE order_date > CURRENT_DATE()

SELECT order_status, COUNT(*) as orders FROM orders GROUP BY order_status

SELECT * FROM order_items WHERE unit_selling_price < 0 or discount_pct < 0 or discount_pct > 1 or revenue < 0

SELECT * FROM website_sessions WHERE pages_viewed < 0 or session_duration_seconds < 0  

SELECT purchase_completed, COUNT(*) as total FROM website_sessions GROUP BY purchase_completed

SELECT activity_type, COUNT(*) as total FROM customer_activity GROUP BY activity_type ORDER BY total desc

SELECT
	ROUND(SUM(oi.revenue)) as total_revenue,
    ROUND(SUM(oi.profit)) as total_profit,
    COUNT(DISTINCT o.order_id) as total_orders,
    ROUND(SUM(oi.profit) / SUM(oi.revenue) * 100) as profit_margin
FROM orders o 
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered'

SELECT 
	DATE_FORMAT(o.order_date, '%Y-%m') AS month,
    ROUND(SUM(oi.revenue),2) as monthly_revenue,
    ROUND(SUM(oi.profit),2) as monthly_profit,
    ROUND(
    SUM(oi.profit) / NULLIF(SUM(oi.revenue), 0) * 100) as profit_margin
FROM orders o 
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered'
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY month
    
SELECT
	p.category,
    SUM(oi.quantity) as units_sold, 
    ROUND(SUM(oi.revenue),2) as total_revenue,
    ROUND(SUM(oi.profit),2) as total_profit
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'Delivered'
GROUP BY p.category 
ORDER BY total_revenue DESC

SELECT
	p.product_id,
    p.product_name,
	p.category,
    ROUND(SUM(oi.revenue),2) as total_revenue,
    SUM(oi.quantity) as units_sold
FROM products p
JOIN order_items oi 
	ON p.product_id = oi.product_id
JOIN orders o ON 
	oi.order_id = o.order_id
WHERE o.order_status = 'Delivered'
GROUP BY 
	p.product_id,
    p.product_name,
    p.category 
ORDER BY total_revenue DESC
LIMIT 10;

SELECT 
	c.customer_id,
    c.age,
    c.gender,
    c.city,
    COUNT(distinct o.order_id) as totol_orders,
    SUM(oi.revenue) as total_rev
FROM customers c
JOIN orders o 
	ON c.customer_id = o.customer_id
JOIN order_items oi 
	ON oi.order_id = o.order_id
WHERE order_status = 'Delivered'
GROUP BY
	c.customer_id,
    c.age,
    c.gender,
    c.city
ORDER BY total_rev DESC
LIMIT 10;
    
  
WITH customer_spending AS(
	SELECT
		c.customer_id,
		ROUND(SUM(oi.revenue), 2) as total_spending
	FROM customers c
    JOIN orders o 
		ON c.customer_id = o.customer_id
	JOIN order_items oi
		ON o.order_id = oi.order_id
	WHERE o.order_status = 'Delivered'
    GROUP BY c.customer_id
)
SELECT 
	CASE
		WHEN total_spending > 100000 THEN 'High Value'
        WHEN total_spending > 50000 THEN 'Medium Value'
        ELSE 'Low Value'
	END AS customer_segment,
    COUNT(*) as total_customers,
    AVG(total_spending) as avg_spending
FROM customer_spending
GROUP BY customer_segment
ORDER BY avg_spending;

SELECT
    COUNT(*) AS total_sessions,
    SUM(added_to_cart) AS sessions_added_to_cart,
    SUM(checkout_started) AS sessions_started_checkout,
    SUM(purchase_completed) AS sessions_with_purchase,
    ROUND(
        SUM(added_to_cart) / COUNT(*) * 100, 2
    ) AS add_to_cart_rate_pct,
    ROUND(
        SUM(checkout_started) / COUNT(*) * 100, 2
    ) AS checkout_rate_pct,
    ROUND(
        SUM(purchase_completed) / COUNT(*) * 100, 2
    ) AS session_conversion_rate_pct
FROM website_sessions;

SELECT 
	traffic_source,
    COUNT(*) as total_sessions,
    SUM(purchase_completed) as purchases,
    ROUND(SUM(purchase_completed) / COUNT(*) * 100, 2) as conversion_rate
FROM website_sessions
GROUP BY traffic_source
ORDER BY conversion_rate DESC;
    
    
SELECT 
	device,
    COUNT(*) as total_sessions,
    SUM(purchase_completed) as purchases,
    ROUND(SUM(purchase_completed) / COUNT(*) * 100, 2) as conversion_rate,
    ROUND(AVG(session_duration_seconds)) as avg_session_duration_seconds
FROM website_sessions
GROUP BY device
ORDER BY conversion_rate DESC;
    
SELECT
	acquisition_channel,
    COUNT(*) as total_customers,
    ROUND(AVG(age), 1) as avg_age
FROM customers
GROUP BY acquisition_channel
ORDER BY total_customers DESC;
    
SELECT 
    c.city,
    COUNT(distinct c.customer_id) as totol_customers,
    COUNT(distinct o.order_id) as totol_orders,
    ROUND(SUM(oi.revenue),2) as total_rev,
    ROUND(SUM(oi.profit),2) as total_profit
FROM customers c
JOIN orders o 
	ON c.customer_id = o.customer_id
JOIN order_items oi 
	ON oi.order_id = o.order_id
WHERE order_status = 'Delivered'
GROUP BY
    c.city
ORDER BY total_rev DESC
LIMIT 10;
    
SELECT
	COUNT(DISTINCT o.order_id) as total_orders,
    SUM(oi.revenue) as total_rev,
    ROUND(SUM(oi.revenue) / COUNT(DISTINCT o.order_id), 2) as avg_order_value
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered'
    
SELECT 
	order_status,
    COUNT(*) as total_orders,
    ROUND(COUNT(*) * 100 / (SELECT COUNT(*) FROM orders), 2) as percentage
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC

SELECT 
	sales_channel,
    COUNT(*) as total_orders,
    ROUND(COUNT(*) * 100 / (SELECT COUNT(*) FROM orders), 2) as percentage
FROM orders
GROUP BY sales_channel
ORDER BY total_orders DESC

SELECT 
	customer_type,
    COUNT(*) as totol_customers
FROM(
	SELECT
		customer_id,
        CASE
			WHEN COUNT(DISTINCT order_id) > 1
				THEN 'Repeat Customer'
			ELSE 'One Time Customer'
		END AS customer_type
	FROM orders
	WHERE order_status = 'Delivered'
	GROUP BY customer_id
) AS customer_summary
GROUP BY customer_type

SELECT
   CONCAT(ROUND(discount_pct * 100, 0), '%') as discount_percentage,
	COUNT(*) as total_sold_items,
    ROUND(SUM(revenue),2) as total_rev,
    ROUND(SUM(profit), 2) as total_profit
FROM order_items oi
JOIN orders o 
ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered'
GROUP BY discount_pct
ORDER BY discount_pct

SELECT
	p.product_id,
    p.product_name,
    p.category,
    SUM(oi.quantity) as units_sold,
    ROUND(SUM(oi.revenue),2) as total_rev,
    ROUND(SUM(oi.profit),2) as total_profit,
    ROUND(SUM(oi.profit) / NULLIF(SUM(oi.revenue), 0) * 100, 2) as profit_margin_pct
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
JOIN orders o
ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered'
GROUP BY 
	p.product_id,
    p.product_name,
    p.category
ORDER BY total_profit DESC
LIMIT 10
    
SELECT 
	DATE_FORMAT(order_date, '%Y-%m') as order_month,
    COUNT(*) as total_orders,
    SUM(order_status = 'Delivered') as delivered_order,
    ROUND(SUM(order_status = 'Delivered') * 100 / COUNT(*), 2) as delivery_rate_pct
FROM orders
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY order_month








