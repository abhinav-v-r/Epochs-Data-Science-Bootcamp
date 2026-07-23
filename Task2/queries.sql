-- ============================================================
-- Epochs '26 - Assignment 2: Northwind Database SQL Analysis
-- Database: northwind.db (SQLite3)
-- Source: https://github.com/jpwhite3/northwind-SQLite3
-- ============================================================


-- ------------------------------------------------------------
-- 1. Top 10 Selling Products (by total revenue)
-- ------------------------------------------------------------
-- Revenue per line item = UnitPrice * Quantity * (1 - Discount)
SELECT
    p.ProductID,
    p.ProductName,
    SUM(od.Quantity)                                        AS total_units_sold,
    ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS total_revenue
FROM "Order Details" od
JOIN Products p ON p.ProductID = od.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY total_revenue DESC
LIMIT 10;


-- ------------------------------------------------------------
-- 2. Top 10 Customers by Revenue
-- ------------------------------------------------------------
SELECT
    c.CustomerID,
    c.CompanyName,
    COUNT(DISTINCT o.OrderID)                                     AS total_orders,
    ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS total_revenue
FROM Customers c
JOIN Orders o ON o.CustomerID = c.CustomerID
JOIN "Order Details" od ON od.OrderID = o.OrderID
GROUP BY c.CustomerID, c.CompanyName
ORDER BY total_revenue DESC
LIMIT 10;


-- ------------------------------------------------------------
-- 3. Monthly Sales Trends (revenue and order count by month)
-- ------------------------------------------------------------
SELECT
    strftime('%Y-%m', o.OrderDate)                                AS order_month,
    COUNT(DISTINCT o.OrderID)                                     AS total_orders,
    ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS total_revenue
FROM Orders o
JOIN "Order Details" od ON od.OrderID = o.OrderID
GROUP BY order_month
ORDER BY order_month;


-- ------------------------------------------------------------
-- 4. Best-Performing Product Categories (by revenue)
-- ------------------------------------------------------------
SELECT
    cat.CategoryID,
    cat.CategoryName,
    COUNT(DISTINCT od.OrderID)                                    AS total_orders,
    SUM(od.Quantity)                                              AS total_units_sold,
    ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS total_revenue
FROM Categories cat
JOIN Products p ON p.CategoryID = cat.CategoryID
JOIN "Order Details" od ON od.ProductID = p.ProductID
GROUP BY cat.CategoryID, cat.CategoryName
ORDER BY total_revenue DESC;


-- ------------------------------------------------------------
-- 5. Customer Purchase Frequency
-- ------------------------------------------------------------
-- Number of distinct orders per customer, and average days between orders
SELECT
    c.CustomerID,
    c.CompanyName,
    COUNT(DISTINCT o.OrderID)                                     AS total_orders,
    MIN(o.OrderDate)                                              AS first_order,
    MAX(o.OrderDate)                                              AS last_order,
    ROUND(
        CAST(julianday(MAX(o.OrderDate)) - julianday(MIN(o.OrderDate)) AS REAL)
        / NULLIF(COUNT(DISTINCT o.OrderID) - 1, 0),
        1
    )                                                              AS avg_days_between_orders
FROM Customers c
JOIN Orders o ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.CompanyName
ORDER BY total_orders DESC;
