create database bank;

use bank;

create table if not exists bank(
Account_No bigint,
Dates date,
Transaction_Details text,
Chq_no int,
Value_date date,
withdrawal_amt bigint,
Deposit_amt bigint,
balance_amt bigint
);

desc bank;

select @@secure_file_priv;

SHOW VARIABLES LIKE 'secure_file_priv';

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/bank.csv'
INTO TABLE bank
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

SELECT * FROM bank;

# QUESTION & ANSWER 

# 1.	Show all transactions from the table.
select * from bank;

# 2.	Count total number of transactions.
SELECT 
    COUNT(Account_No)
FROM
    BANK;

# 3.	Find total number of unique bank accounts.
SELECT 
    COUNT(DISTINCT Account_No)
FROM
    bank;

# 4.	Show all transactions for a specific account number.
SELECT 
    *
FROM
    BANK
WHERE
    Account_No = 409000000000;

# 5.	Find all transactions where withdrawal amount is greater than 0.
SELECT 
    *
FROM
    BANK
WHERE
    withdrawal_amt > 0;

# 6.	Find all transactions where deposit amount is greater than 0.
SELECT 
    *
FROM
    BANK
WHERE
    Deposit_amt > 0;

# 7.	List all transactions ordered by date (latest first).
SELECT 
    *
FROM
    bank
ORDER BY Dates DESC;

# 8.	Find transactions with cheque numbers present.
SELECT 
    *
FROM
    bank
WHERE
    chq_no = 1;
    
SELECT DISTINCT
    chq_no
FROM
    bank;

# 9.	Find transactions where cheque number is NULL.
SELECT 
    *
FROM
    bank
WHERE
    chq_no = 0;

# 10.	Show transactions made on a specific date.
SELECT 
    *
FROM
    bank
WHERE
    dates = '2017-08-01';

# 11.	Calculate total deposited amount for each account.
SELECT 
    Account_no, SUM(Deposit_amt) AS total_deposited
FROM
    bank
GROUP BY Account_No;

# 12.	Calculate total withdrawn amount for each account.
SELECT 
    Account_no, SUM(withdrawal_amt) AS total_withdrawn
FROM
    bank
GROUP BY Account_No;

# 13.	Find net transaction amount per account (Deposit − Withdrawal).
SELECT 
    Account_no,
    SUM(Deposit_amt) - SUM(withdrawal_amt) AS transaction_amount
FROM
    bank
GROUP BY Account_no;

# 14.	Find the maximum balance for each account.
SELECT 
    Account_no, MAX(balance_amt) AS maximum_balance
FROM
    bank
GROUP BY Account_No;

# 15.	Find the minimum balance for each account.
SELECT 
    Account_no, MIN(balance_amt) AS maximum_balance
FROM
    bank
GROUP BY Account_No;

# 16.	Calculate the average balance per account.
SELECT 
    Account_No, AVG(balance_amt) AS avg_balance
FROM
    bank
GROUP BY Account_No;

# 17.	Count number of transactions per account.
SELECT 
    Account_No, COUNT(*) AS transaction_count
FROM
    bank
GROUP BY Account_No;

# 18.	Find accounts with more than 20 transactions.
SELECT 
    Account_No, COUNT(*) AS transaction_count
FROM
    bank
GROUP BY Account_No;

SELECT 
    Account_No, COUNT(*) AS transaction_count
FROM
    bank
GROUP BY Account_No
HAVING COUNT(*) = 20;

# 19.	Find transactions where withdrawal amount is greater than deposit amount.
SELECT 
    *
FROM
    bank
WHERE
    withdrawal_amt > Deposit_amt;

# 20.	Find transactions where deposit amount is greater than withdrawal amount.
SELECT 
    *
FROM
    bank
WHERE
    withdrawal_amt < Deposit_amt;

# 21.	Calculate total deposits per month.
SELECT 
    DATE_FORMAT(Dates, '%Y-%m') AS month,
    SUM(Deposit_amt) AS total_deposits
FROM
    bank
GROUP BY DATE_FORMAT(Dates, '%Y-%m')
ORDER BY month;

# 22.	Calculate total withdrawals per month.
SELECT 
    DATE_FORMAT(Dates, '%Y-%m') AS month,
    SUM(withdrawal_amt) AS Withdrawals
FROM
    bank
GROUP BY DATE_FORMAT(Dates, '%Y-%m')
ORDER BY month;

# 23.	Identify the month with the highest deposits.
SELECT 
    month, total_deposits AS Highest_deposits
FROM
    (SELECT 
        DATE_FORMAT(Dates, '%Y-%m') AS month,
            SUM(Deposit_amt) AS total_deposits
    FROM
        bank
    GROUP BY DATE_FORMAT(Dates, '%Y-%m')) t
ORDER BY total_deposits DESC
LIMIT 1;

# 24.	Identify the month with the highest withdrawals.
SELECT 
    month, withdrawal_amt AS Highest_withdrawals
FROM
    (SELECT 
        DATE_FORMAT(Dates, '%Y-%m') AS month,
            SUM(withdrawal_amt) AS withdrawal_amt
    FROM
        bank
    GROUP BY DATE_FORMAT(Dates, '%Y-%m')) t
ORDER BY withdrawal_amt DESC
LIMIT 1;

# 25.	Count number of transactions per day.
SELECT 
    day, transactions AS transactions
FROM
    (SELECT 
        DATE_FORMAT(Dates, '%Y-%m-%d') AS day,
            COUNT(*) AS transactions
    FROM
        bank
    GROUP BY DATE_FORMAT(Dates, '%Y-%m-%d')) t
ORDER BY day;

# 26.	Find days with no withdrawals.
SELECT DISTINCT
    Dates
FROM
    bank
WHERE
    withdrawal_amt = 0;

# 27.	Find transactions where Value_date is later than Dates.
SELECT 
    *
FROM
    bank
WHERE
    Value_date > Dates;

# 28.	Calculate average balance per month.
SELECT 
    DATE_FORMAT(Dates, '%Y-%m') AS month,
    ROUND(AVG(balance_amt), 2) AS average_balance
FROM
    bank
GROUP BY DATE_FORMAT(Dates, '%Y-%m')
ORDER BY month;

# 29.	Find the most common transaction types using Transaction_Details.
SELECT 
    MAX(Transaction_Details)
FROM
    bank;

# 30.	Identify high-value transactions (top 5% by amount).
SELECT 
    *
FROM
    bank
ORDER BY (COALESCE(withdrawal_amt, 0) + COALESCE(Deposit_amt, 0)) DESC
LIMIT 5;
# COALESCE is a SQL function that returns the first non-NULL value from a list of expressions.

# 31.	Detect possible duplicate transactions.
SELECT 
    Account_No,
    Dates,
    withdrawal_amt,
    Deposit_amt,
    balance_amt,
    COUNT(*) AS duplicate_count
FROM
    bank
GROUP BY Account_No , Dates , withdrawal_amt , Deposit_amt , balance_amt
HAVING COUNT(*) > 1;

# 32.	Find consecutive transactions with the same balance.
SELECT 
	* 
FROM (
    SELECT 
		Account_No, 
        Dates, 
        balance_amt, 
        LAG(balance_amt) OVER 
			(PARTITION BY Account_No ORDER BY Dates) 
				AS prev_balance
    FROM bank
) t 
WHERE balance_amt = prev_balance;

# 33.	Identify sudden drops in balance.
SELECT *
FROM (
    SELECT 
        Account_No,
        Dates,
        balance_amt,
        LAG(balance_amt) OVER 
            (PARTITION BY Account_No ORDER BY Dates) AS prev_balance
    FROM bank
) t
WHERE prev_balance IS NOT NULL
  AND (prev_balance - balance_amt) > 10000;


# 34.	Find accounts that never made a deposit.
SELECT 
    Account_No
FROM
    bank
GROUP BY Account_No
HAVING SUM(COALESCE(Deposit_amt, 0)) = 0;

# 35.	Find accounts that never made a withdrawal.
SELECT 
    Account_No
FROM
    bank
GROUP BY Account_No
HAVING SUM(COALESCE(withdrawal_amt, 0)) = 0;

# 36.	Identify transactions with zero balance after transaction.
SELECT 
    *
FROM
    bank
WHERE
    balance_amt = 0;

# 37.	Calculate running balance per account.
SELECT 
    Account_No,
    Dates,
    Deposit_amt,
    withdrawal_amt,
    SUM(
        COALESCE(Deposit_amt, 0) 
      - COALESCE(withdrawal_amt, 0)
    ) OVER (
        PARTITION BY Account_No 
        ORDER BY Dates
    ) AS running_balance
FROM bank;

# 38.	Rank transactions by withdrawal amount within each account.
SELECT 
    Account_No,
    Dates,
    withdrawal_amt,
    RANK() OVER (
        PARTITION BY Account_No 
        ORDER BY withdrawal_amt DESC
    ) AS withdrawal_rank
FROM bank
WHERE withdrawal_amt IS NOT NULL;

# 39.	Find top 3 highest withdrawals per account.
SELECT 
    Account_No, 
    Dates, 
    withdrawal_amt
FROM (
    SELECT 
        Account_No, 
        Dates, 
        withdrawal_amt, 
        DENSE_RANK() OVER (
            PARTITION BY Account_No
            ORDER BY withdrawal_amt DESC
        ) AS rnk
    FROM bank
    WHERE withdrawal_amt IS NOT NULL
) t
WHERE rnk <= 3;

# 40.	Find top 3 highest deposits per account.
SELECT 
    Account_No, 
    Dates, 
    deposit_amt
FROM (
    SELECT 
        Account_No, 
        Dates, 
        deposit_amt, 
        DENSE_RANK() OVER (
            PARTITION BY Account_No
            ORDER BY deposit_amt DESC
        ) AS rnk
    FROM bank
    WHERE deposit_amt IS NOT NULL
) t
WHERE rnk <= 3;

# 41.	Identify transactions where balance changed abnormally.
WITH cte AS (
    SELECT 
        Account_No,
        Dates,
        balance_amt,
        LAG(balance_amt) OVER (PARTITION BY Account_No ORDER BY Dates) AS prev_balance
    FROM bank
)
SELECT *,
       ABS(balance_amt - prev_balance) AS balance_change
FROM cte
WHERE prev_balance IS NOT NULL
  AND ABS(balance_amt - prev_balance) > 50000;

# 42.	Compare daily closing balance vs previous day.
WITH cte AS (
    SELECT 
        Account_No,
        Dates,
        balance_amt AS closing_balance,
        LAG(balance_amt) OVER (
            PARTITION BY Account_No ORDER BY Dates
        ) AS previous_day_balance
    FROM bank
)
SELECT *,
       closing_balance - previous_day_balance AS daily_change
FROM cte;

# 43.	Find accounts whose balance never goes below a threshold.
SELECT 
    Account_No
FROM
    bank
GROUP BY Account_No
HAVING MIN(balance_amt) >= 1000;

# 44.	Detect frequent withdrawal patterns (fraud hint).
SELECT 
    Account_No, Dates, COUNT(*) AS withdrawal_count
FROM
    bank
WHERE
    withdrawal_amt IS NOT NULL
GROUP BY Account_No , Dates
HAVING COUNT(*) > 5;

# 45.	Which accounts are most active?
SELECT 
    Account_No, COUNT(*) AS transaction_count
FROM
    bank
GROUP BY Account_No
ORDER BY transaction_count DESC;

# 46.	Which accounts maintain the highest average balance?
SELECT 
    Account_No, AVG(balance_amt) AS avg_balance
FROM
    bank
GROUP BY Account_No
ORDER BY avg_balance DESC;

# 47.	Identify dormant accounts (no transactions in last 3 months).
SELECT DISTINCT
    Account_No
FROM
    bank
WHERE
    Account_No NOT IN (SELECT DISTINCT
            Account_No
        FROM
            bank
        WHERE
            Dates >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH));

# 48.	Detect suspicious accounts with frequent large withdrawals.
SELECT 
    Account_No, COUNT(*) AS large_withdrawal_count
FROM
    bank
WHERE
    withdrawal_amt >= 50000
GROUP BY Account_No
HAVING COUNT(*) > 3;

# 49.	Find accounts with consistent monthly savings.
WITH monthly AS (
    SELECT 
        Account_No,
        DATE_FORMAT(Dates, '%Y-%m') AS month,
        SUM(COALESCE(Deposit_amt, 0)) AS monthly_deposit
    FROM bank
    GROUP BY Account_No, month
)
SELECT Account_No
FROM monthly
WHERE monthly_deposit > 0
GROUP BY Account_No
HAVING COUNT(DISTINCT month) = (
    SELECT COUNT(DISTINCT month) FROM monthly
);

# 50.	Create a customer risk score based on transaction behavior.
SELECT 
    Account_No, 
    SUM(CASE WHEN withdrawal_amt IS NOT NULL THEN 1 ELSE 0 END)
  + SUM(CASE WHEN withdrawal_amt >= 50000 THEN 2 ELSE 0 END)
  + SUM(
        CASE 
            WHEN prev_balance IS NOT NULL 
             AND ABS(balance_amt - prev_balance) > 50000 
            THEN 3 ELSE 0 
        END
    ) AS risk_score
FROM (
    SELECT 
        Account_No, 
        Dates, 
        withdrawal_amt, 
        balance_amt, 
        LAG(balance_amt) OVER (
            PARTITION BY Account_No 
            ORDER BY Dates
        ) AS prev_balance
    FROM bank
) t
GROUP BY Account_No
ORDER BY risk_score DESC;
