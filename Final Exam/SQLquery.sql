--- Creating table bank_data and filling it with data 
drop table bank_data

CREATE TABLE IF NOT EXISTS public . bank_data
(
id integer ,
date date ,
asset integer ,
liability integer ,
idx integer
)
 
COPY bank_data (id, date, asset, liability, idx)
FROM 'C:\Users\Public\bank_data-1.csv'
DELIMITER ','
CSV HEADER

SELECT * FROM bank_data

---  Create a primary key for the import table
CREATE INDEX key_id ON bank_data(id);

--- Find the highest asset observation for each bank.

SELECT MAX (asset) obs FROM bank_data 
GROUP BY id 
ORDER BY obs 
LIMIT 10;

--- Show the query plan for question 1.3 using EXPLAIN tool.

EXPLAIN ANALYZE 
SELECT MAX (asset) obs FROM bank_data 
GROUP BY id 
ORDER BY obs 
LIMIT 10;

--- Given the highest asset table from question 1.3, count how many observations are there for
--- each quarter.

DROP TABLE tempor

CREATE TABLE tempor AS (
SELECT bank_data.id , bank_data.date, bank_data.asset , 
	bank_data.liability, bank_data.idx
FROM bank_data   
	INNER JOIN (SELECT MAX (asset) obs, id FROM bank_data qdata
			GROUP BY id) qdata ON qdata.obs=bank_data.asset 
			AND bank_data.id=qdata.id
WHERE bank_data.date = '12/31/2002' 
ORDER BY bank_data.id);

SELECT COUNT(tempor.id) FROM tempor   


--- For the whole sample data, how many observations have asset value higher than 100,000 and
--- liability value smaller than 100,000.

SELECT COUNT (*) FROM bank_data
WHERE asset > 100000 AND liability < 100000;

--- Each observation was given an ’idx’ number. Find the average liability of observation with
--- odd ’idx’ number.

SELECT AVG (liability) odd FROM bank_data 
WHERE ((idx % 2) <> 0) = FALSE
GROUP BY ((idx % 2)) ;

---

SELECT AVG (liability) even FROM bank_data 
WHERE ((idx % 2) <> 0) = TRUE
GROUP BY ((idx % 2)) ;

--- For each bank find all records with increased asset.

SELECT bank_data.*
FROM (SELECT bank_data.*,
             LAG(asset) OVER (partition by id ORDER BY date) as prev_asset
      FROM bank_data
     ) bank_data
WHERE asset > prev_asset 
LIMIT 10 ;