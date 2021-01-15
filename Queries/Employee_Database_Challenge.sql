-- 1. Retrieve the emp_no, first_name, and last_name columns from the Employees table.
-- 2. Retrieve the title, from_date, and to_date columns from the Titles table.
-- 3. Create a new table using the INTO clause 'retirement_titles'
-- 4. Join both tables by the prirmary key. Join table 'employees' (e) to table 'titles' (ti)
-- 5. Filter the data on e.birth_data were born between 1952 and 1955. The order by e.emp_no
-- 6. Export the 'retirement_titles' table from the previous step and save into your Data Folder
-- Retirement titles - 'retirement_titles.csv'
DROP TABLE retirement_titles CASCADE;
DROP TABLE unique_titles CASCADE;
DROP TABLE retiring_titles CASCADE;
DROP TABLE mentorship_eligibility CASCADE;

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

-- Unique Retirement titles - 'unique_titles.csv'
-- 9. Retrieve emp_no, first_name, last_name from 'retirement_titles' into 'unique_titles'
-- 10. Use Dictinct with Orderby to remove duplicate rows
-- 11. Export the 'unique_titles' table from the previous step and save into your Data Folder
SELECT DISTINCT ON (emp_no) emp_no,
first_name,
last_name,
title
INTO unique_titles
FROM retirement_titles
ORDER BY emp_no, to_date DESC;

-- Retiring titles count - 'retiring_titles.csv'
-- 16. First, retrieve the number of titles from the 'unique_titles' table. Use the function COUNT(title)
-- 17. Then, create a 'retiring_titles' table to hold the required information.
-- 18. Group the table by title, then sort the count column in descending

SELECT COUNT(title), title
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY count DESC;

-- Create a mentorship eligibility table - 'mentorship_eligibility.csv'
SELECT DISTINCT ON(e.emp_no) e.emp_no,
	e.first_name, 
	e.last_name, 
	e.birth_date,
	de.from_date,
	de.to_date,
	ti.title
INTO mentorship_eligibility
FROM employees AS e
	INNER JOIN dept_emp AS de
		ON e.emp_no = de.emp_no
	INNER JOIN titles AS ti
		ON e.emp_no = ti.emp_no
WHERE de.to_date = '9999-01-01'
AND e.birth_date BETWEEN '1965-01-01' AND '1965-12-31'
ORDER BY e.emp_no;