CREATE TABLE Worker (
    WORKER_ID INT PRIMARY KEY,
    FIRST_NAME VARCHAR(50),
    LAST_NAME VARCHAR(50),
    SALARY INT,
    DEPARTMENT VARCHAR(50),
    --JOINING_DATE DATETIME
);

Alter Table Worker Add JOINING_DATE DATETIME
Alter Table Worker Alter Column SALARY BIGINT
Alter Table Worker Alter Column DEPARTMENT VARCHAR(100)

Alter Table Worker Add CONSTRAINT checksalary Check (Salary>100)
Alter Table Worker Add CONSTRAINT uniquefname Unique (FIRST_NAME)
