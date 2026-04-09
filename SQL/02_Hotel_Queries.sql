-- ============================================================
-- Hotel Management System - Queries (Part A)
-- ============================================================

-- Q1. For every user in the system, get the user_id and last booked room_no
-- Logic: Find the booking with MAX(booking_date) per user, then pull its room_no.

SELECT u.user_id, b.room_no AS last_booked_room
FROM users u
JOIN bookings b
  ON u.user_id = b.user_id
WHERE b.booking_date = (
    SELECT MAX(b2.booking_date)
    FROM bookings b2
    WHERE b2.user_id = u.user_id
);

-- ---------------------------------------------------------------

-- Q2. Get booking_id and total billing amount of every booking created in November 2021
-- Logic: Filter bookings by Nov 2021, join with booking_commercials and items,
--        then compute SUM(item_quantity * item_rate) per booking.

SELECT
    b.booking_id,
    SUM(bc.item_quantity * i.item_rate) AS total_billing_amount
FROM bookings b
JOIN booking_commercials bc ON b.booking_id = bc.booking_id
JOIN items i                ON bc.item_id    = i.item_id
WHERE YEAR(b.booking_date) = 2021
  AND MONTH(b.booking_date) = 11
GROUP BY b.booking_id;

-- ---------------------------------------------------------------

-- Q3. Get bill_id and bill amount of all bills raised in October 2021 with amount > 1000
-- Logic: Group booking_commercials by bill_id, filter by Oct 2021 bill_date,
--        use HAVING to keep only those with total > 1000.

SELECT
    bc.bill_id,
    SUM(bc.item_quantity * i.item_rate) AS bill_amount
FROM booking_commercials bc
JOIN items i ON bc.item_id = i.item_id
WHERE YEAR(bc.bill_date) = 2021
  AND MONTH(bc.bill_date) = 10
GROUP BY bc.bill_id
HAVING SUM(bc.item_quantity * i.item_rate) > 1000;

-- ---------------------------------------------------------------

-- Q4. Determine the most ordered and least ordered item of each month of year 2021
-- Logic: Sum item_quantity per (month, item), then use RANK() window function
--        to rank ASC (for least) and DESC (for most) within each month.

WITH monthly_item_orders AS (
    SELECT
        MONTH(bc.bill_date)  AS order_month,
        i.item_name,
        SUM(bc.item_quantity) AS total_ordered
    FROM booking_commercials bc
    JOIN items i ON bc.item_id = i.item_id
    WHERE YEAR(bc.bill_date) = 2021
    GROUP BY MONTH(bc.bill_date), i.item_name
),
ranked AS (
    SELECT
        order_month,
        item_name,
        total_ordered,
        RANK() OVER (PARTITION BY order_month ORDER BY total_ordered DESC) AS rank_most,
        RANK() OVER (PARTITION BY order_month ORDER BY total_ordered ASC)  AS rank_least
    FROM monthly_item_orders
)
SELECT
    order_month,
    MAX(CASE WHEN rank_most  = 1 THEN item_name END) AS most_ordered_item,
    MAX(CASE WHEN rank_least = 1 THEN item_name END) AS least_ordered_item
FROM ranked
GROUP BY order_month
ORDER BY order_month;

-- ---------------------------------------------------------------

-- Q5. Find customers with the second highest bill value of each month of year 2021
-- Logic: Calculate total bill value per (month, user), rank DESC within each month,
--        then pick those ranked 2nd.

WITH user_monthly_bill AS (
    SELECT
        MONTH(bc.bill_date)               AS bill_month,
        b.user_id,
        u.name,
        SUM(bc.item_quantity * i.item_rate) AS total_bill_value
    FROM booking_commercials bc
    JOIN bookings b ON bc.booking_id = b.booking_id
    JOIN users u    ON b.user_id     = u.user_id
    JOIN items i    ON bc.item_id    = i.item_id
    WHERE YEAR(bc.bill_date) = 2021
    GROUP BY MONTH(bc.bill_date), b.user_id, u.name
),
ranked_bills AS (
    SELECT
        bill_month,
        user_id,
        name,
        total_bill_value,
        DENSE_RANK() OVER (PARTITION BY bill_month ORDER BY total_bill_value DESC) AS bill_rank
    FROM user_monthly_bill
)
SELECT bill_month, user_id, name, total_bill_value
FROM ranked_bills
WHERE bill_rank = 2
ORDER BY bill_month;
