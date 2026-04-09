-- ============================================================
-- Clinic Management System - Queries (Part B)
-- ============================================================
-- NOTE: Replace the year/month literals with desired values as needed.
--       e.g., SET @year = 2021; SET @month = 11;
-- ============================================================

-- Q1. Find the revenue from each sales channel in a given year

SELECT
    sales_channel,
    SUM(amount) AS total_revenue
FROM clinic_sales
WHERE YEAR(datetime) = 2021          -- change year as needed
GROUP BY sales_channel
ORDER BY total_revenue DESC;

-- ---------------------------------------------------------------

-- Q2. Find top 10 most valuable customers for a given year

SELECT
    cs.uid,
    c.name,
    SUM(cs.amount) AS total_spent
FROM clinic_sales cs
JOIN customer c ON cs.uid = c.uid
WHERE YEAR(cs.datetime) = 2021       -- change year as needed
GROUP BY cs.uid, c.name
ORDER BY total_spent DESC
LIMIT 10;

-- ---------------------------------------------------------------

-- Q3. Month-wise revenue, expense, profit and profitability status for a given year

WITH monthly_revenue AS (
    SELECT
        MONTH(datetime) AS month,
        SUM(amount)      AS revenue
    FROM clinic_sales
    WHERE YEAR(datetime) = 2021      -- change year as needed
    GROUP BY MONTH(datetime)
),
monthly_expense AS (
    SELECT
        MONTH(datetime) AS month,
        SUM(amount)      AS expense
    FROM expenses
    WHERE YEAR(datetime) = 2021      -- change year as needed
    GROUP BY MONTH(datetime)
)
SELECT
    r.month,
    r.revenue,
    COALESCE(e.expense, 0)                AS expense,
    (r.revenue - COALESCE(e.expense, 0))  AS profit,
    CASE
        WHEN (r.revenue - COALESCE(e.expense, 0)) > 0 THEN 'Profitable'
        ELSE 'Not-Profitable'
    END AS status
FROM monthly_revenue r
LEFT JOIN monthly_expense e ON r.month = e.month
ORDER BY r.month;

-- ---------------------------------------------------------------

-- Q4. For each city, find the most profitable clinic for a given month

WITH clinic_profit AS (
    SELECT
        cl.cid,
        cl.clinic_name,
        cl.city,
        COALESCE(SUM(cs.amount), 0)                  AS revenue,
        COALESCE(SUM(ex.expense_total), 0)            AS expense,
        COALESCE(SUM(cs.amount), 0)
            - COALESCE(SUM(ex.expense_total), 0)      AS profit
    FROM clinics cl
    LEFT JOIN clinic_sales cs
           ON cl.cid = cs.cid
          AND YEAR(cs.datetime)  = 2021               -- change year as needed
          AND MONTH(cs.datetime) = 11                 -- change month as needed
    LEFT JOIN (
        SELECT cid, SUM(amount) AS expense_total
        FROM expenses
        WHERE YEAR(datetime) = 2021 AND MONTH(datetime) = 11
        GROUP BY cid
    ) ex ON cl.cid = ex.cid
    GROUP BY cl.cid, cl.clinic_name, cl.city
),
ranked AS (
    SELECT *,
        RANK() OVER (PARTITION BY city ORDER BY profit DESC) AS rnk
    FROM clinic_profit
)
SELECT city, cid, clinic_name, revenue, expense, profit
FROM ranked
WHERE rnk = 1
ORDER BY city;

-- ---------------------------------------------------------------

-- Q5. For each state, find the second least profitable clinic for a given month

WITH clinic_profit AS (
    SELECT
        cl.cid,
        cl.clinic_name,
        cl.city,
        cl.state,
        COALESCE(SUM(cs.amount), 0)                  AS revenue,
        COALESCE(SUM(ex.expense_total), 0)            AS expense,
        COALESCE(SUM(cs.amount), 0)
            - COALESCE(SUM(ex.expense_total), 0)      AS profit
    FROM clinics cl
    LEFT JOIN clinic_sales cs
           ON cl.cid = cs.cid
          AND YEAR(cs.datetime)  = 2021               -- change year as needed
          AND MONTH(cs.datetime) = 11                 -- change month as needed
    LEFT JOIN (
        SELECT cid, SUM(amount) AS expense_total
        FROM expenses
        WHERE YEAR(datetime) = 2021 AND MONTH(datetime) = 11
        GROUP BY cid
    ) ex ON cl.cid = ex.cid
    GROUP BY cl.cid, cl.clinic_name, cl.city, cl.state
),
ranked AS (
    SELECT *,
        DENSE_RANK() OVER (PARTITION BY state ORDER BY profit ASC) AS rnk
    FROM clinic_profit
)
SELECT state, cid, clinic_name, city, revenue, expense, profit
FROM ranked
WHERE rnk = 2
ORDER BY state;
