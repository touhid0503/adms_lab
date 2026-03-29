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

INSERT INTO Department VALUES
(1, 'CSE', 'Talaimari'),
(2, 'EEE', 'Talaimari'),
(3, 'English', 'Kajla'),
(4, 'BBA', 'Talaimari');

UPDATE Teacher
SET Salary = 
    CASE 
        WHEN Dept = 'CSE' THEN Salary * 1.15
        ELSE Salary * 1.10
    END;

Select *
INTO Teacher_Copy
FROM Teacher
WHERE TID IN (SELECT TID FROM Teacher);

SELECT FirstName + ' ' + LastName AS FullName, Age
FROM Teacher
WHERE Salary = (SELECT MAX(Salary) FROM Teacher);

SELECT FirstName, Age, Dept
FROM Teacher
WHERE Age BETWEEN 23 AND 27;

SELECT TID, FirstName
FROM Teacher
WHERE Salary < (SELECT AVG(Salary) FROM Teacher);

UPDATE Teacher
SET Dept = 'English'
WHERE Dept IN (
    SELECT deptName FROM Department WHERE deptName = 'EEE'
);

UPDATE Teacher
SET Salary = Salary * 100
WHERE TID IN (
    SELECT TID FROM Teacher WHERE Salary > 5000
);

SELECT FirstName
FROM Teacher
WHERE TID IN (
    SELECT TID 
    FROM Teacher 
    WHERE FirstName LIKE 'd%' OR FirstName LIKE 'f%'
);

SELECT FirstName, Salary
FROM Teacher
WHERE Dept = 'CSE'
AND Salary > (
    SELECT Salary 
    FROM Teacher 
    WHERE FirstName = 'Mizanur' AND LastName = 'Rahman'
);

SELECT TID, FirstName
FROM Teacher
WHERE Dept = (
    SELECT Dept 
    FROM Teacher 
    WHERE FirstName = 'Delwar' AND Age = 26
);

SELECT Teacher.TID, Teacher.Salary, Department.deptID
FROM Teacher 
JOIN Department ON Teacher.Dept = Department.deptName
WHERE Teacher.Salary > (SELECT AVG(Salary) FROM Teacher);

SELECT Dept, MIN(Salary)
FROM Teacher
GROUP BY Dept
HAVING MIN(Salary) < (SELECT AVG(Salary) FROM Teacher);
