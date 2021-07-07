문제1번) dvd 대여를 제일 많이한 고객 이름은? (analytic funtion 활용)	

SELECT c.customer_id , c.first_name , c.last_name ,
	COUNT(r.rental_id) AS CNT ,
	ROW_NUMBER() OVER( ORDER BY COUNT(r.rental_id) DESC ) AS RANKS
FROM rental r 
JOIN customer c ON r.customer_id = c.customer_id 
GROUP BY c.customer_id 
LIMIT 1;

문제2번) 매출을 가장 많이 올린 dvd 고객 이름은? (analytic funtion 활용)	풀이

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


문제3번) dvd 대여가 가장 적은 도시는? (anlytic funtion)	

SELECT c2.city_id , c2.city , COUNT(r.rental_id) AS CNT ,
	RANK() OVER( ORDER BY COUNT(r.rental_id) ASC) AS RANKING
FROM rental r 
JOIN customer c ON r.customer_id = c.customer_id 
JOIN address a ON c.address_id = a.address_id 
JOIN city c2 ON a.city_id = c2.city_id 
GROUP BY c2.city_id 
LIMIT 1;

SELECT * FROM city c ;


문제4번) 매출이 가장 안나오는 도시는? (anlytic funtion)	

SELECT c2.city_id , c2.city , SUM(p.amount) AS A_SUM ,
	DENSE_RANK() OVER( ORDER BY SUM(p.amount) ) AS RANKING
FROM payment p 
JOIN customer c ON p.customer_id = c.customer_id 
JOIN address a ON c.address_id = a.address_id 
JOIN city c2 ON a.city_id = c2.city_id 
GROUP BY c2.city_id LIMIT 1;

문제5번) 월별 매출액을 구하고 이전 월보다 매출액이 줄어든 월을 구하세요. (일자는 payment_date 기준)	 풀이

SELECT *
FROM (
	SELECT EXTRACT(YEAR FROM DATE(p.PAYMENT_DATE)) AS YR, -- EXTRACT 함수로 DATE(P.PAYMENT_DATE) 에서 YEAR, MONTH, DAY 에 대한 날짜를 찾아옴
		   EXTRACT(MONTH FROM DATE(p.PAYMENT_DATE)) AS MON, -- TO_CHAR(P.PAYMENT_DATE, 'YYYY') 사용해도 됨.
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
	SELECT EXTRACT(YEAR FROM DATE(p.PAYMENT_DATE)) AS YR, -- EXTRACT 함수로 DATE(P.PAYMENT_DATE) 에서 YEAR, MONTH, DAY 에 대한 날짜를 찾아옴
		   EXTRACT(MONTH FROM DATE(p.PAYMENT_DATE)) AS MON, -- TO_CHAR(P.PAYMENT_DATE, 'YYYY') 사용해도 됨.
		   SUM(p.AMOUNT) AS SUM_AMOUNT ,
		   COALESCE( LAG(SUM(p.AMOUNT), 1) OVER( ORDER BY EXTRACT(YEAR FROM DATE(p.PAYMENT_DATE))) , 0) AS PRE_MON_AMOUNT
	FROM payment p 
	GROUP BY EXTRACT(YEAR FROM DATE(p.PAYMENT_DATE)) ,
		     EXTRACT(MONTH FROM DATE(p.PAYMENT_DATE))
     ) AS DB
WHERE sum_amount < pre_mon_amount ;

문제6번) 도시별 dvd 대여 매출 순위를 구하세요. 

SELECT c2.city_id , c2.city , SUM(p.amount) AS A_SUM ,
	ROW_NUMBER () OVER ( ORDER BY SUM(p.amount) DESC ) AS RANKING
FROM payment p 
JOIN customer c ON p.customer_id = c.customer_id 
JOIN address a ON c.address_id = a.address_id 
JOIN city c2 ON a.city_id = c2.city_id 
GROUP BY c2.city_id ;

문제7번) 대여점별 매출 순위를 구하세요.	풀이

SELECT i.store_id , SUM(p.amount) AS SUM_AMOUNT ,
	ROW_NUMBER () OVER ( ORDER BY SUM(p.amount) DESC ) AS SUM_AMOUNT_RANK
FROM payment p 
JOIN rental r ON p.rental_id = r.rental_id 
JOIN inventory i ON r.inventory_id = i.inventory_id 
GROUP BY i.store_id ;


문제8번) 나라별로 가장 대여를 많이한 고객 TOP 5를 구하세요. 	


-- 나라별 가장 고객 대여 횟수 랭킹
SELECT *
FROM(
	SELECT db.country, db.first_name, db.last_name,	COUNT(DISTINCT db.rental_id) as rental_cnt ,
		ROW_NUMBER () OVER ( PARTITION BY db.country ORDER BY COUNT(DISTINCT db.rental_id) DESC) AS RANKING
	FROM( -- 서브쿼리1 필요한 전체 집합
		SELECT c3.country_id , c3.country , c.customer_id , c.first_name , c.last_name , r.rental_id 
		FROM rental r 
		JOIN customer c ON r.customer_id = c.customer_id
		JOIN address a ON c.address_id = a.address_id 
		JOIN city c2 ON a.city_id = c2.city_id
		JOIN country c3 ON c2.country_id = c3.country_id ) AS db 
	GROUP BY db.country, db.first_name, db.last_name ) AS db2
WHERE db2.ranking <= 5 ;



문제9번) 영화 카테고리 (Category) 별로 대여가 가장 많이 된 영화 TOP 5를 구하세요	 풀이

SELECT *
FROM (
	SELECT DB.NAME, DB.TITLE , 
		COUNT(DISTINCT DB.RENTAL_ID) AS CNT ,
		ROW_NUMBER() OVER( PARTITION BY DB.NAME ORDER BY COUNT(DISTINCT DB.RENTAL_ID) DESC, DB.TITLE ASC ) AS RANKING -- 카테고리별로: PARTITION BY
	FROM (
		SELECT r.rental_id , i.film_id , f.title , fc.category_id , c."name" 
		FROM rental r 
		JOIN inventory i ON r.inventory_id = i.inventory_id 
		JOIN film f ON i.film_id = f.film_id 
		JOIN film_category fc ON i.film_id = fc.film_id 
		JOIN category c ON fc.category_id = c.category_id ) AS DB 
	GROUP BY DB.NAME, DB.TITLE ) AS DB2
WHERE RANKING <= 5 ;

문제10번) 매출이 가장 많은 영화 카테고리와 매출이 가장 작은 영화 카테고리를 구하세요. (first_value, last_value)	 풀이

SELECT *
FROM (
	SELECT c."name", SUM(p.amount) AS SUM_AMT ,
		FIRST_VALUE(c."name") OVER (ORDER BY SUM(p.amount) ASC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING ) AS FIRST_VALUES,
		LAST_VALUE (c."name") OVER (ORDER BY SUM(p.amount) ASC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING ) AS LAST_VALUES -- 범위 지정.
	FROM payment p 
	JOIN rental r ON p.rental_id = r.rental_id 
	JOIN inventory i ON r.inventory_id = i.inventory_id 
	JOIN film f ON i.film_id = f.film_id 
	JOIN film_category fc ON i.film_id = fc.film_id 
	JOIN category c ON fc.category_id = c.category_id
	GROUP BY c."name" ) AS DB
WHERE NAME IN (FIRST_VALUES, LAST_VALUES);

