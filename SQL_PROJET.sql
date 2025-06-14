
--Employee Table Created...
  CREATE TABLE Employee (
  EmpID int NOT NULL,
  EmpName Varchar(20),
  Gender Char,
  Salary int,
  City Char(20) )

--Describe Table
  Desc employee

--Retrive All Columns And Rows From EMPLOYEE 
  select * from EMPLOYEE

--Insert Values For Employee Table 
  INSERT INTO Employee 
  VALUES (1, 'Arjun', 'M', 75000, 'Pune'),
  (2, 'Ekadanta', 'M', 125000, 'Bangalore'),
  (3, 'Lalita', 'F', 150000 , 'Mathura'),
  (4, 'Madhav', 'M', 250000 , 'Delhi'),
  (5, 'Visakha', 'F', 120000 , 'Mathura')

--EmployeeDetail Table Created...
  CREATE TABLE EmployeeDetail (
  EmpID int NOT NULL,
  Project Varchar(30),
  EmpPosition Char(20),
  DOJ date )

--Describe Table
  Desc EmployeeDetail
  
--Retrive All Columns And Rows From EMPLOYEEDETAIL
  select * from EMPLOYEEDETAIL

--Insert Values For EmployeeDetail Table
INSERT INTO EmployeeDetail
VALUES (1, 'P1', 'Executive', '26-jan-2019'),
(2, 'P2', 'Executive', '04-may-2020'),
(3, 'P1', 'Lead', '21-oct-2021'),
(4, 'P3', 'Manager', '29-nov-2019'),
(5, 'P2', 'Manager', '01-aug-2020')


--Q1(a): Find the list of employees whose salary ranges between 2L to 3L.
  SELECT EmpName, Salary FROM Employee
  WHERE Salary > 200000 AND Salary < 300000
  --- OR �--
  SELECT EmpName, Salary FROM Employee
  WHERE Salary BETWEEN 200000 AND 300000
  
--Q1(b): Write a query to retrieve the list of employees from the same city.
  SELECT E1.EmpID, E1.EmpName, E1.City
  FROM Employee E1, Employee E2
  WHERE E1.City = E2.City AND E1.EmpID != E2.EmpID 

--Q1(c): Query to find the null values in the Employee table. 
  SELECT * FROM Employee
  WHERE EmpID IS NULL

--Q2(a): Query to find the cumulative sum of employee�s salary.
  SELECT EmpID, Salary, SUM(Salary)
  AS CumulativeSum
  FROM Employee 
  GROUP BY EmpID, Salary 

--Q2(b): What�s the male and female employees ratio.
  SELECT 
     (COUNT(CASE WHEN Gender = 'M' THEN 1 END) * 100.0 / COUNT(*)) AS MalePct,
     (COUNT(CASE WHEN Gender = 'F' THEN 1 END) * 100.0 / COUNT(*)) AS FemalePct
  FROM Employee;

--Q2(c): Write a query to fetch 50% records from the Employee table
  SELECT * FROM Employee
  WHERE EmpID <= (SELECT COUNT(EmpID)/2 from Employee)

--Q3: Query to fetch the employee�s salary but replace the LAST 2 digits with �XX� i.e 12345 will be 123XX
  SELECT 
      Salary,
      SUBSTR(Salary, 1, LENGTH(Salary) - 2) || 'XX' AS masked_salary
  FROM Employee;

--Q4: Write a query to fetch even and odd rows from Employee table.
  SELECT * FROM (
      SELECT Employee.*, ROWNUM AS row_num FROM Employee
  ) 
  WHERE MOD(row_num, 2) = 0; -- Even rows
 ---OR---
  SELECT * FROM (
      SELECT Employee.*, ROWNUM AS row_num FROM Employee
  ) 
  WHERE MOD(row_num, 2) <> 0; -- Odd rows

/*Q5(a): Write a query to find all the Employee names whose name:
� Begin with �A�
� Contains �A� alphabet at second place
� Contains �Y� alphabet at second last place
� Ends with �L� and contains 4 alphabets
� Begins with �V� and ends with �A� */
  SELECT * FROM Employee WHERE EmpName LIKE 'A%';
  SELECT * FROM Employee WHERE EmpName LIKE '_a%';
  SELECT * FROM Employee WHERE EmpName LIKE '%y_';
  SELECT * FROM Employee WHERE EmpName LIKE '____l';
  SELECT * FROM Employee WHERE EmpName LIKE 'V%a';
  
/*Q5(b): Write a query to find the list of Employee names which is:
� starting with vowels (a, e, i, o, or u), without duplicates
� ending with vowels (a, e, i, o, or u), without duplicates
� starting & ending with vowels (a, e, i, o, or u), without duplicates */

  SELECT DISTINCT EmployeeName
  FROM Employee
  WHERE LOWER(SUBSTR(EmployeeName, 1, 1)) IN ('a', 'e', 'i', 'o', 'u'); -- Starting with vowels

  SELECT DISTINCT EmployeeName
  FROM Employee
  WHERE LOWER(SUBSTR(EmployeeName, -1, 1)) IN ('a', 'e', 'i', 'o', 'u'); -- Ending with vowels

  SELECT DISTINCT EmployeeName
  FROM Employee
  WHERE LOWER(SUBSTR(EmployeeName, 1, 1)) IN ('a', 'e', 'i', 'o', 'u')
  AND LOWER(SUBSTR(EmployeeName, -1, 1)) IN ('a', 'e', 'i', 'o', 'u'); -- Starting & ending with vowels

--Q6: Find Nth highest salary from employee table with and without using the TOP/LIMIT keywords
  SELECT Salary FROM Employee E1
  WHERE N-1 = (
  SELECT COUNT( DISTINCT (
  E2.Salary ) )
  FROM Employee E2
  WHERE E2.Salary > E1.Salary );
  --- OR ---
  SELECT Salary FROM Employee E1
  WHERE N = (
  SELECT COUNT( DISTINCT (
  E2.Salary ) )
  FROM Employee E2
  WHERE E2.Salary >= E1.Salary );

--Q7(a): Write a query to find and remove duplicate records from a table.
  SELECT EmpID, EmpName, gender, Salary,
  city, COUNT(*) AS duplicate_count
  FROM Employee
  GROUP BY EmpID, EmpName, gender, Salary, city
  HAVING COUNT(*) > 1;
 
/*Q8: Show the employee with the highest salary for each project */
  SELECT ed.Project, MAX(e.Salary) AS ProjectSal
  FROM Employee e
  INNER JOIN EmployeeDetail ed ON e.EmpID = ed.EmpID
  GROUP BY ed.Project
  ORDER BY ProjectSal DESC;

--Q9: Query to find the total count of employees joined each year
  SELECT 
      EXTRACT(YEAR FROM ed.doj) AS JoinYear, 
      COUNT(*) AS EmpCount
  FROM Employee e
  INNER JOIN EmployeeDetail ed ON e.EmpID = ed.EmpID
  GROUP BY EXTRACT(YEAR FROM ed.doj)
  ORDER BY JoinYear ASC;

--Q10: Create 3 groups based on salary col, salary less than 1L is low, between 1 - 2L is medium and above 2L is High
SELECT EmpName, Salary,
CASE
WHEN Salary > 200000 THEN 'High'
WHEN Salary >= 100000 AND Salary <= 200000 THEN
'Medium'
ELSE 'Low'
END AS SalaryStatus
FROM Employee

 /* Q11: Query to pivot the data in the Employee table and retrieve the total salary for each city.
The result should display the EmpID, EmpName, and separate columns for
each city (Mathura, Pune, Delhi), containing the corresponding total salary. */
  SELECT
  EmpID,
  EmpName,
  SUM(CASE WHEN City = 'Mathura' THEN Salary END) AS "Mathura",
  SUM(CASE WHEN City = 'Pune' THEN Salary END) AS "Pune",
  SUM(CASE WHEN City = 'Delhi' THEN Salary END) AS "Delhi"
  FROM Employee
  GROUP BY EmpID, EmpName;



