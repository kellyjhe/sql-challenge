-- Create tables
CREATE TABLE departments (
	dept_no VARCHAR(30) PRIMARY KEY,
	dept_name VARCHAR(30) NOT NULL
);

CREATE TABLE employees (
	emp_no SERIAL PRIMARY KEY,
	emp_title_id VARCHAR(30) NOT NULL,
	birth_date VARCHAR(30) NOT NULL,
	first_name VARCHAR(30) NOT NULL,
	last_name VARCHAR(30) NOT NULL,
	sex VARCHAR(30) NOT NULL,
	hire_date VARCHAR(30) NOT NULL
);

CREATE TABLE dept_emp (
	emp_no INTEGER NOT NULL,
	dept_no VARCHAR(30) NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no)
);

CREATE TABLE dept_manager (
	dept_no VARCHAR(30) NOT NULL,
	emp_no INTEGER NOT NULL,
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);

CREATE TABLE salaries (
	emp_no INTEGER NOT NULL,
	salary INTEGER NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);

CREATE TABLE titles (
	title_id VARCHAR(30) PRIMARY KEY,
	title VARCHAR(30) NOT NULL
);

-- Populate tables
COPY departments (dept_no, dept_name) 
FROM '/Users/kellyhe/departments.csv' 
DELIMITER ','
CSV HEADER;

COPY employees (emp_no, emp_title_id, birth_date, first_name, last_name, sex, hire_date)
FROM '/Users/kellyhe/Bootcamp_Homework/sql-challenge/data/employees.csv'
DELIMITER ','
CSV HEADER;

COPY dept_emp (emp_no, dept_no)
FROM '/Users/kellyhe/Bootcamp_Homework/sql-challenge/data/dept_emp.csv'
DELIMITER ','
CSV HEADER;

COPY dept_manager (dept_no, emp_no)
FROM '/Users/kellyhe/Bootcamp_Homework/sql-challenge/data/dept_manager.csv'
DELIMITER ','
CSV HEADER;

COPY salaries (emp_no, salary)
FROM '/Users/kellyhe/Bootcamp_Homework/sql-challenge/data/salaries.csv'
DELIMITER ','
CSV HEADER;

COPY titles (title_id, title)
FROM '/Users/kellyhe/Bootcamp_Homework/sql-challenge/data/titles.csv'
DELIMITER ','
CSV HEADER;

-- 1. List the employee number, last name, first name, sex, and salary of each employee.
SELECT employees.emp_no, employees.last_name, employees.first_name, employees.sex, salaries.salary
FROM employees
LEFT JOIN salaries
ON salaries.emp_no = employees.emp_no;

-- 2. List the first name, last name, and hire date for the employees who were hired in 1986.
SELECT first_name, last_name, hire_date
FROM employees
WHERE EXTRACT(YEAR FROM TO_DATE(hire_date, 'MM/DD/YYYY')) = 1986;

-- 3. List the manager of each department along with their department number, department name, employee number, last name, and first name.
SELECT dept_manager.emp_no, dept_manager.dept_no, departments.dept_name, dept_manager.emp_no, employees.last_name, employees.first_name
FROM departments
JOIN dept_manager ON dept_manager.dept_no = departments.dept_no
JOIN employees ON dept_manager.emp_no = employees.emp_no;

-- 4. List the department number for each employee along with that employee’s employee number, last name, first name, and department name.
SELECT dept_emp.dept_no, dept_emp.emp_no, employees.last_name, employees.first_name, departments.dept_name
FROM departments
JOIN dept_emp ON dept_emp.dept_no = departments.dept_no
JOIN employees ON dept_emp.emp_no = employees.emp_no;

-- 5. List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B.
SELECT first_name, last_name, sex
FROM employees
WHERE first_name = 'Hercules' AND last_name LIKE 'B%';

-- 6. List each employee in the Sales department, including their employee number, last name, and first name.
SELECT dept_emp.emp_no, employees.last_name, employees.first_name
FROM employees
JOIN dept_emp ON dept_emp.emp_no = employees.emp_no
JOIN departments ON departments.dept_no = dept_emp.dept_no
WHERE departments.dept_name = 'Sales';

-- 7. List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name.
SELECT dept_emp.emp_no, employees.last_name, employees.first_name, departments.dept_name
FROM employees
JOIN dept_emp ON dept_emp.emp_no = employees.emp_no
JOIN departments ON departments.dept_no = dept_emp.dept_no
WHERE departments.dept_name = 'Sales' OR departments.dept_name = 'Development';

-- 8. List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name).
SELECT last_name, COUNT(*) AS frequency
FROM employees
GROUP BY last_name
ORDER BY frequency DESC;