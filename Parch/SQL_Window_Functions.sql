```
OVER: Creating a Running Total Using Window Functions
PARTITIONBY: Creating a Partitioned Running Total Using Window Functions
ORDER BY
ROW_NUMBER: Ranking Total Paper Ordered by Account
LAG: pull from previous rows
LEAD: Pull from the following rows


 - Aliases for Multiple Window Functions
 - Comparing a Row to Previous Row

```

```
Create a running total of standard_amt_usd (in the orders table)
over order time with no date truncation.
Your final table should have two columns:
 one with the amount being added for each new row,
 and a second with the running total.
```
SELECT standard_amt_usd,
       SUM(standard_amt_usd) OVER (ORDER BY occurred_at) AS running_total
FROM orders

```
Creating a Partitioned Running Total Using Window Functions

Now, modify your query from the previous quiz to include partitions.
Still create a running total of standard_amt_usd (in the orders table)
over order time, but this time, date truncate occurred_at by year
and partition by that same year-truncated occurred_at variable.
Your final table should have three columns:
    1.One with the amount being added for each row,
    2.one for the truncated date,
    3.and a final column with the running total within each year.
```

SELECT standard_amt_usd,
       DATE_TRUNC('year', occurred_at) as year,
       SUM(standard_amt_usd) OVER (PARTITION BY DATE_TRUNC('year', occurred_at) ORDER BY occurred_at) AS running_total
FROM orders

```
Select the id, account_id, and total variable from the orders table,
then create a column called total_rank that ranks this total amount of paper
ordered (from highest to lowest) for each account using a partition.
Your final table should have these four columns.
```
SELECT account_id,
       total,
       RANK() OVER (PARTITION BY account_id ORDER BY total DESC) AS total_rank
FROM orders


```
Aggregates in Window Functions with and without ORDER BY


The easiest way to think about this -
leaving the ORDER BY out is equivalent to "ordering" in a way that all rows in the partition
are "equal" to each other. Indeed, you can get the same effect by explicitly adding the
ORDER BY clause like this: ORDER BY 0 (or "order by" any constant expression),
or even, more emphatically, ORDER BY NULL.
```

SELECT account_id,
       standard_qty,
       DATE_TRUNC('month', occurred_at) AS month,
       DENSE_RANK() OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS dense_rank,
       SUM(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS sum_std_qty,
       COUNT(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS count_std_qty,
       AVG(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS avg_std_qty,
       MIN(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS min_std_qty,
       MAX(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS max_std_qty
FROM orders


SELECT account_id,
       standard_qty,
       DATE_TRUNC('month', occurred_at) AS month,
       DENSE_RANK() OVER (PARTITION BY account_id) AS dense_rank,
       SUM(standard_qty) OVER (PARTITION BY account_id) AS sum_std_qty,
       COUNT(standard_qty) OVER (PARTITION BY account_id) AS count_std_qty,
       AVG(standard_qty) OVER (PARTITION BY account_id) AS avg_std_qty,
       MIN(standard_qty) OVER (PARTITION BY account_id) AS min_std_qty,
       MAX(standard_qty) OVER (PARTITION BY account_id) AS max_std_qty
FROM orders


```
Aliases for Multiple Window Functions
```

SELECT account_id,
       DATE_TRUNC('year',occurred_at) AS year,
       DENSE_RANK() OVER account_year_window AS dense_rank,
       total_amt_usd,
       SUM(total_amt_usd) OVER account_year_window AS sum_total_amt_usd,
       COUNT(total_amt_usd) OVER account_year_window AS count_total_amt_usd,
       AVG(total_amt_usd) OVER account_year_window AS avg_total_amt_usd,
       MIN(total_amt_usd) OVER account_year_window AS min_total_amt_usd,
       MAX(total_amt_usd) OVER account_year_window AS max_total_amt_usd
FROM orders
WINDOW account_year_window AS (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at))
