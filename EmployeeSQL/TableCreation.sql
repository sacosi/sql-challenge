--Drop all tables to run from scratch
DROP TABLE IF EXISTS employees, departments, titles, salaries, dept_emp, dept_manager;

--Create the tables according to the CSV files

--Employees Table
CREATE TABLE employees(
	emp_no INT,
	birth_date DATE,
	first_name VARCHAR,
	last_name VARCHAR,
	gender CHAR(1),
	hire_date DATE,
	PRIMARY KEY (emp_no)
);

----Departments Table
CREATE TABLE departments(
	dept_no CHAR(4),
	dept_name VARCHAR,
	PRIMARY KEY (dept_no)
);

--Titles Table
CREATE TABLE titles(
	emp_no INT,
	title VARCHAR,
	from_date DATE,
	to_date DATE,
	FOREIGN KEY(emp_no) REFERENCES employees(emp_no),
	CONSTRAINT PK_titles PRIMARY KEY (emp_no,from_date)
);

--Salaries Table
CREATE TABLE salaries(
	emp_no INT,
	salary DECIMAL(13, 4),
	from_date DATE,
	to_date DATE,
	FOREIGN KEY(emp_no) REFERENCES employees(emp_no),
	CONSTRAINT PK_salaries PRIMARY KEY (emp_no,from_date)
);

--Department/Employee Table
CREATE TABLE dept_emp(
	emp_no INT,
	dept_no CHAR(4),
	from_date DATE,
	to_date DATE,
	FOREIGN KEY(emp_no) REFERENCES employees(emp_no),
	FOREIGN KEY(dept_no) REFERENCES departments(dept_no),
	CONSTRAINT PK_dept_emp PRIMARY KEY (emp_no, dept_no, from_date)
);

--Department/Manager Table
CREATE TABLE dept_manager(
	dept_no CHAR(4),
	emp_no INT,
	from_date DATE,
	to_date DATE,
	FOREIGN KEY(emp_no) REFERENCES employees(emp_no),
	FOREIGN KEY(dept_no) REFERENCES departments(dept_no),
	CONSTRAINT PK_dept_manager PRIMARY KEY (dept_no,from_date)
);