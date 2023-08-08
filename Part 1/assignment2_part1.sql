DROP TABLE banks
CREATE TABLE IF NOT EXISTS public.banks
(
    id integer,
    date date,
    asset integer,
    liability integer
)

COPY banks (id, date, asset, liability) 
FROM 'C:\Users\Public\banks_al_2001.csv'
DELIMITER ','
CSV HEADER 

SELECT * FROM banks 

SELECT EXTRACT (quarter from date) AS quarter, COUNT(distinct id) FROM banks
GROUP BY quarter 
ORDER BY quarter ASC

SELECT id, ROUND(AVG(asset), 2) AS asset_avg
FROM banks
GROUP BY id

SELECT id FROM banks
WHERE date = '2001-06-30' ORDER BY asset DESC LIMIT 1 OFFSET 1;

WITH tabl AS (
SELECT *, EXTRACT(quarter FROM date) AS quarter, asset-liability AS equity 
	FROM banks
)

SELECT id FROM tabl WHERE equity > 0.1 * asset AND quarter = 1
ORDER BY id 


TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.banks
    OWNER to postgres;