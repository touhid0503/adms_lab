-- ============================================================
-- SETUP: Create Tables & Insert Data (Page 60-61)
-- ============================================================
CREATE TABLE Tbl_Management (
    Mgt_id       VARCHAR(10)  PRIMARY KEY,
    Mgt_Name     VARCHAR(50),
    Joining_date DATE,
    Salary       int,
    [Position]   VARCHAR(50)       -- Position is a reserved word; brackets required
);

CREATE TABLE Tbl_Emp (
    Emp_id       VARCHAR(10)  PRIMARY KEY,
    Emp_Name     VARCHAR(50),
    Joining_Date DATE,
    Salary       int,
    Division     VARCHAR(50)
);

CREATE TABLE Tbl_Project (
    P_id          VARCHAR(10)  PRIMARY KEY,
    P_Name        VARCHAR(100),
    Mgt_id        VARCHAR(10)  REFERENCES Tbl_Management(Mgt_id),
    E_id          VARCHAR(10)  REFERENCES Tbl_Emp(Emp_id),
    P_Cost        int,
    Delivery_date DATE
);

INSERT INTO Tbl_Management VALUES ('M2015','Keshob','2001-01-18',250000,'Managing Director');
INSERT INTO Tbl_Management VALUES ('M2016','Rana',  '2003-01-30',180000,'Secretary');
INSERT INTO Tbl_Management VALUES ('M2017','Jasim', '2004-04-12',150000,'Join secretary');
INSERT INTO Tbl_Management VALUES ('M2018','Rajon', '2004-06-18',140000,'Join secretary');

INSERT INTO Tbl_Emp VALUES ('E1001','Suman',  '2003-04-25',92000,'Software');
INSERT INTO Tbl_Emp VALUES ('E1002','Rasel',  '2004-03-13',86000,'Network');
INSERT INTO Tbl_Emp VALUES ('E1003','Hossain','2004-06-21',82000,'Software');
INSERT INTO Tbl_Emp VALUES ('E1004','Polash', '2005-05-05', 9800,'Network');

INSERT INTO Tbl_Project VALUES ('P3001','Office Automation',  'M2016','E1001',2050000,'2016-05-08');
INSERT INTO Tbl_Project VALUES ('P3002','Repair Hub',         'M2016','E1004',1200000,'2017-06-14');
INSERT INTO Tbl_Project VALUES ('P3003','Server Installation','M2018','E1001',1500500,'2018-02-13');
INSERT INTO Tbl_Project VALUES ('P3004','Network setup',      'M2017','E1002',2505000,'2018-03-12');


-- ============================================================
-- PAGE 60-61 - FUNCTION QUESTIONS
-- ============================================================
-- Q1.
SELECT
    P.P_Name,
    P.P_Cost,
    RANK() OVER (ORDER BY P.P_Cost ASC) AS Cost_Rank,
    E.Emp_Name
FROM Tbl_Project P
JOIN Tbl_Emp E ON P.E_id = E.Emp_id
ORDER BY P.P_Cost ASC

-- Q2.
CREATE FUNCTION fnProjectDetails
(
    @ProjectName VARCHAR(100),
    @EmpName     VARCHAR(50)
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        P.P_Name,
        P.P_Cost,
        E.Emp_Name
    FROM Tbl_Project P
    JOIN Tbl_Emp E ON P.E_id = E.Emp_id
    WHERE P.P_Name   = @ProjectName
      AND E.Emp_Name = @EmpName
)

SELECT * FROM dbo.fnProjectDetails('Office Automation', 'Suman')
ORDER BY P_Cost ASC


-- Q3.
SELECT
    Mgt_id,
    Mgt_Name,
    Joining_date,
    RANK() OVER (ORDER BY Joining_date ASC) AS Joining_Rank
FROM Tbl_Management
ORDER BY Joining_Rank

--Q4.
CREATE FUNCTION fnMaxSalaryIncreased
(
    @Salary int
)
RETURNS int
AS
BEGIN
    DECLARE @MaxSalary int
    SET @MaxSalary = (SELECT MAX(Salary) FROM Tbl_Emp)
    IF @Salary = @MaxSalary
        RETURN @Salary * 1.10
    RETURN @Salary
END

SELECT
    Emp_Name,
    Salary,
    dbo.fnMaxSalaryIncreased(Salary) AS Updated_Salary
FROM Tbl_Emp

-- Q5.
CREATE FUNCTION fnMaxCostProject()
RETURNS VARCHAR(100)
AS
BEGIN
    DECLARE @PName VARCHAR(100)
    SELECT @PName = P_Name
    FROM Tbl_Project
    WHERE P_Cost = (SELECT MAX(P_Cost) FROM Tbl_Project)
    RETURN @PName
END

SELECT dbo.fnMaxCostProject() AS Max_Cost_Project

-- Q6.
CREATE FUNCTION fnProjectCostRange
(
    @MinCost int,
    @MaxCost int
)
RETURNS TABLE
AS
RETURN
(
    SELECT P_Name, P_Cost
    FROM Tbl_Project
    WHERE P_Cost BETWEEN @MinCost AND @MaxCost
)

SELECT * FROM dbo.fnProjectCostRange(1200000, 2050000)
ORDER BY P_Cost ASC

-- Q7.
CREATE FUNCTION fnEmployee
(
    @P_id   VARCHAR(10),
    @Mgt_id VARCHAR(10),
    @Emp_id VARCHAR(10)
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        M.Mgt_id,
        M.Mgt_Name,
        E.Emp_Name,
        E.Joining_Date,
        E.Salary,
        P.P_Name,
        P.P_Cost,
        P.Delivery_date
    FROM Tbl_Project P
    JOIN Tbl_Management M ON P.Mgt_id = M.Mgt_id
    JOIN Tbl_Emp        E ON P.E_id   = E.Emp_id
    WHERE P.P_id   = @P_id
      AND P.Mgt_id = @Mgt_id
      AND P.E_id   = @Emp_id
)

SELECT * FROM dbo.fnEmployee('P3001', 'M2016', 'E1001')
