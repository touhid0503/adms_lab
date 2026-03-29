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

INSERT INTO Teacher VALUES
(1, 'Mizanur', 'Rahman', 'CSE', 28, 35000),
(2, 'Delwar', 'Hossain', 'CSE', 26, 33000),
(3, 'Shafiul', 'Islam', 'EEE', 24, 30000),
(4, 'Faisal', 'Imran', 'CSE', 30, 50000),
(5, 'Ahsan', 'Habib', 'English', 28, 28000);
