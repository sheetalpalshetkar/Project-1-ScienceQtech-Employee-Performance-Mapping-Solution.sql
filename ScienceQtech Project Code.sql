create database employee;

CREATE TABLE `employee`.`data_science_team` (
  `EMP_ID` VARCHAR(45) NOT NULL,
  `FIRST_NAME` VARCHAR(45) NOT NULL,
  `LAST_NAME` VARCHAR(45) NOT NULL,
  `GENDER` VARCHAR(45) NOT NULL,
  `ROLE` VARCHAR(45) NOT NULL,
  `DEPT` VARCHAR(45) NOT NULL,
  `EXP` VARCHAR(45) NOT NULL,
  `COUNTRY` VARCHAR(45) NOT NULL,
  `CONTINENT` VARCHAR(45) NOT NULL,
    PRIMARY KEY (`DEPT`));


CREATE TABLE `employee`.`proj_table` (
  `PROJ_ID` VARCHAR(45) NOT NULL,
  `PROJ_NAME` VARCHAR(45) NOT NULL,
  `DOMAIN` VARCHAR(45) NOT NULL,
  `START_DATE` DATE NOT NULL,
  `CLOSURE_DATE` DATE NOT NULL,
  `DEV_QTR` VARCHAR(45) NOT NULL,
  `STATUS` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`PROJ_ID`));


CREATE TABLE `employee`.`emp_record_table` (
  `EMP_ID` VARCHAR(45) NOT NULL,
  `FIRST_NAME` VARCHAR(45) NOT NULL,
  `LAST_NAME` VARCHAR(45) NOT NULL,
  `GENDER` CHAR(1) NOT NULL,
  `ROLE` VARCHAR(45) NOT NULL,
  `DEPT` VARCHAR(45) NOT NULL,
  `EXP` VARCHAR(45) NOT NULL,
  `COUNTRY` VARCHAR(45) NOT NULL,
  `CONTINENT` VARCHAR(45) NOT NULL,
  `SALARY` INT NOT NULL,
  `EMP_RATING` INT NOT NULL,
  `MANAGER_ID` VARCHAR(45) NOT NULL,
  `PROJ_ID` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`EMP_ID`),
  INDEX `PROJ_ID_IDX` (`PROJ_ID` ASC) INVISIBLE,
  INDEX `DEPT_IDX` (`DEPT` ASC) VISIBLE,
  CONSTRAINT `PROJ_ID`
    FOREIGN KEY (`PROJ_ID`)
    REFERENCES `employee`.`proj_table` (`PROJ_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `DEPT`
    FOREIGN KEY (`DEPT`)
    REFERENCES `employee`.`data_science_team` (`DEPT`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);



use employee;
select * from emp_record_table
# 1) Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, and DEPARTMENT from the employee record table, and make a list of employees and details of their department
select ï»¿EMP_ID, FIRST_NAME,LAST_NAME,GENDER,DEPT FROM emp_record_table order by ï»¿EMP_ID asc;
alter table emp_record_table change ï»¿EMP_ID EMP_ID varchar(45);
select EMP_ID, FIRST_NAME,LAST_NAME,GENDER,DEPT FROM emp_record_table order by EMP_ID asc;
# Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPARTMENT, and EMP_RATING if the EMP_RATING is less than 2: 
select EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING FROM emp_record_table where EMP_RATING < 2;
# Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPARTMENT, and EMP_RATING if the EMP_RATING is greater than 2: 
select EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING FROM emp_record_table where EMP_RATING > 2;
 #Between 2 & 4
 select EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING FROM emp_record_table where EMP_RATING > 2 and EMP_RATING < 4;
 # Write a query to concatenate the FIRST_NAME and the LAST_NAME of employees in the Finance department from the employee table and then give the resultant column alias as NAME
 select concat(FIRST_NAME, " ", LAST_NAME) as NAME FROM emp_record_table where DEPT = 'FINANCE';
 #4) Write a query to list only those employees who have someone reporting to them. Also, show the number of reporters (including the President)
 alter table emp_record_table change `MANAGER ID`  MANAGER_ID varchar(45);
SELECT MANAGER_ID, count(EMP_ID) 
FROM emp_record_table 
WHERE MANAGER_ID IS NOT NULL 
GROUP BY MANAGER_ID ORDER BY MANAGER_ID ASC;
#5) Write a query to list down all the employees from the healthcare and finance departments using union. Take data from the employee record table
SELECT * FROM emp_record_table WHERE DEPT = 'HEALTHCARE'
UNION
SELECT * FROM emp_record_table WHERE DEPT = 'FINANCE';
#6) Write a query to list down employee details such as EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPARTMENT, and EMP_RATING grouped by dept
SELECT EMP_ID, FIRST_NAME, LAST_NAME, `ROLE`, DEPT, EMP_RATING, AVG(EMP_RATING) 
FROM emp_record_table GROUP BY DEPT;
SELECT MAX(EMP_ID) as EMP_ID, MAX(FIRST_NAME) as FIRST_NAME, MAX(LAST_NAME) as LAST_NAME, 
       MAX(`ROLE`) as `ROLE`, DEPT, AVG(EMP_RATING) 
FROM emp_record_table 
GROUP BY DEPT
LIMIT 0, 1000;
#7) Write a query to calculate the minimum and the maximum salary of the employees in each role
SELECT role, min(EMP_RATING), max(EMP_RATING) FROM emp_record_table GROUP BY `ROLE`;
#8) Write a query to assign ranks to each employee based on their experience
SELECT EMP_ID, FIRST_NAME, LAST_NAME, EXP, rank() OVER (ORDER BY exp DESC) AS 'Rank' 
FROM emp_record_table;
#9) Write a query to create a view that displays employees in various countries whose salary is more than six thousand
CREATE VIEW Test AS SELECT EMP_ID, FIRST_NAME, LAST_NAME, COUNTRY, SALARY 
FROM emp_record_table WHERE SALARY > 6000;
#10) Write a nested query to find employees with experience of more than ten years
SELECT * FROM Test;
SELECT * FROM (SELECT * FROM emp_record_table WHERE exp>10) AS tab;
#Write a query to create a stored procedure to retrieve the details of the employees whose experience is more than three years
DELIMITER //
CREATE PROCEDURE 3PlusExp() 
BEGIN 
SELECT *  FROM emp_record_table WHERE EXP>3;
END //
delimiter ;
Call 3PlusExp();
#Write a query using stored functions in the project table to check whether the job profile assigned to each employee in the data science team matches the organization’s set standard
delimiter $$
CREATE FUNCTION check_job_role(EXP integer)
RETURNS VARCHAR(40)
DETERMINISTIC
BEGIN
DECLARE chck VARCHAR(40);
if EXP < 2 THEN SET chck = "JUNIOR DATA SCIENTIST";
elseif EXP >=2 AND EXP < 5 THEN SET chck = "ASSOCIATE DATA SCIENTIST";
elseif EXP >=5 AND EXP < 10 THEN SET chck = "SENIOR DATA SCIENTIST";
elseif EXP >= 10 AND EXP < 12 THEN SET chck = "LEAD DATA SCIENTIST";
elseif EXP >= 12 THEN SET chck = "MANAGER";
end if; RETURN (chck);
END $$
delimiter ;
#Checking Data Science TEAM
alter table data_science_team change `ï»¿EMP_ID`  EMP_ID varchar(45);
SELECT EMP_ID, FIRST_NAME, LAST_NAME, `ROLE`, check_job_role(EXP) 
FROM data_science_team WHERE `ROLE` != check_job_role(EXP);
#13) Create an index to improve the cost and performance of the query to find the employee whose FIRST_NAME is ‘Eric’ in the employee table after checking the execution plan
CREATE INDEX FirstName ON emp_record_table (FIRST_NAME(10));
#14) Write a query to calculate the bonus for all the employees, based on their ratings and salaries (Use the formula: 5% of salary * employee rating)
SELECT EMP_ID, FIRST_NAME, LAST_NAME, SALARY, EMP_RATING, (0.05 * SALARY * EMP_RATING) AS comm
FROM emp_record_table
LIMIT 0, 1000
#15) Write a query to calculate the average salary distribution based on the continent and country
SELECT COUNTRY, AVG(SALARY) FROM emp_record_table GROUP BY COUNTRY;
SELECT continent, AVG(salary) FROM emp_record_table GROUP BY continent;
