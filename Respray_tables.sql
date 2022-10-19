---Count the nuber of reprays by customer 
select accountnum as Faggots,count(distinct(completeddate)) as resprays
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

AS Cost_of_Respray

select * from Project.mojo_sprays




---Count the nuber of reprays by customer 
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
-Table that is used for looking at the amount of revenue that you could be making based on retention
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