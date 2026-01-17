# Bank-Transaction-Analysis
Analyzed a messy banking transaction dataset from Kaggle using SQL. Cleaned NULL values and standardized dates, then applied window functions, aggregations, and conditional logic to study deposits, withdrawals, balance changes, and monthly consistency. Built a rule-based risk scoring model to identify high-risk accounts.

# 🏦 Bank Transaction Analysis & Risk Detection

## 📌 Project Overview
This project focuses on analyzing **bank transaction data** obtained from Kaggle.  
The dataset was **messy and inconsistent**, containing NULL values, incorrect formats, and redundant records.

The project covers:
- Data cleaning
- Exploratory analysis
- Advanced SQL analytics
- Risk scoring for bank accounts

The goal was to transform raw banking data into **meaningful insights** using SQL.

---

## 📊 Dataset
- **Source**: Kaggle (Bank Transaction Dataset)
- **Type**: Transaction-level banking data
- **Key Columns**:
  - Account_No
  - Dates
  - Deposit_amt
  - Withdrawal_amt
  - Balance_amt

---

## 🧹 Data Cleaning Steps
The dataset required extensive cleaning before analysis:

- Handled **NULL values** using `COALESCE()`
- Standardized **date formats**
- Removed invalid or duplicate records
- Ensured correct numeric values for deposits, withdrawals, and balances
- Prepared data for window functions and aggregations

---

## 🔍 Analysis & SQL Concepts Used

### ✅ SQL Concepts Applied
- Window Functions (`LAG`, `RANK`, `DENSE_RANK`, `SUM OVER`)
- Conditional logic using `CASE WHEN`
- Aggregations (`SUM`, `COUNT`)
- Date functions (`DATE_FORMAT`)
- Subqueries & CTEs
- Data validation & filtering

---

## 📈 Key Analyses Performed

### 1️⃣ Transaction Activity Analysis
- Identified top deposits and withdrawals per account
- Ranked transactions using `RANK` and `DENSE_RANK`

### 2️⃣ Balance Change Detection
- Calculated daily balance change
- Detected sudden balance spikes and drops
- Identified inactive or unchanged balance days

### 3️⃣ Running Balance Calculation
- Computed cumulative account balances over time
- Ensured proper ordering using window functions

### 4️⃣ Monthly Deposit Consistency
- Identified accounts that deposited money **every month**
- Found consistent and loyal customers

### 5️⃣ Risk Scoring Model (Rule-Based)
A custom **risk score** was created using SQL logic:
- +1 point for every withdrawal
- +2 points for withdrawals ≥ 50,000
- +3 points for sudden balance change > 50,000

Accounts were ranked based on total risk score.

---

## 🚨 Risk Scoring Logic (Example)
```sql
CASE 
  WHEN withdrawal_amt IS NOT NULL THEN 1
  WHEN withdrawal_amt >= 50000 THEN 2
  WHEN ABS(balance_amt - prev_balance) > 50000 THEN 3
END
