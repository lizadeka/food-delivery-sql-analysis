# 🍴 Online Food Delivery Dataset Analysis (SQL Project)

This project analyzes an **online food delivery dataset** using SQL.  
The aim is to generate **business insights** about customer behavior, restaurant performance, popular food items, revenue trends and much more.  

---

## 📊 Dataset Overview  
- **Customers**: Customer details  
- **Orders**: Order transactions with dates 
- **Restaurants**: Partner restaurants and their location
- **Menu Items**: Menu items by restaurant along with their price 
- **Order_Details**: Links orders with menu items  

---

## 🛠 Skills & Tools  
- **SQL**: JOINs, GROUP BY, HAVING, CASE, Subqueries, Window Functions, Views, CTEs, Stored Procedures, Temp Tables  
- **Tool**: MySQL Workbench  
- **Dataset**: Mock online food delivery dataset  

---

## 🔎 SQL Analysis Performed

### 1. Customer Insights  
- Identified the **top 5 customers** by total orders.  
- Analyzed **customers who ordered from more than 3 restaurants**.
- Lists all customers who have never placed an order.

### 2. Restaurant Performance  
- Classified restaurants into categories:  
  - **Small** (<5 items)  
  - **Medium** (5–10 items)  
  - **Large** (>10 items)  
- Cheapest menu items in all restaurants.  

### 3. Popular Items  
- Found the **top 3 most frequently ordered items**.  
- Checked which restaurants sell the **most popular dish**.
- Found the **top 5 most expensive menu items**.

### 4. Revenue Analysis  
- Tracked **monthly revenue trends**.  
- Found restaurants with the **highest revenue**.  
- Calculated **average order value (AOV)**.  

### 5. Advanced Queries  
- Ranked **top products per category** using `RANK()` + `PARTITION BY`.  
- Segmented customers as:  
  - Frequent  
  - Occasional  
  - One-time  
- Used subqueries, window functions, and temp tables for complex analysis.  

---
 
## 📊 Key Metrics Summary

- **Average Order Value (AOV):** On average, customers spent **₹2,221.43 per order**.  
- **Top Performing City:** **Chennai** contributed the highest revenue of **₹349,264.89**, making it the most lucrative market.  
- **Most Frequent Customers:** The most loyal customers placed **4–5 orders**, forming the largest repeat-buyer group.  
- **One-Time Customers:** **64 customers** made only a single purchase, indicating scope for re-engagement strategies.  
- **Peak Order Month:** **July** had the highest order volume, suggesting a strong seasonal demand trend.  
- **Restaurant Performance:** **Medium-sized restaurants (5–10 items)** attracted the highest number of orders, showing that focused menus outperform very small or very large menus.  
