-- ============================================================
-- CSE 314 - Database Management System Lab
-- Topic: Views & Materialized View
-- Student: Touhid | ID: 222311092 | Varendra University
-- SQL Server: Microsoft SQL Server 2014
-- ============================================================


-- ============================================================
-- SETUP: Tables & Data (Page 43)
-- ============================================================

CREATE TABLE salesman (
    salesman_id INT PRIMARY KEY,
    name        VARCHAR(50),
    city        VARCHAR(50),
    commission  float
);

--drop table salesman
CREATE TABLE customer (
    customer_id INT PRIMARY KEY,
    cust_name   VARCHAR(50),
    city        VARCHAR(50),
    grade       INT,
    salesman_id INT REFERENCES salesman(salesman_id)
);

CREATE TABLE orders (
    ord_no      INT PRIMARY KEY,
    purch_amt   float,
    ord_date    DATE,
    customer_id INT REFERENCES customer(customer_id),
    salesman_id INT REFERENCES salesman(salesman_id)
);
--GO

INSERT INTO salesman VALUES (5001,'James Hoog','New York',0.15);
INSERT INTO salesman VALUES (5002,'Nail Knite','Paris',0.13);
INSERT INTO salesman VALUES (5005,'Pit Alex','London',0.11);
INSERT INTO salesman VALUES (5006,'Mc Lyon','Paris',0.14);
INSERT INTO salesman VALUES (5003,'Lauson Hen','Berlin',0.12);
INSERT INTO salesman VALUES (5007,'Paul Adam','Rome',0.13);

INSERT INTO customer VALUES (3002,'Nick Rimando','New York',100,5001);
INSERT INTO customer VALUES (3005,'Graham Zusi','California',200,5002);
INSERT INTO customer VALUES (3001,'Brad Guzan','London',300,5005);
INSERT INTO customer VALUES (3004,'Fabian Johns','Paris',300,5006);
INSERT INTO customer VALUES (3007,'Brad Davis','New York',200,5001);
INSERT INTO customer VALUES (3009,'Geoff Camero','Berlin',100,5003);
INSERT INTO customer VALUES (3008,'Julian Green','London',300,5002);
INSERT INTO customer VALUES (3003,'Jozy Altidor','Moscow',200,5007);

INSERT INTO orders VALUES (70001,150.50, '2012-10-05',3005,5002);
INSERT INTO orders VALUES (70009,270.65, '2012-09-10',3001,5005);
INSERT INTO orders VALUES (70002,65.26,  '2012-10-05',3002,5001);
INSERT INTO orders VALUES (70004,110.50, '2012-08-17',3009,5003);
INSERT INTO orders VALUES (70007,948.50, '2012-09-10',3005,5002);
INSERT INTO orders VALUES (70005,2400.60,'2012-07-27',3007,5001);
INSERT INTO orders VALUES (70008,5760.00,'2012-09-10',3002,5001);
INSERT INTO orders VALUES (70010,1983.43,'2012-10-10',3004,5006);
INSERT INTO orders VALUES (70003,2480.40,'2012-10-10',3009,5003);
INSERT INTO orders VALUES (70012,250.45, '2012-06-27',3008,5002);
INSERT INTO orders VALUES (70011,75.29,  '2012-08-17',3003,5007);
INSERT INTO orders VALUES (70013,3045.60,'2012-04-25',3002,5001);
--GO


-- ============================================================
-- PAGE 44 - VIEW QUESTIONS
-- ============================================================

-- Q1. View for salesmen belonging to the city New York
CREATE VIEW vw_SalesmanNewYork
AS
SELECT *
FROM salesman
WHERE city = 'New York'
--GO

SELECT * FROM vw_SalesmanNewYork
--GO


-- Q2. View for all salesmen with columns salesman_id, name, city
CREATE VIEW vw_SalesmanBasic
AS
SELECT salesman_id, name, city
FROM salesman
--GO

SELECT * FROM vw_SalesmanBasic
--GO


-- Q3. Salesmen of New York with commission > 13%
CREATE VIEW vw_SalesmanNewYorkHighCommission
AS
SELECT *
FROM salesman
WHERE city = 'New York' AND commission > 0.13
--GO

SELECT * FROM vw_SalesmanNewYorkHighCommission
--GO


-- Q4. View: count of customers at each grade level
CREATE VIEW vw_CustomerCountByGrade
AS
SELECT grade, COUNT(*) AS Num_Customers
FROM customer
GROUP BY grade
--GO

SELECT * FROM vw_CustomerCountByGrade
--GO


-- Q5. View: per day -> number of customers ordering, number of salesmen attached,
--     average order amount, total order amount
CREATE VIEW vw_DailyOrderSummary
AS
SELECT
    ord_date,
    COUNT(DISTINCT customer_id) AS Num_Customers,
    COUNT(DISTINCT salesman_id) AS Num_Salesmen,
    AVG(purch_amt)              AS Avg_Order_Amount,
    SUM(purch_amt)              AS Total_Order_Amount
FROM orders
GROUP BY ord_date
--GO

SELECT * FROM vw_DailyOrderSummary
--GO


-- Q6. View: for each order, show salesman name and customer name
CREATE VIEW vw_OrderWithNames
AS
SELECT
    o.ord_no,
    o.purch_amt,
    o.ord_date,
    s.name      AS Salesman_Name,
    c.cust_name AS Customer_Name
FROM orders o
JOIN salesman s ON o.salesman_id = s.salesman_id
JOIN customer c ON o.customer_id = c.customer_id
--GO

SELECT * FROM vw_OrderWithNames
--GO


-- Q7. View: finds the salesman who has the customer with the highest order of a day
-- (For each date, the salesman associated with the max purch_amt order)
CREATE VIEW vw_TopSalesmanPerDay
AS
SELECT
    o.ord_date,
    o.purch_amt AS Highest_Order_Amount,
    s.name      AS Salesman_Name,
    c.cust_name AS Customer_Name
FROM orders o
JOIN salesman s ON o.salesman_id = s.salesman_id
JOIN customer c ON o.customer_id = c.customer_id
WHERE o.purch_amt = (
    SELECT MAX(o2.purch_amt)
    FROM orders o2
    WHERE o2.ord_date = o.ord_date
)
--GO

SELECT * FROM vw_TopSalesmanPerDay
--GO


-- Q8. View: all customers who have the highest grade
CREATE VIEW vw_HighestGradeCustomers
AS
SELECT *
FROM customer
WHERE grade = (SELECT MAX(grade) FROM customer)
--GO

SELECT * FROM vw_HighestGradeCustomers
--GO


-- Q9. View: number of salesmen in each city
CREATE VIEW vw_SalesmanCountByCity
AS
SELECT city, COUNT(*) AS Num_Salesmen
FROM salesman
GROUP BY city
--GO

SELECT * FROM vw_SalesmanCountByCity
--GO


-- Q10. View: average and total orders for each salesman after his/her name
-- (Assume all names are unique)
CREATE VIEW vw_SalesmanOrderStats
AS
SELECT
    s.name           AS Salesman_Name,
    AVG(o.purch_amt) AS Avg_Order_Amount,
    SUM(o.purch_amt) AS Total_Order_Amount
FROM salesman s
JOIN orders o ON s.salesman_id = o.salesman_id
GROUP BY s.name
--GO

SELECT * FROM vw_SalesmanOrderStats
--GO


-- Q11. View: each salesman with more than one customer
CREATE VIEW vw_SalesmanMultipleCustomers
AS
SELECT
    s.salesman_id,
    s.name AS Salesman_Name,
    COUNT(c.customer_id) AS Num_Customers
FROM salesman s
JOIN customer c ON s.salesman_id = c.salesman_id
GROUP BY s.salesman_id, s.name
HAVING COUNT(c.customer_id) > 1
--GO

SELECT * FROM vw_SalesmanMultipleCustomers
--GO


-- Q12. View: matches of customers with salesmen such that at least one customer
-- in the city of customer is served by a salesman in the same city as the salesman
CREATE VIEW vw_CustomerSalesmanSameCity
AS
SELECT DISTINCT
    c.cust_name,
    c.city AS Customer_City,
    s.name AS Salesman_Name,
    s.city AS Salesman_City
FROM customer c
JOIN salesman s ON c.city = s.city
--GO

SELECT * FROM vw_CustomerSalesmanSameCity
--GO

--drop view vw_CustomerSalesmanSameCity


-- Q13. View: number of orders in each day
CREATE VIEW vw_OrderCountPerDay
AS
SELECT ord_date, COUNT(*) AS Num_Orders
FROM orders
GROUP BY ord_date
--GO

SELECT * FROM vw_OrderCountPerDay
--GO


-- Q14. View: salesmen who issued orders on October 10th, 2012
CREATE VIEW vw_SalesmanOrdersOct10
AS
SELECT DISTINCT s.salesman_id, s.name
FROM salesman s
JOIN orders o ON s.salesman_id = o.salesman_id
WHERE o.ord_date = '2012-10-10'
--GO

SELECT * FROM vw_SalesmanOrdersOct10
--GO


-- Q15. View: salesmen who issued orders on either August 17th, 2012 or October 10th, 2012
CREATE VIEW vw_SalesmanOrdersAugOctDates
AS
SELECT DISTINCT s.salesman_id, s.name, o.ord_date
FROM salesman s
JOIN orders o ON s.salesman_id = o.salesman_id
WHERE o.ord_date IN ('2012-08-17', '2012-10-10')
--GO

SELECT * FROM vw_SalesmanOrdersAugOctDates
--GO
