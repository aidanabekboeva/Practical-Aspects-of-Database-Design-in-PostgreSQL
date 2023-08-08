DROP TABLE banks_al;
DROP TABLE banks_sec;
DROP TABLE banks_total; 

--- Creating tables banks_al and banks_sec and filling them with data 

CREATE TABLE IF NOT EXISTS public . banks_al
(
id integer ,
date date ,
asset integer ,
liability integer
)
 
COPY banks_al (id , date , asset , liability)
FROM 'C:\Users\Public\banks_al_2002.csv'
DELIMITER ','
CSV HEADER

SELECT * FROM banks_al

CREATE TABLE IF NOT EXISTS public . banks_sec
(
id integer ,
date date ,
security integer
)
 
COPY banks_sec (id , date , security)
FROM 'C:\Users\Public\banks_sec_2002-1.csv'
DELIMITER ','
CSV HEADER

--- searching for duplicates 

SELECT * FROM banks_sec 
WHERE id IN (
    SELECT id FROM banks_sec 
    EXCEPT SELECT MIN(id) FROM banks_sec 
    GROUP BY date, security
    )
ORDER BY id, date, security;

--- deleting duplicates 

DELETE FROM banks_sec 
WHERE id IN (
    SELECT id FROM banks_sec 
    EXCEPT SELECT MIN(id) FROM banks_sec 
    GROUP BY id, date, security 
    );

SELECT * FROM banks_sec ORDER BY id

--- Creating a new table and assigning a merge of two previous tables to it.

DROP TABLE banks_total

CREATE TABLE banks_total AS ( 
SELECT banks_al.id , banks_al.asset , banks_sec.security 
FROM banks_al  
INNER JOIN banks_sec  on banks_al.id = banks_sec.id 
AND banks_al.date = banks_sec.date);

SELECT * FROM banks_total;

--- setting the primary key for the table

ALTER TABLE banks_total ADD PRIMARY KEY (id);

--- Security over 20% of their asset 

SELECT banks_al.id , banks_al.asset , banks_sec.security 
FROM banks_al 
INNER JOIN banks_sec ON banks_al.id = banks_sec.id AND 
			            banks_al.date = banks_sec.date  
WHERE (banks_al.date BETWEEN '2002-01-01' AND '2002-03-31')    
AND (banks_sec.security > banks_al.asset * 0.2)  
ORDER BY banks_al.id; 

SELECT COUNT(banks_al.id)  
FROM banks_al 
INNER JOIN banks_sec ON banks_al.id = banks_sec.id AND 
			            banks_al.date = banks_sec.date  
WHERE (banks_al.date BETWEEN '2002-01-01' AND '2002-03-31')    
AND (banks_sec.security > banks_al.asset * 0.2)


--- Liability over 90% of their assets 
drop table tempor
CREATE TABLE tempor AS (
SELECT banks_al.id , banks_al.date, banks_al.asset , banks_al.liability 
FROM banks_al   
WHERE ((banks_al.date BETWEEN '2002-01-01' AND '2002-03-31')    
AND (banks_al.liability > banks_al.asset * 0.9))   
ORDER BY banks_al.id)

select * from tempor

SELECT COUNT(tempor.id)  
FROM tempor   
WHERE ((tempor.date BETWEEN '2002-04-01' AND '2002-06-30')
AND (tempor.liability < tempor.asset * 0.9))  

--- importing banks_total to a csv file 

select * from banks_total


