
# Bengaluru Food Delivery Analysis (Microsoft Fabric)

## Overview
This project demonstrates an end-to-end data engineering pipeline using Microsoft Fabric. The goal was to clean, transform, and analyze a messy food delivery dataset from Bengaluru.

---

## Architecture
Raw CSV → Lakehouse → PySpark Cleaning → Delta Table → Data Pipeline → Data Warehouse → SQL Analysis

---

## Tech Stack
- Microsoft Fabric
- PySpark
- SQL (T-SQL)
- Data Warehousing

---

## Data Cleaning (PySpark)
- Standardized city names (e.g., Bnegaluru → Bengaluru)
- Extracted numeric ratings from strings (e.g., 4.5/5 → 4.5)
- Handled NULL values
- Applied business logic:
  - Offline orders → no delivery time or distance

---

## Data Analysis (SQL)

### Sales & Revenue
- Total revenue calculation
- Top cuisines by revenue
- Revenue by location
- Average Order Value (AOV)

### Operational Efficiency
- Average delivery time
- Fastest restaurants
- Delivery delays by location
- Distance vs delivery time analysis

### Customer Behavior
- Online vs Offline order %
- Impact of table booking on spend
- Peak order hours
- Popular locations

### Ratings & Quality
- Top-rated restaurants
- Cuisine-wise ratings
- Rating vs spending correlation



