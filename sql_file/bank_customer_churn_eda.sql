-- Basic Aggregation:

-- 1. What is the total number of customers in each country?
	SELECT country, COUNT(*) AS total_customers
    FROM bank_churn
    group by country


-- 2. What is the overall churn rate as a percentage?
select avg(churn) * 100 as avg_churn_rate
from bank_churn

-- 3. What is the average account balance by gender?
select gender, round(avg(balance),2) as avg_balance
from bank_churn
group by gender

-- 4. Which country has the highest average credit score?
select country,round(avg(credit_score),2) as avg_credit_score
from bank_churn
group by country
order by 2 desc
limit 1

-- 5. What is the churn rate for active vs inactive members?
select active_member_label, avg(churn) * 100 as avg_churn
from bank_churn 
group by active_member_label


-- GROUP BY + HAVING:
-- 6. Which age groups have a churn rate greater than 25%?
select age_group, avg(churn)*100 as churn_rate
from bank_churn
group by age_group
having churn_rate > 25

-- 7. Which country has more than 500 inactive members?
select country, count(*) as inactive_member
from bank_churn
where active_member_label in ('Inactive')
group by country
having inactive_member > 500

-- Subquery:

-- 8. What is the churn rate of customers whose balance is above the overall average balance?
select avg(churn)*100 as avg_churn
from bank_churn
where balance>(select avg(balance)
				from bank_churn)


-- 9. Which age group has the highest churn rate in Germany?
select age_group, avg(churn)*100 as avg_churn
from bank_churn
where country in (select country
					from bank_churn
					where country in ('Germany')
)
group by age_group
order by 2 desc
limit 1

-- Window Function:

-- 10. Rank customers by account balance within each country.
select balance, country,
rank() over(partition by country order by balance desc) as balance_rank
from bank_churn

-- 11. Compare each country's churn rate against the overall churn rate.
select country,
churn_country,
churn_all,
(churn_country - churn_all) as churn_difference
from (select country,
 avg(churn)*100 as churn_country,
(select avg(churn)*100  from bank_churn)as churn_all
from bank_churn
group by country) as sub_query



-- 12. Calculate the cumulative churn rate by age group within each gender.
select gender,
age_group,
sum(avg_churn) over(partition by gender order by age_group) as cumulative_sum
from (select gender,
		age_group,
        avg(churn)*100 as avg_churn
from bank_churn
group by gender, age_group) as sub_query

-- Aggregation:

-- 13. What is the average credit score by country and gender combined?

select country, gender, avg(credit_score) as avg_credit
from bank_churn
group by country, gender


-- 14. Which tenure (years) has the highest churn rate?
select tenure, 
count(*) as total_customer,
avg(churn)*100 as avg_churn
from bank_churn
group by tenure
having total_customer > 10
order by 3 desc
limit 1


-- 15. What percentage of customers have zero balance?
select count(*)/(select count(*) 
from bank_churn) *100 as churn_percentage_0_balance
from bank_churn
where balance = 0
-- OR
select avg(case when balance = 0 then 1 else 0 end)*100 as churn_bl_0_per
from bank_churn


-- Subquery:

-- 16. Which customers have a salary above the average salary of churned customers?
select *
from bank_churn
where salary > (select avg(salary)
from bank_churn
where churn = 1
)


-- 17. What is the churn rate of customers who have more products than the average number of products?
select avg(churn)*100 as churn_rate
from bank_churn
where num_products > (select avg(num_products)
from bank_churn)



-- 18. Which country has above average number of churned customers?
select country, avg(churn) as avg_churn
from bank_churn 
group by country
having avg_churn > (select avg(churn) 
from bank_churn)


-- Window Function:

-- For each country, show each customer's balance and the average balance of their country side by side.
select country,
balance,
round(avg(balance) over(partition by country),2) as avg_bal
from bank_churn


-- Rank countries by churn rate from highest to lowest.



-- For each customer, show their credit score percentile within their country.



-- Show the top 3 customers by balance in each country.








































































