문제1번) store 별로 staff는 몇명이 있는지 확인해주세요.	

SELECT store_id , count(manager_staff_id) as cnt 
FROM store s 
GROUP BY store_id ;


문제2번) 영화등급(rating) 별로 몇개 영화film을 가지고 있는지 확인해주세요.	풀이

SELECT f.rating 
	 , COUNT(f.film_id) AS FILM_CNT
FROM film f 
GROUP BY f.rating ;


문제3번) 출현한 영화배우(actor)가  10명 초과한 영화명은 무엇인가요?	

SELECT *
FROM film f ;

SELECT *
FROM film_actor fa ;

SELECT fa.film_id , count(fa.actor_id) as cnt
FROM film_actor fa 
GROUP BY film_id 
HAVING count(fa.actor_id) > 10 ;

SELECT f.title, db.cnt
FROM film f 
JOIN (	SELECT fa.film_id , count(fa.actor_id) as cnt
		FROM film_actor fa 
		GROUP BY film_id 
		HAVING count(fa.actor_id) > 10 ) as db 
	ON f.film_id = db.film_id ;

문제4번) 영화 배우(actor)들이 출연한 영화는 각각 몇 편인가요?  풀이
- 영화 배우의 이름 , 성 과 함께 출연 영화 수를 알려주세요.	

SELECT actor_id , COUNT(DISTINCT film_id) AS CNT_FILM_ID
FROM film_actor fa 
GROUP BY actor_id ;

-- 2차. 1차 데이터셋과 ACTOR를 조인하여 이름을 획득.
SELECT d.*, a.first_name , a.last_name 
FROM ( -- 1차. ACTOR_ID별로 GROUP 하는 데이터셋.
	SELECT actor_id , COUNT(DISTINCT film_id) AS FILM_CNT
	FROM film_actor fa 
	GROUP BY actor_id ) AS d
LEFT OUTER JOIN actor a ON d.actor_id = a.actor_id -- ACTOR ID가 데이터가 없을 수도 있어서 OUTER 조인.
ORDER BY actor_id ;

문제5번) 국가(country)별 고객(customer) 는 몇명인가요?	풀이

SELECT * FROM customer c ;

SELECT cn.country 
	 , COUNT(c.customer_id) AS CNT_CUSTOMER
FROM customer c 
JOIN address a ON c.address_id = a.address_id 
JOIN city ct ON a.city_id = ct.city_id 
JOIN country cn ON ct.country_id = cn.country_id 
GROUP BY cn.country 
HAVING COUNT(c.customer_id) >= 30
ORDER BY COUNT(c.customer_id) DESC ;

문제6번) 영화 재고 (inventory) 수량이 3개 이상인 영화(film) 는? 
- store는 상관 없이 확인해주세요.	

SELECT i.film_id , COUNT(inventory_id) as CNT
FROM inventory i 
GROUP BY i.film_id
HAVING COUNT(inventory_id) >= 3
ORDER BY film_id ;

SELECT f.title , DB.CNT
FROM ( SELECT i.film_id , COUNT(inventory_id) as CNT
		FROM inventory i 
		GROUP BY i.film_id
		HAVING COUNT(inventory_id) >= 3
		ORDER BY film_id) AS DB
JOIN film f ON DB.film_id = f.film_id 

SELECT * FROM inventory i ;

문제7번) dvd 대여를 제일 많이한 고객 이름은?	 

SELECT r.customer_id , count(r.rental_id) AS CNT 
FROM rental r 
GROUP BY r.customer_id ;

SELECT c.first_name , c.last_name , DB.CNT
FROM ( SELECT r.customer_id , count(r.rental_id) AS CNT 
		FROM rental r 
		GROUP BY r.customer_id ) AS DB
JOIN customer c ON DB.customer_id = c.customer_id ;

문제8번) rental 테이블을  기준으로,   2005년 5월26일에 대여를 기록한 고객 중, 하루에 2번 이상 대여를 한 고객의 ID 값을 확인해주세요.	풀이

SELECT * FROM rental r ;

SELECT r.customer_id , COUNT(DISTINCT rental_id) AS CNT_RENTAL
FROM rental r 
WHERE r.rental_date BETWEEN '2005-05-26 00:00:00' AND '2005-05-26 23:59:59' -- 1차 제한조건
GROUP BY r.customer_id
HAVING COUNT(DISTINCT rental_id) >= 2 ; -- 2차 제한 조건 & 그룹으로 피벗테이블 만든 후 제한조건 추가.

문제9번) film_actor 테이블을 기준으로, 출현한 영화의 수가 많은  5명의 actor_id 와 , 출현한 영화 수 를 알려주세요.	풀이

SELECT actor_id , COUNT(film_id) AS CNT
FROM film_actor fa
GROUP BY actor_id -- 중복되는 값을 하나로 묶을때.
ORDER BY COUNT(film_id) DESC 
LIMIT 5 ;

문제10번) payment 테이블을 기준으로,  결제일자가 2007년2월15일에 해당 하는 주문 중에서  ,  하루에 2건 이상 주문한 고객의  총 결제 금액이 10달러 이상인 고객에 대해서 알려주세요.  
(고객의 id,  주문건수 , 총 결제 금액까지 알려주세요)	

SELECT p.* 
FROM payment p
WHERE DATE(p.payment_date) = '2007-02-15' ;

SELECT p.customer_id , COUNT(p.rental_id) AS CNT , SUM(p.amount) AS SUM
FROM payment p
WHERE DATE(p.payment_date) = '2007-02-15' 
GROUP BY p.customer_id 
HAVING COUNT(p.rental_id) >= 2 AND SUM(p.amount) > 10 ;

문제11번) 사용되는 언어별 영화 수는?	

SELECT * FROM "language" l ;
SELECT * FROM film f where language_id != 1 ;

SELECT f.language_id , COUNT(f.film_id) AS CNT
FROM film f 
JOIN "language" l ON f.language_id = l.language_id 
GROUP BY f.language_id ;

SELECT l2.NAME , DB.CNT
FROM (
		SELECT f.language_id , COUNT(f.film_id) AS CNT
		FROM film f 
		JOIN "language" l ON f.language_id = l.language_id 
		GROUP BY f.language_id ) AS DB
JOIN "language" l2 ON DB.language_id = l2.language_id ;

문제12번) 40편 이상 출연한 영화 배우(actor) 는 누구인가요?	

SELECT * FROM actor a ;
SELECT * FROM film_actor fa ;

SELECT fa.actor_id , COUNT(fa.film_id) AS CNT
FROM film_actor fa 
GROUP BY fa.actor_id 
HAVING COUNT(fa.film_id) >= 40 ;

SELECT a.first_name, a.last_name, DB.CNT
FROM actor a 
JOIN (	SELECT fa.actor_id , COUNT(fa.film_id) AS CNT
		FROM film_actor fa 
		GROUP BY fa.actor_id 
		HAVING COUNT(fa.film_id) >= 40 ) AS DB
	ON a.actor_id = DB.actor_id ;

문제13번) 고객 등급별 고객 수를 구하세요. (대여 금액 혹은 매출액  에 따라 고객 등급을 나누고 조건은 아래와 같습니다.) 풀이
/*
A 등급은 151 이상 
B 등급은 101 이상 150 이하 
C 등급은   51 이상 100 이하
D 등급은   50 이하

* 대여 금액의 소수점은 반올림 하세요. 

HINT
반올림 하는 함수는 ROUND 입니다.	
*/

SELECT *
FROM rental r 
ORDER BY rental_id ;

SELECT * FROM payment p ;



-->고객 별 금액 정리
SELECT p.customer_id , ROUND(SUM(p.amount), 0) AS SUM_AMOUNT 
	 , CASE WHEN ROUND(SUM(p.amount), 0) >= 151 THEN 'A'
	 		WHEN ROUND(SUM(p.amount), 0) BETWEEN 101 AND 150 THEN 'B'
	 		WHEN ROUND(SUM(p.amount), 0) BETWEEN 51 AND 100 THEN 'C'
	 		WHEN ROUND(SUM(p.amount), 0) <= 50 THEN 'D'
 			ELSE 'EMPTY' END CUS_RATING
FROM rental r 
JOIN payment p ON r.customer_id = p.customer_id 
			   AND r.rental_id = p.rental_id 
			   --AND r.staff_id = p.staff_id -- 일치 안함(제거)
GROUP BY p.customer_id ;

--> 2차 CASE 구문
SELECT DB.customer_id
	 , CASE WHEN DB.SUM_AMOUNT >= 151 THEN 'A'
	 		WHEN DB.SUM_AMOUNT BETWEEN 101 AND 150 THEN 'B' -- BETWEEN 작은값 AND 큰값
	 		WHEN DB.SUM_AMOUNT BETWEEN 51 AND 100 THEN 'C'
	 		WHEN DB.SUM_AMOUNT <= 50 THEN 'D'
 			ELSE 'EMPTY' END CUS_RATING
--> 1차 테이블을 만들어옴.
FROM (  SELECT p.customer_id , ROUND(SUM(p.amount), 0) AS SUM_AMOUNT 
		FROM rental r 
		JOIN payment p ON r.customer_id = p.customer_id 
					   AND r.rental_id = p.rental_id 
					   --AND r.staff_id = p.staff_id -- 일치 안함(제거)
		GROUP BY p.customer_id ) AS DB ;
	
	
-- 레이팅 기준으로 CUSTOMER 갯수를 센다.
SELECT DB.CUS_RATING, COUNT(DB.CUSTOMER_ID) AS CNT
FROM (SELECT p.customer_id , ROUND(SUM(p.amount), 0) AS SUM_AMOUNT 
			 , CASE WHEN ROUND(SUM(p.amount), 0) >= 151 THEN 'A'
			 		WHEN ROUND(SUM(p.amount), 0) BETWEEN 101 AND 150 THEN 'B'
			 		WHEN ROUND(SUM(p.amount), 0) BETWEEN 51 AND 100 THEN 'C'
			 		WHEN ROUND(SUM(p.amount), 0) <= 50 THEN 'D'
		 			ELSE 'EMPTY' END CUS_RATING
		FROM rental r 
		JOIN payment p ON r.customer_id = p.customer_id 
					   AND r.rental_id = p.rental_id 
					   --AND r.staff_id = p.staff_id -- 일치 안함(제거)
		GROUP BY p.customer_id ) AS DB 
GROUP BY DB.CUS_RATING ;

-- 조인 없이 페이먼트 테이블만 사용해도 무방했음. 직접해보기
SELECT *
FROM payment p ;

-- ID 별로 AMOUNT를 SUM한다.

SELECT p.customer_id, round(SUM(p.amount), 0) AS SUM_AMT
FROM payment p 
GROUP BY p.customer_id ;

SELECT CASE WHEN SUM_AMT >= 151 THEN 'A' -- 2차 AMT 별로 등급을 나눔
	 		WHEN SUM_AMT BETWEEN 101 AND 150 THEN 'B'
	 		WHEN SUM_AMT BETWEEN 51 AND 100 THEN 'C'
	 		ELSE 'D' END CUS_RATE	 
	 , COUNT(DB.customer_id) -- 등급 별 갯수
FROM (	SELECT p.customer_id, round(SUM(p.amount), 0) AS SUM_AMT -- 1차. ID별 AMOUNT 계산
		FROM payment p 
		GROUP BY p.customer_id) AS DB
GROUP BY CASE WHEN SUM_AMT >= 151 THEN 'A' -- 등급별로 그룹
	 		WHEN SUM_AMT BETWEEN 101 AND 150 THEN 'B'
	 		WHEN SUM_AMT BETWEEN 51 AND 100 THEN 'C'
	 		ELSE 'D' END -- 이때 얼라이스
ORDER BY CUS_RATE ; -- 등급순으로 정렬.



