-- Data Analytics

-- QUESTION 1 - List the following details of each employee: employee number, last name, first name, gender, and salary.
SELECT e.emp_no "Employee ID", e.last_name "Last Name", e.first_name "First Name", e.gender "Gender", s.salary::money "Salary"
FROM employees e
JOIN salaries s
ON e.emp_no=s.emp_no
ORDER BY 1;


-- QUESTION 2 - List employees who were hired in 1986.
SELECT emp_no "Employee ID", last_name "Last Name", first_name "First Name", gender "Gender", TO_CHAR(hire_date :: DATE, 'MM/DD/yyyy') "Hire Date"
FROM employees
WHERE EXTRACT(YEAR FROM hire_date) = 1986
ORDER BY 1


-- QUESTION 3 - List the manager of each department with the following information: department number, department name, the manager's employee number, last name, first name, and start and end employment dates.
-- My first thought is to query only the current manager of each department. here is the query for that:
SELECT dm.dept_no "Department ID", max_dept.dept_name "Department Name", e.emp_no "Employee ID", e.last_name "Last Name", 
        e.first_name "First Name", dm.from_date "Start Date",dm.to_date "End Date"
FROM dept_manager dm,
	(SELECT d.dept_no, dept_name, MAX(dm.to_date) to_date
	FROM dept_manager dm, departments d
    WHERE dm.dept_no=d.dept_no
	GROUP BY d.dept_no, dept_name) max_dept, 
    employees e
WHERE dm.dept_no=max_dept.dept_no
AND dm.to_date=max_dept.to_date
AND dm.emp_no=e.emp_no
ORDER BY 1

-- The question could also be to query all historic data about each department's managers. 
-- (i.e.: For each departmenent, show all the employees that have managed that department)
SELECT dm.dept_no "Department ID", d.dept_name "Department Name", e.emp_no "Employee ID", e.last_name "Last Name", 
		e.first_name "First Name", dm.from_date "Start Date",dm.to_date "End Date"
FROM employees e
LEFT JOIN dept_manager dm
ON e.emp_no=dm.emp_no
Join departments d
ON dm.dept_no=d.dept_no
ORDER BY 1, 7 DESC


-- QUESTION 4 - List the department of each employee with the following information: employee number, last name, first name, and department name.
-- The goal of this question could be to know the department that each of the employees was working for when this document was "live":
SELECT e.emp_no "Employee ID", e.last_name "Last Name", e.first_name "First Name", d.dept_name "Department"
FROM employees e
JOIN dept_emp de
ON e.emp_no=de.emp_no
JOIN departments d
ON de.dept_no=d.dept_no
WHERE de.to_date >= CURRENT_DATE		-- Current date because if the employee was working at the time at a specific department the to_date was "9999-01-01"
ORDER BY 1;

--Or could be to list all the employees and all teh departments they have worked for:
SELECT e.emp_no "Employee ID", e.last_name "Last Name", e.first_name "First Name", d.dept_name "Department Name"
FROM employees e
LEFT JOIN dept_emp de
ON e.emp_no=de.emp_no
JOIN departments d
ON de.dept_no=d.dept_no
ORDER BY 1;


-- QUESTION 5 - List all employees whose first name is "Hercules" and last names begin with "B."
SELECT emp_no "Employee ID", first_name "First Name", last_name "Last Name" 
FROM employees
WHERE first_name = 'Hercules' AND last_name LIKE 'B%'
ORDER BY 1;


-- QUESTION 6 - List all employees in the Sales department, including their employee number, last name, first name, and department name.
-- This question also raises some doubts. If the request is to get all employees that have at some point worked in the Sales Department:
SELECT e.emp_no "Employee ID", e.last_name "Last Name", e.first_name "First Name", d.dept_name "Department"
FROM employees e
JOIN dept_emp de
ON e.emp_no=de.emp_no
JOIN departments d
ON de.dept_no=d.dept_no
WHERE d.dept_name = 'Sales'
ORDER BY 1;

-- However if the goal is to know the employees that were working in the sales department when this file was up to date:
SELECT e.emp_no "Employee ID", e.last_name "Last Name", e.first_name "First Name", d.dept_name "Department"
FROM employees e
JOIN dept_emp de
ON e.emp_no=de.emp_no
JOIN departments d
ON de.dept_no=d.dept_no
WHERE de.to_date >= CURRENT_DATE		-- Current date because if the employee was working at the time at a specific department the to_date was "9999-01-01"
AND d.dept_name = 'Sales'
ORDER BY 1;


-- QUESTION 7 - List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name.
-- This question also raises some doubts. If the request is to get all employees that have at some point worked in the Sales or Development Department:
SELECT e.emp_no "Employee ID", e.last_name "Last Name", e.first_name "First Name", d.dept_name "Department"
FROM employees e
JOIN dept_emp de
ON e.emp_no=de.emp_no
JOIN departments d
ON de.dept_no=d.dept_no
WHERE (d.dept_name = 'Sales' OR d.dept_name = 'Development')

-- However if the goal is to know the employees that were working in the sales or development department when this file was up to date:
SELECT e.emp_no "Employee ID", e.last_name "Last Name", e.first_name "First Name", d.dept_name "Department"
FROM employees e
JOIN dept_emp de
ON e.emp_no=de.emp_no
JOIN departments d
ON de.dept_no=d.dept_no
WHERE de.to_date >= CURRENT_DATE 	-- Current date because if the employee was working at the time at a specific department the to_date was "9999-01-01"
AND (d.dept_name = 'Sales' OR d.dept_name = 'Development')


-- QUESTION 8 - In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.
SELECT last_name "Last Name", count(emp_no) "Frequency"
FROM employees
GROUP BY last_name
ORDER BY 2 DESC