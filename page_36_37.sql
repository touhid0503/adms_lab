CREATE TABLE Worker2 (
    WORKER_ID INT PRIMARY KEY,
    FIRST_NAME VARCHAR(50),
    LAST_NAME VARCHAR(50),
    SALARY INT,
    DEPARTMENT VARCHAR(50),
    JOINING_DATE DATETIME
);

INSERT INTO Worker2 VALUES
(1,'Rana','Hamid',100000,'HR','2024-02-20'),
(2,'Sanjoy','Saha',80000,'Admin','2024-06-11'),
(3,'Mahmudul','Hasan',300000,'HR','2024-02-20'),
(4,'Asad','Zaman',500000,'Admin','2024-02-20'),
(5,'Sajib','Mia',500000,'Admin','2024-06-11'),
(6,'Alamgir','Kabir',200000,'Account','2024-06-11'),
(7,'Foridul','Islam',75000,'Account','2024-01-20'),
(8,'Keshob','Ray',90000,'Admin','2024-04-11');

select * from Worker2
