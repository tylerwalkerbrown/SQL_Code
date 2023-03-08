####SQL Pracitce Code#####
Used for Analysis,Manipulation,ETL,Wrangling



---Choosing all the distinct columns 
select distinct(chemical)
from all_sprays


---- point out all the illegal sprays 
---- NH == 1 VT = 0 in states
with adjust as (
select accountnum, date,employee, sitename,chemical,materialquantity,
case when chemical = 'Cyzmic Cs' or chemical = 'LIV Repeller' then 1 else 0 end as inacc ,
case when chemical like 'Duraflex%' or chemical like 'Cyzmic%' then 'Duraflex'
when chemical like 'Stryker%' then 'Stryker'
when chemical like 'Stop the Bite%' then 'Stop the Bite (STB) 6oz/gal'
when chemical ='Bifen' then 'Bifen'
when chemical= 'Pivot 10' then  'Pivot 10'
when chemical = 'EcoVia EC' or chemical = 'EcoVia G' or chemical = 'EvoVia G'then 'EcoVia G'
when chemical like 'Surf-Ac%' then 'Surf-Ac 820'
when chemical = 'EcoVia MT' then 'EcoVia MT'
when chemical = 'Aquabac (200G)' or chemical = 'AquaBacXT' then 'Aquabac (200G)'
when chemical = 'Tekko Pro' or chemical = 'Tekko 0.2G Larvicide (Low Rate)' or chemical = 'Tekko 0.2G Larvicide (High Rate)' then 'Tekko 0.2G Larvicide (High Rate)'
when chemical ='Altosid Pro-G' then 'Altosid Pro-G'
when chemical ='AquaBacXT' then 'AquaBacXT'
when chemical = 'In2Care Unit' then 'In2Care Unit'
when chemical = 'In2Mix Bait Sachets' then 'In2Mix Bait Sachets'
when chemical = 'Essentria IC3' then 'Essentria IC3'
when chemical = 'Bifen Granulars' then 'Bifen Granulars'
when chemical = 'Thermacell Tick Tubes' then 'Thermacell Tick Tubes'
when chemical = 'Summit Bti Dunks' then 'Summit Bti Dunks'
when chemical = 'B.T.I. Briquets' then 'B.T.I. Briquets'
when chemical = 'Summit BTI Granules' then 'Summit BTI Granules'
when chemical =  'LIV Repeller' then 'LIV Repeller' 
when chemical = 'Altosid' then 'Altosid'  end as chemical_name,
case when siteaddress like '%NH%' then 1 else 0 end as states,
(materialquantity * 5000) as squarefeet,siteaddress
from all_sprays)
,b as (select *,case when chemical_name= 'Duraflex' then 1
when chemical_name ='EcoVia MT' or chemical_name ='EcoVia G' then 0.5
when chemical_name = 'Stop the Bite (STB) 6oz/gal' then 6
when chemical_name = 'Stryker' then 10 
when chemical_name ='Altosid Pro-G' then 1 
when chemical_name ='Altosid' then 1
when chemical_name = 'Aquabac (200G)' then 1 
when chemical_name ='Bifen Granulars' then 1
when chemical_name ='Bifen' then 1
when chemical_name ='Pivot 10' then 4
when chemical_name ='Summit BTI Granules' or chemical_name ='Summit Bti Dunks' or chemical_name ='Thermacell Tick Tubes' or chemical_name = 'In2Care Unit' or chemical_name = 'In2Mix Bait Sachets' then 1
when chemical_name ='Surf-Ac 820' then 1.5 
when chemical_name ='Tekko 0.2G Larvicide (High Rate)' then 1
when chemical_name ='Essentria IC3' then 2 end as unit_multi,
case when chemical_name= 'Duraflex' then 'oz'
when chemical_name ='EcoVia MT' or chemical_name ='EcoVia G' then 'oz'
when chemical_name = 'Stop the Bite (STB) 6oz/gal' then 'oz'
when chemical_name = 'Stryker' then 'ml' 
when chemical_name ='Altosid Pro-G' or chemical_name = 'Altosid' then 'tsp'
when chemical_name = 'Aquabac (200G)' then 'tsp'
when chemical_name ='Bifen Granulars' then 'pound'
when chemical_name ='Bifen' then 'oz'
when chemical_name ='Pivot 10' then 'ml'
when chemical_name ='Summit Bti Dunks'or chemical_name ='Thermacell Tick Tubes' or chemical_name = 'In2Care Unit' or chemical_name = 'In2Mix Bait Sachets' or chemical_name = 'Summit BTI Granules' then 'each'
when chemical_name ='Surf-Ac 820' then 'ml' 
when chemical_name = 'Tekko 0.2G Larvicide (High Rate)' or chemical_name = 'Altosid' or chemical_name = 'Essentria IC3' or chemical_name = 'AquaBacXT' then 'oz' else 0 end as unitmeasure
from adjust)
, c as(
select *,case when unitmeasure = 'oz' then 128
when unitmeasure = 'ml' then 29.5735
when unitmeasure = 'pound' then 1
when unitmeasure = 'tsp' then 96
when unitmeasure = 'each' then 1 end as divide
from b
)
, d as( 
select * ,case when unitmeasure = 'oz' then 'Gallons'
when unitmeasure = 'ml' then 'Oz'
when unitmeasure = 'pound' or unitmeasure = 'tsp' then 'Pounds'
when unitmeasure = 'each' then 'each' end as final_measure,
 (materialquantity * unit_multi)/divide as amount_in_unit
from c
where states = 0
)
select chemical_name,sum(materialquantity) as Quantity, sum(amount_in_unit) as Amount_used,final_measure, sum(squarefeet) as sum_sqft ,concat(unit_multi,unitmeasure) as Usage_per_quantity
from d
where date between '2022-01-01' and '2023-01-01' and  materialquantity > 1 
group by chemical_name,final_measure, unit_multi,unitmeasure


--- Table build off of top table to see the break down of each customer like chem usage, sqft.
  with a as  (select  *,reverse(siteaddress) as address
    from grouped_by_customer)
	,b as (
   select *,substring(address,1,6) as address1
   from a)
   ,c as (select *,reverse(address1) as zip
   from b)
   select states,zip,chemical_name,sum(Quantity) as Quantity,count(accountnum) as num_of_uses, 
   count(distinct(accountnum)) as num_of_customers,
   sum(sum_sqft) as sum_sqft 
   from c
   group by zip, chemical_name,states















---Count the nuber of reprays by customer 
select accountnum as Respray,count(distinct(completeddate)) as resprays
from Project.mojo_sprays
where eventname = 'Re-Spray'
and completeddate 
BETWEEN '01/01/2022' AND '12/01/2022'
GROUP BY accountnum,completeddate
---Selecting the amount used per product
SELECT itemnum as Chemical, sum(usagepermixuom * materialquantity) as Amount_Used
FROM mojo_sprays 
WHERE completeddate 
BETWEEN '01/01/2022' AND '12/01/2022'
GROUP BY itemnum


--- Selecting all as a reference
select * from customer_info

---Count the nuber of reprays by customer 
with tab as 
(select accountnum as Accounts, count(distinct(completeddate)) as resprays
from mojo_sprays
where eventname = 'Re-Spray'
and completeddate 
BETWEEN '01/01/2022' AND '12/01/2022'
group by accountnum)
    SELECT BillName, billamount * resprays as total_cost , accountnum
    FROM customer_info
    JOIN tab 
    ON customer_info.accountnum = tab.Accounts
    group by accountnum,BillName,tab.resprays,customer_info.billamount
)
select BillName, resprays.tab
from b 



---Count the number of reprays by customer 
-- Calculating the dollar amount each customer is worth
with respray as 
(select accountnum as Accounts, count(distinct(completeddate)) as resprays,completeddate
from Project.mojo_sprays
where eventname = 'Re-Spray'
and completeddate 
group by accountnum,completeddate)
, cost as (
    SELECT accountnum, BillName AS name, billamount * resprays as total_cost,completeddate 
    FROM Project.customer_info
    JOIN respray 
    ON customer_info.accountnum = respray.Accounts
    group by accountnum,BillName,respray.resprays,customer_info.billamount,completeddate
)
SELECT *
from cost 



------Table that contains all the resprays and the potential loss in revenue
create table Project.respray_costs as(
with respray as 
(select accountnum as Accounts, count(distinct(completeddate)) as resprays,completeddate
from Project.mojo_sprays
where eventname = 'Re-Spray'
and completeddate 
group by accountnum,completeddate)
, cost as (
    SELECT accountnum as Account, BillName AS name, billamount * resprays as total_cost,completeddate 
    FROM Project.customer_info
    JOIN respray 
    ON customer_info.accountnum = respray.Accounts
    group by accountnum,BillName,respray.resprays,customer_info.billamount,completeddate
)
SELECT * 
from cost 
)




---Table that is used for looking at the amount of revenue that you could be making based on retention
--- Used a case when statement to assign the total amount of sprays based on type of spray 
---Took the number of sprays assigned in the case when statement to figure out how much mojo would be making on full retention or percentage of retention
with a as (select case when eventname = 'Synthetic Barrier Spray' then 12
			when eventname = 'All-Natural Barrier Spray' then 8 
            when eventname = ' ' then 0 end as number_of_sprays, accountnum as account
			from mojo_sprays
            group by accountnum,number_of_sprays )
            , b as (
            select billamount,accountnum , number_of_sprays,(number_of_sprays * billamount * .80) as Revenue_amount
            from a
			right join customer_info on
           customer_info.accountnum =  a.account)
           , c as (
           select *, (Revenue_amount - total_cost) as Revenue
           from b
           inner JOIN respray_costs ON
           respray_costs.Account = b.accountnum 
			GROUP By billamount, accountnum, number_of_sprays, 
            Revenue_amount, Account, name, total_cost, completeddate, Revenue)
            select * from c
            where Revenue >1
GROUP By billamount, accountnum, number_of_sprays, 
            Revenue_amount, Account, name, total_cost, completeddate, Revenue






---Creating columns to see what customers have churned from 2020 to 2021
create table Project.churn_2020_2021 as(
WITH 
churn_2020 AS 
(SELECT *
FROM mojo_sprays
WHERE completeddate < '12/01/2020'
AND (
  (completeddate >= '12/01/2020')
  OR (completeddate IS NULL))
),
churn_2021 AS 
(SELECT  accountnum,
CASE
  WHEN (completeddate > '12/01/2021')
    OR (completeddate IS NULL) THEN 0
  ELSE 1
  END as 2020_2021_churn,
CASE
  WHEN (completeddate < '12/01/2020')
    AND (
      (completeddate >= '12/01/2020')
        OR (completeddate IS NULL)
    ) THEN 1
    ELSE 0
  END as is_active
FROM mojo_sprays
)
SELECT accountnum,2020_2021_churn
FROM churn_2021
group by accountnum,2020_2021_churn
)
select sum(2020_2021_churn)/count(2020_2021_churn)
from churn_2020_2021






with a as (
select accountnum as account_, Businessname, avg(measurement) as sqft
from Project.sqft
group by accountnum, Businessname)
,b as (
select sqft, count(sqft) as num_of_clients
from a
group by sqft)
,c as (
select * , ntile(6) over (order by sqft) as bins, (num_of_clients/412)*100 as percent, 
(sqft*.006) as amount_to_charage
from b
order by num_of_clients desc
)
,bins as (
select bins, avg(sqft) as avg_sqft,min(sqft) as min_sqft, max(sqft) as max_sqft, sum(num_of_clients) as num_of_clients
from c 
group by bins)
, d as(
select * , 
case when bins = 1 then 98
when bins = 2 then 98
when bins = 3 then 110
when bins = 4 then 130
when bins = 5 then 170
when bins = 6 then 210 end as 2023_prices,
case when bins = 1 then 88
when bins = 2 then 93
when bins = 3 then 103
when bins = 4 then 113
when bins = 5 then 163
when bins = 6 then 203 end as 2022_prices
from bins)
, final as(
select *, (2023_prices*num_of_clients) as 2023_revenue ,(2022_prices*num_of_clients) as 2022_revenue
from d)
select * , (2023_revenue - 2022_revenue) as 2023_minus_2022_revenue, (2023_prices-2022_prices) as 2023_minus_2022_cost
from final 
order by bins asc





