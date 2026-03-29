CREATE TABLE Teacher (
    TID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Dept VARCHAR(50),
    Age INT,
    Salary INT
);

CREATE TABLE Department (
    deptID INT PRIMARY KEY,
    deptName VARCHAR(50),
    location VARCHAR(50)
);
