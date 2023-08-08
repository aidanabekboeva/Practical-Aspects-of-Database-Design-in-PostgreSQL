DROP TABLE IF EXISTS department;
DROP TABLE IF EXISTS employee;

CREATE TABLE department (department_id VARCHAR (255) PRIMARY KEY, 
						 department_name VARCHAR (255));
						 
CREATE TABLE employee ( employee_id INT PRIMARY KEY, 
					   employee_name VARCHAR (255), 
					   employee_salary INT NOT NULL, 
					   department_id VARCHAR (255), 
				FOREIGN KEY (department_id) REFERENCES department (department_id) ON DELETE SET NULL);
					   
INSERT INTO department
VALUES (1, 'IT'),
(2, 'Sales');
INSERT INTO employee
VALUES (1, 'Joe', 85000, 1),
	   (2, 'Henry', 80000, 2), 
	   (3, 'Sam', 60000, 2), 
	   (4, 'Max', 90000, 1), 
	   (5, 'Janet', 69000, 1), 
	   (6, 'Randy', 85000, 1), 
	   (7, 'Will', 70000, 1);		 
	   
SELECT * FROM department;
SELECT * FROM employee;
					  
					  
SELECT a.department_name AS "Department", 
       b.employee_name AS "Employee", 
	   b.employee_salary
FROM Department a
LEFT JOIN Employee b
ON a. department_id = b.department_id
WHERE (SELECT count (DISTINCT employee_salary) FROM Employee
	   WHERE department_id = a.department_id and employee_salary > b.employee_salary) < 3
AND b.employee_salary IS NOT NULL;		

