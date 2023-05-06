-- Table Creation

-- Departments Table

CREATE TABLE Departments (
    department_id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

-- Employees Table

CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    hire_date DATE NOT NULL,
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);


-- Salaries Table

CREATE TABLE Salaries (
    employee_id INT,
    salary DECIMAL(10, 2) NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE,
    PRIMARY KEY (employee_id, from_date),
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id)
);


-- Data Insertion

-- Departments

INSERT INTO Departments (department_id, name) VALUES
(1, 'Sales'),
(2, 'Marketing'),
(3, 'Engineering'),
(4, 'Finance');


-- Employees

INSERT INTO Employees (employee_id, first_name, last_name, email, hire_date, department_id) VALUES
(1, 'John', 'Doe', 'john.doe@example.com', '2022-01-01', 1),
(2, 'Jane', 'Doe', 'jane.doe@example.com', '2022-02-01', 1),
(3, 'Alice', 'Smith', 'alice.smith@example.com', '2022-03-01', 2),
(4, 'Bob', 'Johnson', 'bob.johnson@example.com', '2022-04-01', 2);


-- Salaries

INSERT INTO Salaries (employee_id, salary, from_date, to_date) VALUES
(1, 50000, '2022-01-01', '2022-12-31'),
(2, 60000, '2022-02-01', '2022-12-31'),
(3, 70000, '2022-03-01', '2022-12-31'),
(4, 80000, '2022-04-01', '2022-12-31');


-- Queries

-- The first name, last name, email, department name, and salary of all employees who work in the Sales department.

SELECT 
    e.first_name,
    e.last_name,
    e.email,
    d.name AS department_name,
    s.salary
FROM 
    Employees e
JOIN Departments d ON e.department_id = d.department_id
JOIN Salaries s ON e.employee_id = s.employee_id
WHERE 
    d.name = 'Sales';

-- Average salary of all employees in the company.

SELECT 
    AVG(salary) AS average_salary
FROM 
    Salaries;


-- Department name with the highest average salary.

SELECT 
    d.name AS department_name,
    AVG(s.salary) AS average_salary
FROM 
    Employees e
JOIN Salaries s ON e.employee_id = s.employee_id
JOIN Departments d ON e.department_id = d.department_id
GROUP BY 
    d.department_id,
    d.name
ORDER BY 
    average_salary DESC
LIMIT 1;


-- First name, last name, email, and total salary of all employees hired in 2022.

SELECT 
    e.first_name,
    e.last_name,
    e.email,
    s.salary AS total_salary
FROM 
    Employees e
JOIN Salaries s ON e.employee_id = s.employee_id
WHERE 
    strftime('%Y', e.hire_date) = '2022';

-- First name, last name, email, and salary of the employee with the highest salary.

SELECT 
    e.first_name,
    e.last_name,
    e.email,
    s.salary
FROM 
    Employees e
JOIN Salaries s ON e.employee_id = s.employee_id
ORDER BY 
    s.salary DESC
LIMIT 1;

-- First name,last name and email of employee which department name contains with "ng"

SELECT 
    e.first_name,
    e.last_name,
    e.email
FROM 
    Employees e
JOIN Departments d ON e.department_id = d.department_id
WHERE 
    d.name LIKE '%ng%';

