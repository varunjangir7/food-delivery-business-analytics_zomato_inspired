# 🍔 End-to-End Food Delivery Business Analytics (Zomato-Inspired)

## 📌 Project Overview
This project analyzes a food delivery business to understand **why revenue growth is not translating into profit** and how **customer behavior (new vs repeat)** impacts profitability and sustainable growth.

The analysis focuses on **Profit, Retention, and Growth** using **PostgreSQL + Power BI**, following real-world data analytics practices.

---

## 🧩 Business Problem
Despite strong order volume and revenue growth, the business faces **declining and inconsistent profit margins**.  
Heavy discounting and increasing delivery costs are suspected causes, but their real impact on **customer retention and long-term growth** is unclear.

**Core challenge:**  
How can the business grow sustainably without sacrificing profitability?

---

## ❓ Business Questions
1. Where is profit leaking despite high revenue?
2. Do discounts actually improve customer retention?
3. How do repeat customers differ from one-time customers in profitability?
4. Is growth driven by new customers or repeat customers—and which is more sustainable?

---

## 🏗️ Data & Modeling Approach

### Data Sources
- **Orders (Fact Table)** – Order-level transactions  
- **Users (Dimension Table)** – Customer attributes  
- **Restaurants (Dimension Table)** – Restaurant category and location  

---

## 📊 Power BI Dashboard Structure

### Page 1: Profit & Leakage Analysis
**Goal:** Identify profit leakage  
**Key KPIs:**
- Total Revenue
- Total Profit
- Profit Margin %
- Total Discount
- Average Order Value

---

### Page 2: Customer Behavior & Retention
**Goal:** Understand customer value  
**Key KPIs:**
- Total Customers
- Repeat Customers
- Repeat Rate %
- Avg Orders per Customer

---

### Page 3: Growth Analysis
**Goal:** Evaluate sustainability of growth  
**Key KPIs:**
- New Customer Orders
- Repeat Customer Orders
- New Customer Revenue %
- Profit Contribution (New vs Repeat)

---

## 🔍 Key Insights & Recommendations

### 1. Revenue Growth ≠ Profit Growth  
**Insight:** High-revenue cities show low profit margins due to discounts and delivery costs.  
**Recommendation:** Shift focus from revenue KPIs to profit margin KPIs and control discounting.

---

### 2. Discount-Led Orders Drive Profit Leakage  
**Insight:** Discounts increase order volume but reduce profitability with minimal retention benefit.  
**Recommendation:** Replace blanket discounts with targeted offers for high-value users.

---

### 3. Repeat Customers Are Low Volume but High Value  
**Insight:** Repeat customers contribute significantly higher profit per customer.  
**Recommendation:** Invest more in retention and loyalty programs.

---

### 4. Discounts Do Not Guarantee Retention  
**Insight:** Heavy first-order discounts do not significantly improve repeat behavior.  
**Recommendation:** Incentivize second-order conversion instead of heavy first-order discounts.

---

### 5. Growth Is Acquisition-Heavy, Profit Comes from Repeat Users  
**Insight:** New customers drive revenue, but repeat customers drive profit.  
**Recommendation:** Balance acquisition with retention-focused growth strategy.

---

## 🛠️ Tools & Technologies
- **PostgreSQL** – Data cleaning, transformations, business logic
- **Power BI** – Data modeling, DAX measures, dashboards
- **CSV / Excel** – Raw data ingestion

---

## 🎯 Key Takeaway
Sustainable growth in food delivery is driven not by heavy discounting, but by **profitable customer retention and data-driven decision-making**.

---

## 📎 Deliverables
- Interactive Power BI dashboard (3 pages)
- SQL-based data cleaning and business logic
- End-to-end analytics documentation

