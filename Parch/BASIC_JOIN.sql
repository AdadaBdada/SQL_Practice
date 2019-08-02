### LIMIT

/*
Try it yourself below by writing a query that limits the response to
  only the first 15 rows and includes the occurred_at, account_id,
  and channel fields in the web_events table.
*/
SELECT occurred_at, account_id, channel
FROM web_events
LIMIT 15;

### ORDER BY

/*
1. Write a query to return the 10 earliest orders in the orders table.
   Include the id, occurred_at, and total_amt_usd.
*/

SELECT id, occurred_at, total_amt_usd
FROM orders
ORDER BY occurred_at
LIMIT 10;

/*
2. Write a query to return the top 5 orders in terms of largest total_amt_usd.
   Include the id, account_id, and total_amt_usd.
*/

SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC
LIMIT 5;

/*
3. Write a query to return the bottom 20 orders in terms of least total.
Include the id, account_id, and total.
*/
SELECT id, account_id, total
FROM orders
ORDER BY total
LIMIT 20;

### ORDER BY PART 2

/*
1. Write a query that returns the top 5 rows from orders ordered according to
newest to oldest, but with the largest total_amt_usd for each date listed first
for each date.
*/

SELECT *
FROM orders
ORDER BY occurred_at DESC, total_amt_usd DESC
LIMIT 5;


/*
2.Write a query that returns the top 10 rows from orders ordered according to
oldest to newest, but with the smallest total_amt_usd for each date listed
first for each date.
*/


### WHERE Numerical

/*
1. Pull the first 5 rows and all columns from the orders table that
 have a dollar amount of gloss_amt_usd greater than or equal to 1000.
*/

SELECT *
FROM orders
WHERE gloss_amt_usd >= 1000
LIMIT 5;

/*
2.Pull the first 10 rows and all columns from the orders table that
have a total_amt_usd less than 500.
*/

SELECT *
FROM orders
WHERE total_amt_usd < 500
LIMIT 10;

### WHERE Non-Numerical

/*
1.Filter the accounts table to include the company name, website,and the primary
 point of contact (primary_poc) for Exxon Mobil in the accounts table.
*/

SELECT name, website, primary_poc
FROM accounts
WHERE name = 'Exxon Mobil';

### Arithmetic Operators

### Logical Operators
### LIKE

/*
All the companies whose names start with 'C'.
*/
SELECT name
FROM accounts
WHERE name LIKE 'C%';
/*
All companies whose names contain the string 'one' somewhere in the name.
*/
SELECT name
FROM accounts
WHERE name LIKE '%one%';
/*
All companies whose names end with 's'.
*/

SELECT name
FROM accounts
WHERE name LIKE '%s';

### IN
/*
1.Use the accounts table to find the account name, primary_poc,
and sales_rep_id for Walmart, Target, and Nordstrom.
*/
SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name IN ('Walmart', 'Target', 'Nordstrom');

/*
2. Use the web_events table to find all information regarding individuals
who were contacted via the channel of organic or adwords.
*/
SELECT *
FROM web_events
WHERE channel IN ('organic','adwords');

### NOT IN
/*
We can pull all of the rows that were excluded from the queries in the
previous two concepts with our new operator.
*/

/*
1.Use the accounts table to find the account name, primary poc, and
sales rep id for all stores except Walmart, Target, and Nordstrom.
*/
SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name NOT IN ('Walmart', 'Target', 'Nordstrom');
/*
2.Use the web_events table to find all information regarding individuals who
were contacted via any method except using organic or adwords methods.
*/
SELECT *
FROM web_events
WHERE channel NOT IN ('organic','adwords');

### NOT LIKE
/*
Use the accounts table to find:*/

/*
1.All the companies whose names do not start with 'C'.
*/
SELECT name
FROM accounts
WHERE name NOT LIKE 'C%';
/*
2.All companies whose names do not contain the string 'one' somewhere in the name.
*/
SELECT name
FROM accounts
WHERE name NOT LIKE '%one%';
/*
3.All companies whose names do not end with 's'.
*/
SELECT name
FROM accounts
WHERE name NOT LIKE '%s';

### AND BETWEEN

/*
 1.Write a query that returns all the orders where the standard_qty is over 1000,
the poster_qty is 0, and the gloss_qty is 0.
 */
SELECT *
FROM orders
WHERE standard_qty > 1000 AND poster_qty = 0 AND gloss_qty = 0;

/*
2.Using the accounts table find all the companies whose names do not start with
'C' and end with 's'.
*/
SELECT name
FROM accounts
WHERE name NOT LIKE '%C' AND name LIKE '%s';
/*
3.Use the web_events table to find all information regarding individuals
who were contacted via organic or adwords and started their account at any
point in 2016 sorted from newest to oldest.
*/
SELECT *
FROM web_events
WHERE channel IN ('organic','adwords') AND occurred_at BETWEEN '2016-01-01' AND '2017-01-01'
ORDER BY occurred_at DESC;
/*
You will notice that using BETWEEN is tricky for dates!
 While BETWEEN is generally inclusive of endpoints, it assumes the time
 is at 00:00:00 (i.e. midnight) for dates. This is the reason why we set the
 right-side endpoint of the period at '2017-01-01'.
 */

### OR
/*
1. Find list of orders ids where either gloss_qty or poster_qty is greater
 than 4000. Only include the id field in the resulting table.
*/
SELECT id
FROM orders
WHERE gloss_qty > 4000 OR poster_qty > 4000;
/*
2. Write a query that returns a list of orders where the standard_qty is zero
and either the gloss_qty or poster_qty is over 1000.
*/
SELECT *
FROM orders
WHERE standard_qty = 0 AND (gloss_qty > 1000 OR poster_qty > 1000);

/*
3.Find all the company names that start with a 'C' or 'W',
and the primary contact contains 'ana' or 'Ana', but it doesn't contain 'eana'.
*/
SELECT *
FROM accounts
WHERE (name LIKE 'C%' OR name LIKE 'W%')
            AND (primary_poc LIKE '%ana%' OR primary_poc LIKE '%Ana%')
            AND primary_poc NOT LIKE '%eana%';


### JOIN

/*
1.Try pulling all the data from the accounts table, and all the
data from the orders table.
*/
SELECT accounts.*, orders.*
FROM accounts
JOIN orders
ON accounts.id = orders.account_id;
/*
2.Try pulling standard_qty, gloss_qty, and poster_qty from the orders table,
and the website and the primary_poc from the accounts table.
*/
SELECT orders.standard_qty, orders.gloss_qty,
orders.poster_qty, accounts.website, accounts.primary_poc
FROM accounts
JOIN orders
ON accounts.id = orders.account_id;

/*
1.Provide a table for all web_events associated with account name of Walmart.
There should be three columns. Be sure to include the primary_poc,
 time of the event, and the channel for each event. Additionally,
 you might choose to add a fourth column to assure only Walmart events were chosen.
*/
SELECT a.primary_poc, w.occurred_at, w.channel, a.name
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
WHERE a.name = 'Walmart';


/*
2. Provide a table that provides the region for each sales_rep along with their
 associated accounts. Your final table should include three columns:
 the region name, the sales rep name, and the account name.
 Sort the accounts alphabetically (A-Z) according to account name.
*/
SELECT r.name AS region_name, s.name AS sales_rep_name, a.name AS account_name

FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON a.sales_rep_id = s.id
ORDER BY a.name;


/*
3. Provide the name for each region for every order, as well as the account name
 and the unit price they paid (total_amt_usd/total) for the order.
 Your final table should have 3 columns: region name, account name, and unit price.
 A few accounts have 0 for total, so I divided by (total + 0.01) to assure not dividing by zero.
*/

SELECT r.name region, a.name account,
       o.total_amt_usd/(o.total + 0.01) unit_price
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id;

### JOINs and Filtering

/*
1. Provide a table that provides the region for each sales_rep along with their
 associated accounts. This time only for the Midwest region. Your final table
  should include three columns: the region name, the sales rep name, and the
  account name. Sort the accounts alphabetically (A-Z) according to account name.
*/

SELECT r.name region, s.name rep, a.name account
FROM sales_reps s
JOIN region r
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
WHERE r.name = 'Midwest'
ORDER BY a.name;

/*
2.Provide a table that provides the region for each sales_rep along with their
associated accounts. This time only for accounts where the sales rep has a first
 name starting with S and in the Midwest region. Your final table should include
  three columns: the region name, the sales rep name, and the account name.
  Sort the accounts alphabetically (A-Z) according to account name.
*/

SELECT r.name region, s.name rep, a.name account
FROM sales_reps s
JOIN region r
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
WHERE r.name = 'Midwest' AND s.name LIKE 'S%'
ORDER BY a.name;

/*
3.Provide a table that provides the region for each sales_rep along with their
associated accounts. This time only for accounts where the sales rep has a last name
starting with K and in the Midwest region. Your final table should include three columns
: the region name, the sales rep name, and the account name.
Sort the accounts alphabetically (A-Z) according to account name.
*/
SELECT r.name region, s.name rep, a.name account
FROM sales_reps s
JOIN region r
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
WHERE r.name = 'Midwest' AND s.name LIKE 'K%'
ORDER BY a.name;


/*
4.Provide the name for each region for every order, as well as the account name and
 the unit price they paid (total_amt_usd/total) for the order.
 However, you should only provide the results if the standard order
 quantity exceeds 100. Your final table should have 3 columns: region name,
 account name, and unit price. In order to avoid a division by zero error,
  adding .01 to the denominator here is helpful total_amt_usd/(total+0.01).
*/

SELECT r.name region, a.name account, o.total_amt_usd/(o.total+0.01) unit_price
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id
WHERE standard_qty > 100;

/*
5.Provide the name for each region for every order,
as well as the account name and the unit price they paid (total_amt_usd/total) for the order.
 However, you should only provide the results if the standard order quantity exceeds 100 and
 the poster order quantity exceeds 50. Your final table should have 3 columns: region name,
  account name, and unit price. Sort for the smallest unit price first. In order to avoid
  a division by zero error, adding .01 to the denominator here is helpful (total_amt_usd/(total+0.01).
 */

SELECT r.name region, a.name account, o.total_amt_usd/(o.total+0.01) unit_price
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON a.id = o.account_id
WHERE standard_qty > 100 AND poster_qty > 50
ORDER BY unit_price;

/*
6. Provide the name for each region for every order, as well as the account name
 and the unit price they paid (total_amt_usd/total) for the order.
 However, you should only provide the results if the standard order quantity exceeds 100
 and the poster order quantity exceeds 50. Your final table should have 3 columns:
 region name, account name, and unit price. Sort for the largest unit price first.
  In order to avoid a division by zero error, adding .01 to the denominator
  here is helpful (total_amt_usd/(total+0.01).
*/
SELECT r.name region, a.name account, o.total_amt_usd/(o.total+0.01) unit_price
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON a.id = o.account_id
WHERE standard_qty > 100 AND poster_qty > 50
ORDER BY unit_price DESC;

/*
7. What are the different channels used by account id 1001? Your final table
should have only 2 columns: account name and the different channels. You can try
 SELECT DISTINCT to narrow down the results to only the unique values.
*/

SELECT DISTINCT a.name, w.channel # 注意 DISTINCT
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
WHERE a.id = '1001'

/*
8. Find all the orders that occurred in 2015. Your final table should have 4 columns:
occurred_at, account name, order total, and order total_amt_usd.
*/
SELECT o.occurred_at, a.name, o.total, o.total_amt_usd
FROM accounts a
JOIN orders o
ON o.account_id = a.id
WHERE o.occurred_at BETWEEN '01-01-2015' AND '01-01-2016'
ORDER BY o.occurred_at DESC;
