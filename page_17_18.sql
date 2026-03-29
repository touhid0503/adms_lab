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

INSERT INTO Worker VALUES
(1,'Rana','Hamid',100000,'HR','2024-02-20 09:00:00'),
(2,'Sanjoy','Saha',80000,'Admin','2024-06-11 09:00:00'),
(3,'Mahmudul','Hasan',300000,'HR','2024-02-20 09:00:00'),
(4,'Asad','Zaman',500000,'Admin','2024-02-20 09:00:00'),
(5,'Sajib','Mia',500000,'Admin','2024-06-11 09:00:00'),
(6,'Alamgir','Kabir',200000,'Account','2024-06-11 09:00:00'),
(7,'Foridul','Islam',75000,'Account','2024-01-20 09:00:00'),
(8,'Keshob','Ray',90000,'Admin','2024-04-11 09:00:00');

SELECT * FROM Worker;

SELECT TOP 5 FIRST_NAME + ' ' + LAST_NAME AS FULL_NAME FROM Worker;
