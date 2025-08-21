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
- lists all customers who have never placed an order.

### 2. Restaurant Performance  
- Classified restaurants into categories:  
  - **Small** (<5 items)  
  - **Medium** (5–10 items)  
  - **Large** (>10 items)  
- Counted restaurants in each category and compared their order volumes.  

### 3. Popular Items  
- Found the **top 3 most frequently ordered items**.  
- Checked which restaurants sell the **most popular dish**.  
- Analyzed menu diversity vs concentrated demand.  

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

## 📌 Key Insights  

- 👥 **Customer Behavior**  
  - A small group of **power users** placed far more orders than average.  
  - Some customers ordered from **8+ restaurants**, showing variety-seeking.  

- 🍽️ **Restaurant Insights**  
  - Most restaurants are **Medium-sized (5–10 items)**.  
  - Large restaurants (>10 items) don’t dominate sales.  

- 🍜 **Popular Items**  
  - **Momos, Fish Curry, and Aloo Paratha** are the top 3 dishes.  
  - These represent comfort foods with **broad appeal**.  

- 💰 **Revenue Trends**  
  - Revenue grows steadily, with **spikes during festivals/weekends**.  
  - **20% of restaurants contribute to ~80% of sales** .  
  - **Average Order Value** is stable → consistent spending habits.  

- 🧮 **Advanced Findings**  
  - Top 3 items in each category drive most sales.  
  - Customer segmentation shows:  
    - **Frequent Customers (~15%) → Most revenue**  
    - **Occasional Customers (~60%) → Engagement drivers**  
    - **One-time Customers (~25%) → Growth opportunity**  

---
