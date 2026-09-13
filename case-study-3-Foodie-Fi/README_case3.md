# 🥑 Case Study #3: Foodie-Fi

## Table of Contents
- [Problem Statement](#problem-statement)
- [Dataset Overview](#dataset-overview)
- [Business Questions](#business-questions)
- [Approach](#approach)

---

## Problem Statement

Danny and his friends launched Foodie-Fi, a streaming service exclusively for food related content (think Netflix but only for cooking shows and food documentaries). The business sells monthly and annual subscriptions giving customers unlimited on-demand access to exclusive food videos.

Danny wants to use data driven insights to understand customer behaviour, analyse subscription patterns, and make informed decisions about future investments and new features.

The objective of this case study is to analyse subscription data using SQL to answer key business questions around customer journey, churn, plan distribution, and revenue.

Official Case Study Source:
https://8weeksqlchallenge.com/case-study-3/

---

## Dataset Overview

The dataset consists of two tables containing subscription and plan information.

### Plans Table
Records the available subscription plans and their prices.

| Column | Description |
|---|---|
| plan_id | Unique identifier for each plan |
| plan_name | Name of the subscription plan |
| price | Monthly price of the plan |

#### Available Plans:

| plan_id | plan_name | price |
|---|---|---|
| 0 | Trial | $0 (7 days free) |
| 1 | Basic Monthly | $9.90 |
| 2 | Pro Monthly | $19.90 |
| 3 | Pro Annual | $199.00 |
| 4 | Churn | NULL (cancelled) |

### Subscriptions Table
Records every plan change for each customer.

| Column | Description |
|---|---|
| customer_id | Unique identifier for each customer |
| plan_id | Identifier of the subscription plan |
| start_date | Date the plan started |

---

## Business Questions

### A. Customer Journey
- Write a brief description about each customer's onboarding journey based on the sample dataset

### B. Data Analysis Questions
1. How many customers has Foodie-Fi ever had?
2. What is the monthly distribution of trial plan start_date values?
3. What plan start_date values occur after the year 2020?
4. What is the customer count and percentage of customers who have churned?
5. How many customers have churned straight after their initial free trial?
6. What is the number and percentage of customer plans after their initial free trial?
7. What is the customer count and percentage breakdown of all plan values as of 2020-12-31?
8. How many customers have upgraded to an annual plan in 2020?
9. How many days on average does it take for a customer to upgrade to an annual plan?
10. Can you further breakdown this average value into 30 day periods?
11. How many customers downgraded from a pro monthly to a basic monthly plan in 2020?

### C. Challenge Payment Question
- Create a payments table for 2020 based on subscription data

---

## Approach

The analysis was performed using structured SQL techniques including:
- Using DATE functions such as MONTH(), YEAR(), and DATEDIFF() for time based analysis
- Applying window functions and CTEs for complex subscription journey analysis
- Using COUNT, SUM and ROUND for customer and revenue aggregations
- Applying conditional logic with CASE WHEN for plan categorisation
- Calculating churn rates and plan distribution percentages
- Analysing customer behaviour patterns across subscription lifecycle
