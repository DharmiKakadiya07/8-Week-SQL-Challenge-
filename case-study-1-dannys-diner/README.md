# Case Study 1: Danny’s Diner

## Table of Contents
- [Problem Statement](#problem-statement)
- [Dataset Overview](#dataset-overview)
  - [Sales Table](#sales-table)
  - [Menu Table](#menu-table)
  - [Members Table](#members-table)
- [Business Questions](#Business-Question)
- [Approach](#approach)

---

## Problem Statement

Danny owns a small restaurant called **Danny’s Diner**, which serves three menu items: sushi, curry, and ramen. Danny has collected customer transaction data but needs analytical insights to better understand customer purchasing behaviour and evaluate the impact of his loyalty program.

The objective of this case study is to analyse customer data using SQL to generate meaningful business insights related to spending, visit patterns, product preferences, and loyalty program effectiveness.

Official Case Study Source:  
https://8weeksqlchallenge.com/case-study-1/

---

## Dataset Overview

The dataset consists of three relational tables containing sales, menu, and membership information.

### Sales Table

The sales table records every product purchased by customers.

| Column | Description |
|----------|----------------|
| customer_id | Unique identifier for each customer |
| order_date | Date when the product was purchased |
| product_id | Identifier of the purchased menu item |

---

### Menu Table

The menu table stores information about the restaurant’s menu items and their prices.

| Column | Description |
|----------|----------------|
| product_id | Unique identifier for menu item |
| product_name | Name of the menu item |
| price | Price of the menu item |

---

### Members Table

The members table contains loyalty program membership information.

| Column | Description |
|----------|----------------|
| customer_id | Customer identifier |
| join_date | Date customer joined loyalty program |

---

## Business Questions

This case study answers the following business questions:

1. What is the total amount each customer spent at the restaurant?
2. How many days has each customer visited the restaurant?
3. What was the first item purchased by each customer?
4. What is the most purchased item on the menu?
5. Which item was the most popular for each customer?
6. Which item was purchased first after becoming a member?
7. Which item was purchased just before becoming a member?
8. What is the total number of items and amount spent before membership?
9. How many loyalty points did each customer earn?
10. How many points would customers have at the end of January with promotional rules applied?

---

## Approach

The analysis was performed using structured SQL techniques including:

- Joining multiple tables to combine transactional and product data
- Aggregating data using functions such as `SUM`, `COUNT`, and `DISTINCT`
- Applying window functions to analyse customer behaviour over time
- Using conditional logic to calculate loyalty points and promotional rules  


