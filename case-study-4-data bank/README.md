# 💰 Case Study #4: Data Bank

## Table of Contents
- [Problem Statement](#problem-statement)
- [Dataset Overview](#dataset-overview)
- [Business Questions](#business-questions)
- [Approach](#approach)

---

## Problem Statement

Data Bank is a digital bank that also provides secure distributed cloud data storage to its customers. The amount of data storage a customer is allocated is directly linked to how much money they have in their accounts.

Danny wants to analyse customer node distribution, transaction behaviour, and data allocation requirements to help grow the customer base and plan infrastructure needs.

The objective of this case study is to analyse banking and node data using SQL to generate insights about customer distribution, transaction patterns, and storage allocation options.

Official Case Study Source:
https://8weeksqlchallenge.com/case-study-4/

---

## Dataset Overview

The dataset consists of three tables containing region, node, and transaction information.

### Regions Table
Records the different regions where Data Bank operates.

| Column | Description |
|---|---|
| region_id | Unique identifier for each region |
| region_name | Name of the region |

#### Available Regions:
| region_id | region_name |
|---|---|
| 1 | Australia |
| 2 | America |
| 3 | Africa |
| 4 | Asia |
| 5 | Europe |

### Customer Nodes Table
Records which node each customer is allocated to in each region.

| Column | Description |
|---|---|
| customer_id | Unique identifier for each customer |
| region_id | Region where the customer is allocated |
| node_id | Node the customer is currently allocated to |
| start_date | Date customer was allocated to this node |
| end_date | Date customer was reallocated to a new node |

### Customer Transactions Table
Records all transactions made by customers.

| Column | Description |
|---|---|
| customer_id | Unique identifier for each customer |
| txn_date | Date of the transaction |
| txn_type | Type of transaction (deposit, withdrawal, purchase) |
| txn_amount | Amount of the transaction |

---

## Business Questions

### A. Customer Nodes Exploration
1. How many unique nodes are there on the Data Bank system?
2. What is the number of nodes per region?
3. How many customers are allocated to each region?
4. How many days on average are customers reallocated to a different node?
5. What is the median, 80th and 95th percentile for this same reallocation days metric for each region?

### B. Customer Transactions
1. What is the unique count and total amount for each transaction type?
2. What is the average total historical deposit counts and amounts for all customers?
3. For each month, how many Data Bank customers make more than 1 deposit and either 1 purchase or 1 withdrawal in a single month?
4. What is the closing balance for each customer at the end of the month?
5. What is the percentage of customers who increase their closing balance by more than 5%?

### C. Data Allocation Challenge
Generate the following data elements to estimate data provisioning needs:
- Running customer balance including impact of each transaction
- Customer balance at the end of each month
- Minimum, average and maximum values of the running balance for each customer

### D. Extra Challenge
- Calculate data growth using an interest calculation similar to a traditional savings account

### E. Extension Request
1. Generate headline insights about Data Bank's security features for investors
2. Create a presentation for marketing purposes

---

## Approach

The analysis was performed using structured SQL techniques including:
- Using COUNT DISTINCT for unique node and customer analysis
- Joining multiple tables to combine regional and transaction data
- Using DATE functions to analyse node reallocation patterns
- Applying CASE WHEN for transaction type categorisation
- Using window functions for running balance calculations
- Calculating percentiles for statistical analysis
- Using CTEs for complex multi-step balance calculations
