-- MODULE 7 CHALLENGE

-- Deliverable 1: The Number of Retiring Employees by Title --
SELECT emp.emp_no,
    emp.first_name,
	emp.last_name,
    tit.title,
    tit.from_date,
	tit.to_date
INTO retirement_titles
FROM employees as emp
INNER JOIN titles as tit
ON (emp.emp_no = tit.emp_no)
WHERE (emp.birth_date between '1952-01-01' and '1955-01-01')
ORDER by emp.emp_no; 

SELECT * FROM retirement_titles;

-- use Dictinct[sic] with Orderby to remove duplicate rows
SELECT DISTINCT ON (retit.emp_no) retit.emp_no,
	retit.first_name,
	retit.last_name,
	retit.title
INTO retirement_titles_DISTINCT
FROM retirement_titles as retit
WHERE (retit.to_date = '9999-01-01')
ORDER BY retit.emp_no, retit.to_date DESC;

SELECT * FROM retirement_titles_DISTINCT;

ALTER TABLE retirement_titles_DISTINCT 
RENAME TO unique_titles;

SELECT * FROM unique_titles;


--  retrieve the number of employees by their most recent job title who are about to retire
SELECT COUNT(unique_titles.title), unique_titles.title
INTO retiring_titles
FROM unique_titles 
GROUP by unique_titles.title
ORDER by COUNT(unique_titles.title) desc; 

SELECT * FROM retiring_titles;


-- Deliverable 2: The Employees Eligible for the Mentorship Program --
--create a mentorship-eligibility table that holds the current employees who were born between January 1, 1965 and December 31, 1965.
SELECT DISTINCT ON (emp.emp_no) emp.emp_no,
		emp.first_name,
		emp.last_name,
		emp.birth_date,
		depemp.from_date,
		depemp.to_date,
		tit.title
INTO mentorship_elegibility
FROM employees as emp
LEFT JOIN dept_emp as depemp
ON (emp.emp_no = depemp.emp_no)
LEFT JOIN titles as tit
ON (tit.emp_no = emp.emp_no)
WHERE (emp.birth_date between '1965-01-01' AND '1965-12-31')
ORDER by emp.emp_no;

SELECT * FROM mentorship_elegibility;


-- ADDITIONAL QUERY 1: All employees by title
SELECT emp.emp_no,
    emp.first_name,
	emp.last_name,
    tit.title,
    tit.from_date,
	tit.to_date
INTO all_titles
FROM employees as emp
INNER JOIN titles as tit
ON (emp.emp_no = tit.emp_no)
ORDER by emp.emp_no; 

SELECT COUNT(all_titles.title), all_titles.title
INTO summary_titles
FROM all_titles 
GROUP by all_titles.title
ORDER by COUNT(all_titles.title) desc; 

SELECT * FROM summary_titles;



-- ADDITIONAL QUERY 2: All employees by Birth Date
SELECT DISTINCT ON (emp.emp_no) emp.emp_no,
		emp.first_name,
		emp.last_name,
		emp.birth_date,
INTO all_birthdates
FROM employees as emp
ORDER by emp.emp_no;

SELECT COUNT(all_birthdates.birth_date), all_birthdates.birth_date
INTO summary_birthdate
FROM all_birthdates 
GROUP by all_birthdates.birth_date
ORDER by COUNT(all_birthdates.birth_date) desc; 

SELECT * FROM summary_birthdate;

