Module 7: Deliverable 3
# PH-Analysis

## Overview of Project
This project represents a series of analytical database queries written in SQL and executed through Postgres in the pgAdmin 4 environment.  The database in question was populated by a series of .csv documents containing various information on employees of a fictional company.  To help structure the queries and the tables they produced, an ETL (entity relationship diagram) was built and periodically referenced according the key elements shared across documents. 
[INSERT ETL]

### Purpose
The purpose of this project was to asses the potential for a sudden wave of retirements within the company in the near future by compiling a list of such and their titles, as well as to identify employees who might constitute prime candidates for mentorship.  

## Results
The two major queries performed for this project and their results are described below:

### The Number of Retiring Employees by Title
Assuming that employees born between the years 1952 and 1955 will be retiring soon, a table was queried to capture those employees which fit that description at the company.  This involved 'joining' multiple existing tables along common key elements -- in this case, the "employee number" values.  
```
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
```
Noting the presence of duplicate rows in the data, the 'distinct on' statement was employed to eliminate these, and the 'order by' command used to restructure the resulting date into a more legible format.
```
SELECT DISTINCT ON (retit.emp_no) retit.emp_no,
	retit.first_name,
	retit.last_name,
	retit.title
INTO retirement_titles_DISTINCT
FROM retirement_titles as retit
WHERE (retit.to_date = '9999-01-01')
ORDER BY retit.emp_no, retit.to_date DESC;
```
With the table properly queried and formatted, the 'count' function was used to enumerate impending retirees by their most recent job title. 
```
SELECT COUNT(unique_titles.title), unique_titles.title
INTO retiring_titles
FROM unique_titles 
GROUP by unique_titles.title
ORDER by COUNT(unique_titles.title) desc; 
```
The results of this analysis were as seen in the sample below:
[INSERT RETIRING_TITLES]

### The Employees Eligible for the Mentorship Program
Assuming that employees born in the year 1965 constitute prime candidates for enrollment into a mentorship program within the company, a table was queried to capture those employees which fit that description.  This also involved 'joining' multiple existing tables along common key elements, and again in this case that element was the "employee number" values.  
```
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
```
The results of this analysis were as seen in the sample below:
[INSERT MENTORSHIP_ELIGIBILITY]

## Summary  

### "How many roles will need to be filled as the "silver tsunami" begins to make an impact?"
The final results of this project's queries showed that -- of those individuals currently employed by the company -- 53,977 are approaching retirement, the significant majority of which currently hold the titles of "Senior Engineer" or "Senior Staff". 

### "Are there enough qualified, retirement-ready employees in the departments to mentor the next generation of Pewlett Hackard employees?"
Only 1,940 individuals currently employed at the company are projected as eligible for the mentorship program, indicating a problematic gap between the number of potential mentors and the number of positions which will need to be filled in the wake of mass retirings. 

### Additional Queries and Tables

#### Example 1: All Employees by Title
To provide a clearly picture of the company's current composition in terms of employee titles, it would be useful to generate a table displaying a full breakdown the currently filled positions within the company.  This can be accomplished using the code below:
```
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
```
This produces the table seen below, which can be compared to the Mentorship Eligibility table for reference.  
[INSERT SUMMARY_TITLES]

#### Example 2: 
