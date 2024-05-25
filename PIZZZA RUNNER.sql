--1. How many pizzas were ordered?
SELECT *
FROM [pizza_runner].[customer_orders];

SELECT COUNT(order_id)
FROM customer_orders;
--(14)

--2.How many unique customer orders were made?

SELECT COUNT(DISTINCT order_id) AS unique_orders
FROM customer_orders;
--(10)
--3How many successful orders were delivered by each runner?
SELECT runner_id ,count (DISTINCT R.order_id) as delivered_order
FROM customer_orders AS C
--from runner_orders as R
INNER JOIN runner_orders as R
ON C.order_id =R.order_id
WHERE pickup_time <>'null'
GROUP BY runner_id ;

SELECT runner_id ,
count ( R.order_id) as delivered_order
FROM runner_orders AS R
WHERE pickup_time <>'null'
GROUP BY runner_id ;

--4.How many of each type of pizza was delivered?
--SELECT PN.pizza_name , 
--count ( PN.pizza_id) as delivered_order
--FROM runner_orders AS RO
--INNER JOIN customer_orders AS CO ON RO.order_id =CO.order_id
--INNER JOIN pizza_names AS PN ON CO.pizza_id =PN.pizza_id
--WHERE pickup_time <> 'null'
--GROUP BY PN.pizza_name ;

SELECT 
  pizza_name, 
  COUNT(co.order_id) as delivered_pizzas 
FROM 
  customer_orders as co 
  INNER JOIN pizza_names as pn on co.pizza_id = pn.pizza_id 
  INNER JOIN runner_orders as ro on ro.order_id = co.order_id 
WHERE 
  pickup_time is not null
GROUP BY 
  pizza_name;

--5. How many Vegetarian and Meatlovers were ordered by each customer?
SELECT 
  customer_id, 
  pizza_name, 
  COUNT(co.order_id) as ordered_pizzas 
FROM 
  customer_orders as co
  INNER JOIN pizza_names as pn on co.pizza_id = pn.pizza_id 
GROUP BY 
  pizza_name, 
  customer_id;


--6.What was the maximum number of pizzas delivered in a single order?
 SELECT 
  ro.order_id, 
  COUNT(co.order_id) as delivered_pizzas 
FROM 
  customer_orders as co 
  INNER JOIN pizza_names as pn on co.pizza_id = pn.pizza_id 
  INNER JOIN runner_orders as ro on ro.order_id = co.order_id 
WHERE 
  pickup_time<>'null'
GROUP BY 
  ro.order_id 
ORDER BY 
  COUNT(co.order_id) DESC 
LIMIT 1;



--7.For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
SELECT 
  customer_id, 
  SUM(CASE 
    WHEN 
        (
          (exclusions IS NOT NULL AND exclusions<>'null' AND LENGTH(exclusions)>0) 
        AND (extras IS NOT NULL AND extras<>'null' AND LENGTH(extras)>0)
        )=TRUE
    THEN 1 
    ELSE 0
  END) as changes, 
  SUM(CASE 
    WHEN 
        (
          (exclusions IS NOT NULL AND exclusions<>'null' AND LENGTH(exclusions)>0) 
        AND (extras IS NOT NULL AND extras<>'null' AND LENGTH(extras)>0)
        )=TRUE
    THEN 0 
    ELSE 1
  END) as no_changes 
FROM 
  customer_orders as co 
  INNER JOIN runner_orders as ro on ro.order_id = co.order_id 
WHERE 
  pickup_time<>'null'
GROUP BY 
  customer_id;
  


--How many pizzas were delivered that had both exclusions and extras?
SELECT 
  COUNT(pizza_id) as pizzas_delivered_with_exclusions_and_extras 
FROM 
  customer_orders as co 
  INNER JOIN runner_orders as ro on ro.order_id = co.order_id 
WHERE 
  pickup_time<>'null'
  AND (exclusions IS NOT NULL AND exclusions<>'null' AND LENGTH(exclusions)>0) 
  AND (extras IS NOT NULL AND extras<>'null' AND LENGTH(extras)>0); 



--What was the total volume of pizzas ordered for each hour of the day?
SELECT 
  COUNT(pizza_id) as pizzas_delivered_with_exclusions_and_extras 
FROM 
  customer_orders as co 
  INNER JOIN runner_orders as ro on ro.order_id = co.order_id 
WHERE 
  pickup_time<>'null'
  AND (exclusions IS NOT NULL AND exclusions<>'null' AND LENGTH(exclusions)>0) 
  AND (extras IS NOT NULL AND extras<>'null' AND LENGTH(extras)>0); 
  


--What was the volume of orders for each day of the week?

SELECT 
  DATE_PART('hour', order_time) as hour, 
  COUNT(*) as ordered_pizzas 
FROM 
  customer_orders 
GROUP BY 
  DATE_PART('hour', order_time); 
  
-- 10. What was the volume of orders for each day of the week?
SELECT 
  DAYNAME(order_time) as day, 
  COUNT(*) as ordered_pizzas 
FROM 
  customer_orders 
GROUP BY 
  DAYNAME(order_time);




