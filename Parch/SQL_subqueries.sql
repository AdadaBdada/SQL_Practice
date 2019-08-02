### Subquery

SELECT channel,
       AVG(events) avegrage_events
FROM(SELECT DATE_TRUNC('day', occurred_at) AS day,
            channel, COUNT(*) AS events
     FROM web_events
     GROUP BY 1,2) sub
GROUP BY 1
ORDER BY 2 DESC;

/*
1. The average amount of standard paper sold on the first month that any order
 was placed in the orders table (in terms of quantity).

2. The average amount of gloss paper sold on the first month that any order
 was placed in the orders table (in terms of quantity).

3. The average amount of poster paper sold on the first month that any order
was placed in the orders table (in terms of quantity).

4. The total amount spent on all orders on the first month that any order
was placed in the orders table (in terms of usd).

*/

SELECT AVG(standard_qty) avg_std, AVG(gloss_qty) avg_gls, AVG(poster_qty) avg_pst,
       SUM(total_amt_usd) total_usd
FROM orders
WHERE DATE_TRUNC('month',occurred_at) =
     (SELECT DATE_TRUNC('month', MIN(occurred_at)) FROM orders);

SELECT AVG(standard_qty) avg_std, AVG(gloss_qty) avg_gls, AVG(poster_qty) avg_pst
FROM orders
WHERE DATE_TRUNC('month', occurred_at) =
    (SELECT DATE_TRUNC('month', MIN(occurred_at)) FROM orders);

SELECT SUM(total_amt_usd)
FROM orders
WHERE DATE_TRUNC('month', occurred_at) =
     (SELECT DATE_TRUNC('month', MIN(occurred_at)) FROM orders);

/*
1. Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.
*/

SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
FROM sales_reps s
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
JOIN region r
ON r.id = s.region_id
GROUP BY 1,2
ORDER BY 3 DESC;
