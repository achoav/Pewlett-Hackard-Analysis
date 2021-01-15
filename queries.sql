-- Retirement Eligibility 7.3.1

-- From January 1st, 1952 to December 31st, 1955 (90,398)
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31'

-- From January 1st, 1952 to December 31st, 1952 (21,209)
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31'

-- Retirement Eligibility 7.3.1
-- From January 1st, 1953 to December 31st, 1953 (22,857)
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31'

-- From January 1st, 1954 to December 31st, 1954 (23,228)
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31'

-- From January 1st, 1955 to December 31st, 1955 (23,104)
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1955-01-01' AND '1955-12-31'

-- Query to include a specific hiring range (41,380). This time, we're looking for employees born between 1952 and 1955, who were also hired between 1985 and 1988
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Count querie. # of employees retiring
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- 41380

-- Save the information into a table called "retirement_info".  Function "INTO". Now we will have 7 tables instead of 6 tables
SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
SELECT * FROM retirement_info;

-- Section 7.3.2. Drop "retirement_info" as we need to create a new table with emp_no
DROP TABLE retirement_info;

-- Create new table for retiring employees, and add on the SELECT function to include 'emp_no'
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check the table
SELECT * FROM retirement_info;


-- Section 7.3.3 Joining 'departments' and 'dept_manager' tables via INNER JOIN
-- i.e. SIMPLE JOIN, will return matching data from two tables
-- Fields we want to see in the new table are: dept_name, emp_no, from_date, to_date
-- FROM points to Table1 => departments and create ALIAS d
-- INNER JOIN points to Table2 => dept_manager and create ALIAS dm

SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments AS d
INNER JOIN dept_manager AS dm
ON d.dept_no = dm.dept_no;


-- Section 7.3.3. Use Left Join for retirement_info and dept_emp tables. 
-- fully accurate retirement_info table: Employee number/Employee name (first and last)/If the person is presently employed with PH
-- Joining retirement_info and dept_emp tables. Using LEFT JOIN, that will tell us if the employee is still working at the company with 
-- "to_date" field
-- Creating alias for ri=retirement_info and de=dept_emp
-- For current employees, we need to add a filter, using the WHERE keyword and the date 9999-01-01
DROP TABLE current_emp CASCADE;
SELECT ri.emp_no,
    ri.first_name,
    ri.last_name,
    de.to_date
INTO current_emp
FROM retirement_info AS ri
LEFT JOIN dept_emp AS de
ON ri.emp_no = de.emp_no
WHERE (de.to_date = '9999-01-01');
SELECT * FROM current_emp;

-- Section 7.3.4. Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;
-- Output is 2,234 on department No. 006

-- Section 7.3.5
SELECT * FROM salaries
ORDER BY to_date DESC;

-- Section 7.3.5 Create table of retiring employees info INTO "emp_info"
SELECT employees.emp_no, 
	employees.first_name, 
	employees.last_name,
	employees.gender
INTO emp_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check the table
SELECT * FROM emp_info;

-- Section 7.3.5. - List 1 - Create emp_info table with full name, gender, salary, to_date
DROP TABLE emp_info CASCADE;
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	e.gender,
	s.salary,
	de.to_date
INTO emp_info
FROM employees AS e
INNER JOIN salaries AS s
ON e.emp_no = s.emp_no
INNER JOIN dept_emp as de
ON e.emp_no = de.emp_no
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
AND (de.to_date = '9999-01-01');

-- Section 7.3.5 - List 2 - Create managers list
DROP TABLE manager_info CASCADE;
SELECT dm.dept_no,
	d.dept_name,
	dm.emp_no,
	ce.last_name,
	ce.first_name,
	dm.from_date,
	dm.to_date
INTO manager_info
FROM dept_manager AS dm
	INNER JOIN departments AS d
		ON dm.dept_no = d.dept_no
	INNER JOIN current_emp as ce
		ON dm.emp_no = ce.emp_no;

-- Section 7.3.5 - List 3 -List of retirees updated
SELECT ce.emp_no,
	ce.first_name,
	ce.last_name,
	d.dept_name
INTO dept_info
FROM current_emp AS ce
	INNER JOIN dept_emp AS de
		ON ce.emp_no = de.emp_no
	INNER JOIN departments AS d
		ON de.dept_no = d.dept_no;

-- Section 7.3.6 - List 1 - Create retirement_info list for sales team
SELECT ri.*, d.dept_name
INTO sales_info
FROM retirement_info as ri
	INNER JOIN dept_emp AS de
		ON ri.emp_no = de.emp_no
	INNER JOIN departments AS d
		ON de.dept_no = d.dept_no
WHERE d.dept_name = 'Sales';

-- Section 7.3.6 - List 2 - Create retirement_info list for sales and development team
SELECT ri.*, d.dept_name
INTO sales_dev_info
FROM retirement_info as ri
	INNER JOIN dept_emp AS de
		ON ri.emp_no = de.emp_no
	INNER JOIN departments AS d
		ON de.dept_no = d.dept_no
WHERE d.dept_name IN ('Sales', 'Development');

SELECT e.emp_no,
	e.first_name,
	e.last_name,
	ti.title,
	ti.from_date,
	ti.to_date
INTO retirement_titles
FROM employees AS e
	INNER JOIN titles AS ti
		ON e.emp_no = ti.emp_no
WHERE e.birth_date BETWEEN '1952-01-01' AND '1955-12-31'
ORDER BY e.emp_no;

-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (emp_no) emp_no,
first_name,
last_name,
title
INTO unique_titles
FROM retirement_titles
ORDER BY emp_no, to_date DESC;

-- Retiring titles count
SELECT COUNT(title), title
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY count DESC;

-- retirement count per department
SELECT DISTINCT ON (ut.emp_no) ut.*, d.dept_name
INTO unique_titles_depts
FROM unique_titles AS ut
	INNER JOIN dept_emp AS de
		ON ut.emp_no = de.emp_no
	INNER JOIN departments AS d
		ON de.dept_no = d.dept_no;

-- Retiring titles count per department
SELECT COUNT(dept_name), dept_name
INTO retiring_dept
FROM unique_titles_depts
GROUP BY dept_name
ORDER BY count DESC;

-- eligible  mentors with department
SELECT DISTINCT ON (me.emp_no) me.*, d.dept_name
INTO mentorship_eligibility_depts
FROM mentorship_eligibility AS me
	INNER JOIN dept_emp AS de
		ON me.emp_no = de.emp_no
	INNER JOIN departments AS d
		ON de.dept_no = d.dept_no;






