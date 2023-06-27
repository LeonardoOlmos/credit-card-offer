-- 1.Create a database called credit_card_classification.
CREATE DATABASE credit_card_classification;

USE credit_card_classification;

-- 2.Create a table credit_card_data with the same columns as given in the csv file. Please make sure you use the correct data types for each of the columns.
CREATE TABLE IF NOT EXISTS credit_card_data(
	customer_number int not null auto_increment primary key,
    offer_accepted varchar(3) not null,
    reward varchar(25) not null,
    mailer_type varchar(15) not null,
    income_level varchar(10) not null,
    bank_accounts_open int not null,
    overdraft_protection varchar(3) not null,
    credit_rating varchar(10) not null,
    credit_cards_held int not null,
    homes_owned int not null,
    household_size int not null,
    own_your_home varchar(3) not null,
    avg_balance float,
    balance_q1 float,
    balance_q2 float,
    balance_q3 float,
    balance_q4 float
);

-- 3.Import the data from the csv file into the table. Before you import the data into the empty table, make sure that you have deleted the headers from the csv file.
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL\ Server\ 8.0/Uploads/creditcardmarketing_db.csv' 
INTO TABLE credit_card_data 
FIELDS TERMINATED BY ',' ENCLOSED BY ''
LINES TERMINATED BY '\r\n'
(offer_accepted, reward , mailer_type, income_level, bank_accounts_open, overdraft_protection, credit_rating, credit_cards_held, homes_owned, household_size, own_your_home, @vavg_balance, @vbalance_q1, @vbalance_q2, @vbalance_q3, @vbalance_q4)
SET
avg_balance = NULLIF(@vavg_balance,''),
balance_q1 = NULLIF(@vbalance_q1,''),
balance_q2 = NULLIF(@vbalance_q2,''),
balance_q3 = NULLIF(@vbalance_q3,''),
balance_q4 = NULLIF(@vbalance_q4,'');

-- 4. Select all the data from table credit_card_data to check if the data was imported correctly.
select * from credit_card_data order by 1 asc;

/* 5. Use the alter table command to drop the column q4_balance from the database, as we would not use it in the analysis with SQL. 
   Select all the data from the table to verify if the command worked. Limit your returned results to 10. */

ALTER TABLE credit_card_data DROP COLUMN balance_q4;
   
SELECT * FROM credit_card_data ORDER BY 1 ASC LIMIT 10;

-- 6. Use sql query to find how many rows of data you have.

SELECT COUNT(*) FROM credit_card_data;

-- 7. Now we will try to find the unique values in some of the categorical columns:
-- What are the unique values in the column Offer_accepted?
SELECT DISTINCT(ccd.offer_accepted) FROM credit_card_data ccd;

-- What are the unique values in the column Reward?
SELECT DISTINCT(ccd.reward) FROM credit_card_data ccd;

-- What are the unique values in the column mailer_type?
SELECT DISTINCT(ccd.mailer_type) FROM credit_card_data ccd;

-- What are the unique values in the column credit_cards_held?
SELECT DISTINCT(ccd.credit_cards_held) FROM credit_card_data ccd ORDER BY 1;

-- What are the unique values in the column household_size?
SELECT DISTINCT(ccd.household_size) FROM credit_card_data ccd ORDER BY 1;

/* 8. Arrange the data in a decreasing order by the average_balance of the customer. 
   Return only the customer_number of the top 10 customers with the highest average_balances in your data.*/
SELECT * 
FROM credit_card_data ccd
ORDER BY ccd.avg_balance DESC
LIMIT 10;

-- 9. What is the average balance of all the customers in your data?
SELECT ROUND(AVG(ccd.avg_balance), 3) AS total_avg_balance
FROM credit_card_data ccd;

/* 10. In this exercise we will use simple group_by to check the properties of some of the categorical variables in our data. 
   Note wherever average_balance is asked, please take the average of the column average_balance: */

/* What is the average balance of the customers grouped by Income Level? The returned result should have only two columns, income level and Average balance of the customers. 
   Use an alias to change the name of the second column.*/
SELECT ROUND(AVG(ccd.avg_balance), 3) AS avg_balance, ccd.income_level
FROM credit_card_data ccd
GROUP BY ccd.income_level
order by 2;

/* What is the average balance of the customers grouped by number_of_bank_accounts_open? 
   The returned result should have only two columns, number_of_bank_accounts_open and Average balance of the customers. Use an alias to change the name of the second column.*/
SELECT ROUND(AVG(ccd.avg_balance), 3) AS avg_balance, ccd.bank_accounts_open
FROM credit_card_data ccd
GROUP BY ccd.bank_accounts_open
order by 2;
   
/* What is the average number of credit cards held by customers for each of the credit card ratings? 
The returned result should have only two columns, rating and average number of credit cards held. Use an alias to change the name of the second column.*/
SELECT ROUND(AVG(ccd.avg_balance), 3) AS avg_balance, ccd.credit_cards_held
FROM credit_card_data ccd
GROUP BY ccd.credit_cards_held
order by 2;

/* Is there any correlation between the columns credit_cards_held and number_of_bank_accounts_open? 
   You can analyse this by grouping the data by one of the variables and then aggregating the results of the other column. 
   Visually check if there is a positive correlation or negative correlation or no correlation between the variables.*/
SELECT ROUND(AVG(ccd.avg_balance), 3) AS avg_balance, ccd.credit_cards_held, ccd.bank_accounts_open
FROM credit_card_data ccd
GROUP BY ccd.credit_cards_held, ccd.bank_accounts_open
order by 2;

/* 11. Your managers are only interested in the customers with the following properties:

Credit rating medium or high
Credit cards held 2 or less
Owns their own home
Household size 3 or more
For the rest of the things, they are not too concerned. Write a simple query to find what are the options available for them? */
SELECT *
FROM credit_card_data ccd
WHERE LOWER(ccd.credit_rating) IN ('medium', 'high')
AND ccd.credit_cards_held <= 2
AND ccd.homes_owned = 1
AND ccd.household_size >= 3
ORDER BY 1 ASC;

-- Can you filter the customers who accepted the offers here?

SELECT *
FROM credit_card_data ccd
WHERE LOWER(ccd.credit_rating) IN ('medium', 'high')
AND ccd.credit_cards_held <= 2
AND ccd.homes_owned = 1
AND ccd.household_size >= 3
AND LOWER(offer_accepted) = 'yes'
ORDER BY 1 ASC;

/* 12. Your managers want to find out the list of customers whose average balance is less than the average balance of all the customers in the database. 
   Write a query to show them the list of such customers. You might need to use a subquery for this problem.*/
SELECT * 
FROM credit_card_data ccd
WHERE ccd.avg_balance < (SELECT AVG(ccd.avg_balance) AS total_avg FROM credit_card_data ccd)
ORDER BY 1 ASC;

-- 13. Since this is something that the senior management is regularly interested in, create a view of the same query.
CREATE OR REPLACE VIEW clients_lower_avg AS 
	SELECT * 
	FROM credit_card_data ccd
	WHERE ccd.avg_balance < (SELECT AVG(ccd.avg_balance) AS total_avg FROM credit_card_data ccd)
	ORDER BY 1 ASC;
    
SELECT * FROM clients_lower_avg;

-- 14. What is the number of people who accepted the offer vs number of people who did not?
SELECT COUNT(*) AS total_customers, ccd.offer_accepted
FROM credit_card_data ccd 
GROUP BY ccd.offer_accepted;

/* 15. Your managers are more interested in customers with a credit rating of high or medium. 
   What is the difference in average balances of the customers with high credit card rating and low credit card rating?*/
WITH cte_balances AS (
SELECT SUM(CASE WHEN ccd.credit_rating = 'High' THEN ccd.avg_balance ELSE 0 END) AS high_total_balance, 
		SUM(CASE WHEN ccd.credit_rating = 'Low' THEN ccd.avg_balance ELSE 0 END) AS low_total_balance
FROM credit_card_data ccd)
SELECT ROUND(AVG(b.high_total_balance) -  AVG(b.low_total_balance), 2) AS avg_diff
FROM cte_balances b;
   
-- 16. In the database, which all types of communication (mailer_type) were used and with how many customers?
SELECT COUNT(*) AS total_customers, ccd.mailer_type
FROM credit_card_data ccd
GROUP BY ccd.mailer_type;

-- 17. Provide the details of the customer that is the 11th least Q1_balance in your database.
WITH lower_balance_q1 AS (
	SELECT ROW_NUMBER() OVER (ORDER BY ccd.balance_q1 ASC) AS 'row_id', ccd.*
	FROM credit_card_data ccd
	WHERE ccd.balance_q1 IS NOT NULL
)
SELECT * 
FROM lower_balance_q1 cte_customers
WHERE cte_customers.row_id = 11;