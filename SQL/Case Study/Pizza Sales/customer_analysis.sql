-- Product Analysis Questions

-- What type of pizza has the highest price?
SELECT pt.name AS pizza_type,
	   p.pizza_id,
       p.price
FROM PizzaSales..pizzas p
LEFT JOIN PizzaSales..pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
ORDER BY p.price DESC

-- What type of pizza has the hihgest sales?
SELECT pt.name AS pizza_type,
	   p.pizza_id,
	   SUM(od.quantity) AS total_sales
FROM PizzaSales..pizzas p
LEFT JOIN PizzaSales..order_details od ON p.pizza_id = od.pizza_id
LEFT JOIN PizzaSales..pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name, p.pizza_id
ORDER BY total_sales DESC

-- Is there a correlation between the price and the number of pizzas sold?
SELECT pt.name AS pizza_type, 
       SUM(od.quantity) AS total_sales, 
       AVG(p.price) AS average_price
FROM PizzaSales..order_details od
LEFT JOIN PizzaSales..pizzas p ON od.pizza_id = p.pizza_id
LEFT JOIN PizzaSales..pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY total_sales DESC

-- 
