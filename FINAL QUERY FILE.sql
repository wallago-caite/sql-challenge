---CREATE TABLES WITH COLUMNS ASSOCIATED using QUICKDBD
---IMPORT THE DATA FROM CSVS AFTER CREATED(manually)
-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.

drop table if exists titles;
drop table if exists employees;
drop table if exists departments;
drop table if exists salaries;
drop table if exists dept_manager;
drop table if exists dept_emp;

CREATE TABLE "titles" (
    "title_id" char(5)   NOT NULL,
    "title" varchar(40)   NOT NULL,
    CONSTRAINT "pk_titles" PRIMARY KEY (
        "title_id"
     )
);

CREATE TABLE "employees" (
    "emp_no" int   NOT NULL,
    "emp_title_id" char(5)   NOT NULL,
    "birth_date" date   NOT NULL,
    "first_name" varchar(40)   NOT NULL,
    "last_name" varchar(40)   NOT NULL,
    "sex" char(1)   NOT NULL,
    "hire_date" date   NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "departments" (
    "dept_no" char(4)   NOT NULL,
    "dept_name" varchar(40)   NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE "salaries" (
    "emp_no" int   NOT NULL,
    "salary" int   NOT NULL,
    CONSTRAINT "pk_salaries" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "dept_manager" (
    "dept_no" char(4)   NOT NULL,
    "emp_no" int   NOT NULL,
    CONSTRAINT "pk_dept_manager" PRIMARY KEY (
        "emp_no"
     )
);

drop table if exists dept_emp;
CREATE TABLE "dept_emp" (
    "emp_no" int   NOT NULL,
    "dept_no" char(4)   NOT NULL,
    CONSTRAINT "pk_dept_emp" PRIMARY KEY (
        "emp_no","dept_no"
     )
);



ALTER TABLE "employees" ADD CONSTRAINT "fk_employees_emp_title_id" FOREIGN KEY("emp_title_id")
REFERENCES "titles" ("title_id");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");




---QUESTION 1 List the employee number, last name, first name, sex, and salary of each employee.

select emp.emp_no , emp.last_name , emp.first_name , emp.sex , sal.salary 
from employees as emp
left join salaries as sal
on emp.emp_no = sal.emp_no 
;

--joins salary and employee table


---QUESTION 2 List the first name, last name, and hire date for the employees who were hired in 1986.
select first_name, last_name, hire_date
from employees
where hire_date between '01/01/1986' and '12/31/1986'
;


---QUESTION 3 List the manager of each department along with their department number, department name, employee number, last name, and first name.
select d.dept_no, d.dept_name, e.emp_no, e.last_name, e.first_name
from departments d 
join dept_manager dm on d.dept_no = dm.dept_no 
join employees e on dm.emp_no = e.emp_no 
;

---QUESTION 4 List the department number for each employee along with that employee’s employee number, last name, first name, and department name.
select d.dept_no, d.dept_name, e.emp_no, e.last_name, e.first_name
from departments d 
join dept_emp de on d.dept_no = de.dept_no 
join employees e on de.emp_no = e.emp_no 
;


---QUESTION 5 List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B.
select first_name, last_name, sex
from employees e
where first_name = 'Hercules' and last_name like 'B%'
;

---QUESTION 6 List each employee in the Sales department, including their employee number, last name, and first name.
select d.dept_name, e.emp_no, e.last_name, e.first_name
from departments d 
join dept_emp de on d.dept_no = de.dept_no 
join employees e on de.emp_no = e.emp_no 
where d.dept_name = 'Sales'
;

---QUESTION 7 List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name.
select d.dept_name, e.emp_no, e.last_name, e.first_name
from departments d 
join dept_emp de on d.dept_no = de.dept_no 
join employees e on de.emp_no = e.emp_no 
where d.dept_name in ('Sales','Development')
;

---QUESTION 8 List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name).
select last_name, count(*) as lncount
from employees e 
group by last_name
order by lncount desc
;


