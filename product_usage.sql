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




















