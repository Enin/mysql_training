����1��) dvd �뿩�� ���� ������ �� �̸���? (analytic funtion Ȱ��)	

SELECT c.customer_id , c.first_name , c.last_name ,
	COUNT(r.rental_id) AS CNT ,
	ROW_NUMBER() OVER( ORDER BY COUNT(r.rental_id) DESC ) AS RANKS
FROM rental r 
JOIN customer c ON r.customer_id = c.customer_id 
GROUP BY c.customer_id 
LIMIT 1;

����2��) ������ ���� ���� �ø� dvd �� �̸���? (analytic funtion Ȱ��)	Ǯ��

-- RANK : 1, 1, 3, 4, ...
	-- PERCENT_RANK : 
-- DENSE_RANK : 1, 1, 2, 3, ...
-- ROW_NUMBER : 1, 2, 3, 4, ...


SELECT c.customer_id , c.first_name , c.last_name , SUM(amount) AS SUM_AMT ,
	RANK() OVER( ORDER BY SUM(amount) DESC ) AS RANKING
FROM customer c 
JOIN payment p ON c.customer_id = p.customer_id 
GROUP BY c.customer_id 
LIMIT 1;


����3��) dvd �뿩�� ���� ���� ���ô�? (anlytic funtion)	

SELECT c2.city_id , c2.city , COUNT(r.rental_id) AS CNT ,
	RANK() OVER( ORDER BY COUNT(r.rental_id) ASC) AS RANKING
FROM rental r 
JOIN customer c ON r.customer_id = c.customer_id 
JOIN address a ON c.address_id = a.address_id 
JOIN city c2 ON a.city_id = c2.city_id 
GROUP BY c2.city_id 
LIMIT 1;

SELECT * FROM city c ;


����4��) ������ ���� �ȳ����� ���ô�? (anlytic funtion)	

SELECT c2.city_id , c2.city , SUM(p.amount) AS A_SUM ,
	DENSE_RANK() OVER( ORDER BY SUM(p.amount) ) AS RANKING
FROM payment p 
JOIN customer c ON p.customer_id = c.customer_id 
JOIN address a ON c.address_id = a.address_id 
JOIN city c2 ON a.city_id = c2.city_id 
GROUP BY c2.city_id LIMIT 1;

����5��) ���� ������� ���ϰ� ���� ������ ������� �پ�� ���� ���ϼ���. (���ڴ� payment_date ����)	 Ǯ��

SELECT *
FROM (
	SELECT EXTRACT(YEAR FROM DATE(p.PAYMENT_DATE)) AS YR, -- EXTRACT �Լ��� DATE(P.PAYMENT_DATE) ���� YEAR, MONTH, DAY �� ���� ��¥�� ã�ƿ�
		   EXTRACT(MONTH FROM DATE(p.PAYMENT_DATE)) AS MON, -- TO_CHAR(P.PAYMENT_DATE, 'YYYY') ����ص� ��.
		   SUM(p.AMOUNT) AS SUM_AMOUNT ,
		   COALESCE( LAG(SUM(p.AMOUNT), 1) OVER( ORDER BY EXTRACT(YEAR FROM DATE(p.PAYMENT_DATE))) , 0) AS PRE_MON_AMOUNT ,
		   SUM(p.AMOUNT) - COALESCE( LAG(SUM(p.AMOUNT), 1) OVER( ORDER BY EXTRACT(YEAR FROM DATE(p.PAYMENT_DATE))) , 0) AS GAP
	FROM payment p 
	GROUP BY EXTRACT(YEAR FROM DATE(p.PAYMENT_DATE)) ,
		     EXTRACT(MONTH FROM DATE(p.PAYMENT_DATE))
     ) AS DB
WHERE GAP < 0 ;

SELECT *
FROM (
	SELECT EXTRACT(YEAR FROM DATE(p.PAYMENT_DATE)) AS YR, -- EXTRACT �Լ��� DATE(P.PAYMENT_DATE) ���� YEAR, MONTH, DAY �� ���� ��¥�� ã�ƿ�
		   EXTRACT(MONTH FROM DATE(p.PAYMENT_DATE)) AS MON, -- TO_CHAR(P.PAYMENT_DATE, 'YYYY') ����ص� ��.
		   SUM(p.AMOUNT) AS SUM_AMOUNT ,
		   COALESCE( LAG(SUM(p.AMOUNT), 1) OVER( ORDER BY EXTRACT(YEAR FROM DATE(p.PAYMENT_DATE))) , 0) AS PRE_MON_AMOUNT
	FROM payment p 
	GROUP BY EXTRACT(YEAR FROM DATE(p.PAYMENT_DATE)) ,
		     EXTRACT(MONTH FROM DATE(p.PAYMENT_DATE))
     ) AS DB
WHERE sum_amount < pre_mon_amount ;

����6��) ���ú� dvd �뿩 ���� ������ ���ϼ���. 

SELECT c2.city_id , c2.city , SUM(p.amount) AS A_SUM ,
	ROW_NUMBER () OVER ( ORDER BY SUM(p.amount) DESC ) AS RANKING
FROM payment p 
JOIN customer c ON p.customer_id = c.customer_id 
JOIN address a ON c.address_id = a.address_id 
JOIN city c2 ON a.city_id = c2.city_id 
GROUP BY c2.city_id ;

����7��) �뿩���� ���� ������ ���ϼ���.	Ǯ��

SELECT i.store_id , SUM(p.amount) AS SUM_AMOUNT ,
	ROW_NUMBER () OVER ( ORDER BY SUM(p.amount) DESC ) AS SUM_AMOUNT_RANK
FROM payment p 
JOIN rental r ON p.rental_id = r.rental_id 
JOIN inventory i ON r.inventory_id = i.inventory_id 
GROUP BY i.store_id ;


����8��) ���󺰷� ���� �뿩�� ������ �� TOP 5�� ���ϼ���. 	


-- ���� ���� �� �뿩 Ƚ�� ��ŷ
SELECT *
FROM(
	SELECT db.country, db.first_name, db.last_name,	COUNT(DISTINCT db.rental_id) as rental_cnt ,
		ROW_NUMBER () OVER ( PARTITION BY db.country ORDER BY COUNT(DISTINCT db.rental_id) DESC) AS RANKING
	FROM( -- ��������1 �ʿ��� ��ü ����
		SELECT c3.country_id , c3.country , c.customer_id , c.first_name , c.last_name , r.rental_id 
		FROM rental r 
		JOIN customer c ON r.customer_id = c.customer_id
		JOIN address a ON c.address_id = a.address_id 
		JOIN city c2 ON a.city_id = c2.city_id
		JOIN country c3 ON c2.country_id = c3.country_id ) AS db 
	GROUP BY db.country, db.first_name, db.last_name ) AS db2
WHERE db2.ranking <= 5 ;



����9��) ��ȭ ī�װ� (Category) ���� �뿩�� ���� ���� �� ��ȭ TOP 5�� ���ϼ���	 Ǯ��

SELECT *
FROM (
	SELECT DB.NAME, DB.TITLE , 
		COUNT(DISTINCT DB.RENTAL_ID) AS CNT ,
		ROW_NUMBER() OVER( PARTITION BY DB.NAME ORDER BY COUNT(DISTINCT DB.RENTAL_ID) DESC, DB.TITLE ASC ) AS RANKING -- ī�װ�����: PARTITION BY
	FROM (
		SELECT r.rental_id , i.film_id , f.title , fc.category_id , c."name" 
		FROM rental r 
		JOIN inventory i ON r.inventory_id = i.inventory_id 
		JOIN film f ON i.film_id = f.film_id 
		JOIN film_category fc ON i.film_id = fc.film_id 
		JOIN category c ON fc.category_id = c.category_id ) AS DB 
	GROUP BY DB.NAME, DB.TITLE ) AS DB2
WHERE RANKING <= 5 ;

����10��) ������ ���� ���� ��ȭ ī�װ��� ������ ���� ���� ��ȭ ī�װ��� ���ϼ���. (first_value, last_value)	 Ǯ��

SELECT *
FROM (
	SELECT c."name", SUM(p.amount) AS SUM_AMT ,
		FIRST_VALUE(c."name") OVER (ORDER BY SUM(p.amount) ASC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING ) AS FIRST_VALUES,
		LAST_VALUE (c."name") OVER (ORDER BY SUM(p.amount) ASC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING ) AS LAST_VALUES -- ���� ����.
	FROM payment p 
	JOIN rental r ON p.rental_id = r.rental_id 
	JOIN inventory i ON r.inventory_id = i.inventory_id 
	JOIN film f ON i.film_id = f.film_id 
	JOIN film_category fc ON i.film_id = fc.film_id 
	JOIN category c ON fc.category_id = c.category_id
	GROUP BY c."name" ) AS DB
WHERE NAME IN (FIRST_VALUES, LAST_VALUES);

