-- ============================================================
-- CSE 314 - Database Management System Lab
-- Topic: Stored Procedure
-- Student: Touhid | ID: 222311092 | Varendra University
-- SQL Server: Microsoft SQL Server 2014
-- HOW TO RUN: Open in SSMS -> Execute (F5) on your database
-- ============================================================


-- ============================================================
-- SETUP: Create Tables & Insert Data (Page 55)
-- ============================================================

CREATE TABLE Zone (
    Zone_Id VARCHAR(10) PRIMARY KEY,
    Name VARCHAR(50)
);

--drop table Tbl_Zone

CREATE TABLE Branch (
    Br_Id VARCHAR(10) PRIMARY KEY,
    Branch_Name VARCHAR(50)
);

--drop table Branch
CREATE TABLE Account_Detail (
    Account_no int PRIMARY KEY,
    Acc_holder_name VARCHAR(100),
    Amount int,
    Branch_Id VARCHAR(10) REFERENCES Branch(Br_Id),
    Zone_Id VARCHAR(10) REFERENCES Zone(Zone_Id)
);
--GO

-- Insert Tbl_Zone
INSERT INTO Zone VALUES ('Z-801', 'Sirajgonj'), ('Z-802', 'Rajshahi'),
('Z-803', 'Dhaka'), ('Z-804', 'Chittagong');

-- Insert Branch
INSERT INTO Branch VALUES ('B-101', 'Bonani'),
('B-102', 'Romna'),
('B-103', 'Shaheb bazar'),
('B-104', 'Ullapara');

-- Insert Account_Detail
INSERT INTO Account_Detail VALUES (1992212, 'Mr. Nazmuzzaman', 200000, 'B-101', 'Z-803'),
(1992213, 'Mr. Jibon', 170000, 'B-102', 'Z-803'),
(1882212, 'Bushra', 180000, 'B-103', 'Z-802'),
(1882213, 'Sajib', 170000, 'B-104', 'Z-801');
--GO
--drop table Account_Detail

-- ============================================================
-- PAGE 55 - STORED PROCEDURE QUESTIONS
-- ============================================================

-- Q1. 
CREATE PROC SPdetails
AS
BEGIN
    SELECT
        A.Acc_holder_name,
        A.Amount,
        B.Branch_Name,
        Z.Name as Zone_Name
    FROM Account_Detail A
    JOIN Branch B ON A.Branch_Id = B.Br_Id
    JOIN Zone Z ON A.Zone_Id = Z.Zone_Id
END
--GO

--drop proc SPdetails

EXEC SPdetails
--GO


-- Q2. 
CREATE PROC SPaverage
    @BranchName VARCHAR(50),
    @Amount  int
AS
BEGIN	
    SELECT
        B.Branch_Name,
        A.Amount
    FROM Account_Detail A
    JOIN Branch B ON A.Branch_Id = B.Br_Id
    WHERE B.Branch_Name = @BranchName AND A.Amount > @Amount
END
--GO

EXEC SPaverage @BranchName = 'Bonani', @Amount = 17000
--GO


-- Q3. 
CREATE PROC SPbalance
    @ZoneName VARCHAR(50)
AS
BEGIN
    DECLARE @Amt INT
    SELECT @Amt = SUM(A.Amount)
    FROM Account_Detail A
    JOIN Zone Z ON A.Zone_Id = Z.Zone_Id
    WHERE Z.Name = @ZoneName
    RETURN @Amt
END
--GO
--drop proc SPbalance
--GO

DECLARE @Amt INT
EXECUTE @Amt=SPbalance @ZoneName = 'Dhaka'
PRINT @Amt
--GO
--GO

--GO


-- Q4. 
CREATE PROC SPamount
AS
BEGIN
    SELECT
        A.Acc_holder_name,
        B.Branch_Name,
        Z.Name AS Zone_Name
    FROM Account_Detail A
    JOIN Branch   B ON A.Branch_Id = B.Br_Id
    JOIN Zone Z ON A.Zone_Id = Z.Zone_Id
    WHERE A.Acc_holder_name LIKE '%Mr.%' AND A.Amount < (SELECT MAX(Amount) FROM Account_Detail)
END
--GO

EXEC SPamount
--GO


-- Q5.
CREATE PROC SPdetailsInfo
    @ZoneName VARCHAR(50),
    @CustomerCount INT OUTPUT
AS
BEGIN
    SELECT @CustomerCount = COUNT(*)
    FROM Account_Detail A
    JOIN Zone Z ON A.Zone_Id = Z.Zone_Id
    WHERE Z.Name = @ZoneName
END
--GO

DECLARE @Count INT
EXEC SPdetailsInfo @ZoneName = 'Dhaka', @CustomerCount = @Count OUTPUT
PRINT @Count
--GO


-- Q6.
CREATE PROC spEmployeeSalaryDetails1
    @StartAmount int,
    @EndAmount int,
    @BranchName VARCHAR(50),
    @BranchCount INT OUTPUT
AS
BEGIN
    SELECT @BranchCount = COUNT(*)
    FROM Account_Detail A
    JOIN Branch B ON A.Branch_Id = B.Br_Id
    WHERE A.Amount BETWEEN @StartAmount AND @EndAmount AND B.Branch_Name = @BranchName
END
--GO

DECLARE @BranchCount INT
EXEC spEmployeeSalaryDetails1
    @StartAmount = 100000,
    @EndAmount   = 200000,
    @BranchName  = 'Bonani',
    @BranchCount = @BranchCount OUTPUT
PRINT @BranchCount
--GO


-- Q7. 
CREATE PROC SPdetailsInfo2
    @ZoneName VARCHAR(50)
AS
BEGIN
    SELECT
        Z.Name AS Zone_Name,
        COUNT(A.Account_no) AS Num_Customers
    FROM Account_Detail A
    JOIN Zone Z ON A.Zone_Id = Z.Zone_Id
    WHERE Z.Name = @ZoneName
    GROUP BY Z.Name
END
--GO
--drop proc SPdetailsInfo2
EXEC SPdetailsInfo2 @ZoneName = 'Dhaka'
--GO


-- Q8.
CREATE PROC SPdetailsInfo1
    @ZoneName VARCHAR(50)
AS
BEGIN
    SELECT
        Z.Name AS Zone_Name,
        COUNT(DISTINCT A.Branch_Id) AS Num_Branches
    FROM Account_Detail A
    JOIN Zone Z ON A.Zone_Id = Z.Zone_Id
    WHERE Z.Name = @ZoneName
    GROUP BY Z.Name
END


EXEC SPdetailsInfo1 @ZoneName = 'Dhaka'




