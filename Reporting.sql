---Choosing all the distinct columns 
select distinct(chemical)
from all_sprays


---- point out all the illegal sprays 
with adjust as (
select date,employee, sitename,chemical,materialquantity,
case when chemical = 'Cyzmic Cs' 
or chemical = 'LIV Repeller' then 1 else 0 end as illegal,
case when chemical like 'Duraflex%' or chemical like 'Cyzmic%' then 'Duraflex'
when chemical like 'Stryker%' then 'Stryker'
when chemical like 'Stop the Bite%' then 'Stop the Bite (STB) 6oz/gal'
when chemical ='Bifen' then 'Bifen'
when chemical= 'Pivot 10' then  'Pivot 10'
when chemical = 'EcoVia EC' or chemical = 'EcoVia G' or chemical = 'EvoVia G'then 'EvoVia G'
when chemical like 'Surf-Ac%' then 'Surf-Ac 820'
when chemical = 'EcoVia MT' then 'EcoVia MT'
when chemical = 'Aquabac (200G)' then 'Aquabac (200G)'
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
when chemical = 'Altosid' then 'Altosid'
 end as chemical_name
from all_sprays
)
select chemical_name, sum(materialquantity) 
from adjust 
where chemical_name is not null and date between '2022-01-01' and '2023-01-01'
group by chemical_name
