# PlatinumRx Data Analyst Assignment
**Submitted by:** Mandara Vyshnavi

---

## Project Structure

```
Data_Analyst_Assignment/
│
├── SQL/
│   ├── 01_Hotel_Schema_Setup.sql    # CREATE TABLE + INSERT sample data (Hotel)
│   ├── 02_Hotel_Queries.sql         # Answers to Part A Q1–Q5
│   ├── 03_Clinic_Schema_Setup.sql   # CREATE TABLE + INSERT sample data (Clinic)
│   └── 04_Clinic_Queries.sql        # Answers to Part B Q1–Q5
│
├── Spreadsheets/
│   └── Ticket_Analysis.xlsx         # 4-sheet workbook (ticket, feedbacks, Analysis, Instructions)
│
├── Python/
│   ├── 01_Time_Converter.py         # Minutes → human-readable conversion
│   └── 02_Remove_Duplicates.py      # Remove duplicate characters from a string
│
└── README.md
```

---

## Phase 1 – SQL

### Hotel System (Part A)

| Q# | Approach |
|----|----------|
| Q1 – Last booked room per user | Correlated subquery with `MAX(booking_date)` joined back to bookings |
| Q2 – Total billing for Nov 2021 | 3-table join (`bookings → booking_commercials → items`), filter by month/year, `SUM(qty × rate)` |
| Q3 – Bills > 1000 in Oct 2021 | Group by `bill_id`, filter `bill_date` to Oct 2021, `HAVING SUM > 1000` |
| Q4 – Most/least ordered item per month | CTE with `SUM(item_quantity)` grouped by month+item, then `RANK()` window function both ASC and DESC |
| Q5 – 2nd highest bill value per month | CTE aggregating bill value per user per month, `DENSE_RANK() DESC`, filter `rank = 2` |

### Clinic System (Part B)

| Q# | Approach |
|----|----------|
| Q1 – Revenue by sales channel | `GROUP BY sales_channel`, `SUM(amount)` |
| Q2 – Top 10 customers | Join `clinic_sales` with `customer`, `GROUP BY uid`, `ORDER BY SUM DESC LIMIT 10` |
| Q3 – Month-wise P&L | Two CTEs (monthly revenue + monthly expense), LEFT JOIN, compute `profit = revenue − expense`, CASE for status |
| Q4 – Most profitable clinic per city per month | CTE for clinic-level profit, `RANK() OVER (PARTITION BY city ORDER BY profit DESC)`, filter rank 1 |
| Q5 – 2nd least profitable clinic per state per month | Same pattern but `ORDER BY profit ASC`, filter `DENSE_RANK = 2` |

> **Note:** Year/month literals are clearly marked in each query with a comment — replace them as needed.

---

## Phase 2 – Spreadsheets (`Ticket_Analysis.xlsx`)

The workbook has **4 sheets**:

| Sheet | Purpose |
|-------|---------|
| `ticket` | Raw ticket data (7 sample rows) |
| `feedbacks` | Feedback data; column D (`ticket_created_at`) auto-populated by formula |
| `Analysis` | Helper columns (`Same_Day?`, `Same_Hour?`) + outlet-wise COUNTIFS summary |
| `Instructions` | Step-by-step formula guide for both questions |

### Q1 – Populate `ticket_created_at`
Formula in `feedbacks!D2`:
```
=IFERROR(INDEX(ticket!B:B, MATCH(A2, ticket!E:E, 0)), "")
```
`MATCH` locates the `cms_id` in the ticket sheet's `cms_id` column (E), and `INDEX` returns the `created_at` value from column B.

### Q2a – Same-day tickets per outlet
Helper column `Same_Day?`:
```
=IF(INT(DATEVALUE(MID(B2,1,10))) = INT(DATEVALUE(MID(C2,1,10))), "Yes", "No")
```
Then: `=COUNTIFS($D$5:$D$11, outlet_id, $F$5:$F$11, "Yes")`

### Q2b – Same-hour tickets per outlet
Helper column `Same_Hour?` checks same day AND same 2-digit hour prefix:
```
=IF(AND(F2="Yes", MID(B2,12,2) = MID(C2,12,2)), "Yes", "No")
```
Then: `=COUNTIFS($D$5:$D$11, outlet_id, $G$5:$G$11, "Yes")`

---

## Phase 3 – Python

### `01_Time_Converter.py`
Converts integer minutes to a human-readable string using integer division (`//`) for hours and modulo (`%`) for remaining minutes.

**Sample output:**
```
130 -> "2 hrs 10 minutes"
110 -> "1 hrs 50 minutes"
 60 -> "1 hrs"
 45 -> "45 minutes"
```

### `02_Remove_Duplicates.py`
Iterates over each character in the input string using a `for` loop. Appends the character to a `result` string only if it hasn't been seen yet.

**Sample output:**
```
"programming"  ->  "progamin"
"hello world"  ->  "helo wrd"
"mississippi"  ->  "misp"
```

---

## Assumptions

- SQL dialect: **MySQL** (uses `YEAR()`, `MONTH()`, `LIMIT`). Minor adjustments needed for PostgreSQL (`EXTRACT`, `FETCH FIRST`).
- Sample data was created to cover all query scenarios (multi-month, multi-user, varying bill totals).
- Spreadsheet timestamps are stored as text strings `"YYYY-MM-DD HH:MM:SS"` — formulas use `MID()` for date/hour extraction.
