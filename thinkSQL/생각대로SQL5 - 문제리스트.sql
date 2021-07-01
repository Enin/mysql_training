문제1번) 영화 배우가,  영화 180분 이상의 길이 의 영화에 출연하거나, 영화의 rating 이 R 인 등급에 해당하는 영화에 출연한  영화 배우에 대해서,  
영화 배우 ID 와 (180분이상 / R등급영화)에 대한 Flag 컬럼을 알려주세요. 
- 1) film_actor 테이블와 film 테이블을 이용하세요.
- 2) union, unionall,  intersect,  except 중 상황에 맞게 사용해주세요. 
- 3) actor_id 가 동일한 flag 값 이 여러개 나오지 않도록 해주세요.	풀이

SELECT *
FROM film_actor fa ;

SELECT * FROM film f ;

-- 180 이상의 길이의 영화에 출연한 영화배우 테이블
SELECT actor_id , 'over_length_180' as flag
FROM film_actor fa 
WHERE film_id IN ( -- 180 분 이상의 영화
	SELECT f.film_id 
	FROM film f 
	WHERE f.length >= 180 ) 
UNION -- 두 쿼리를 union을 사용하여 합침. UNION은 DISTINCT가 자동으로 적용됨(중복제거)
-- R 등급에 해당하는 영화에 출연한 영화배우
SELECT actor_id , 'rating_R' as flag
FROM film_actor fa 
WHERE film_id IN ( -- R등급 영화에 출연한 배우
	SELECT f.film_id 
	FROM film f 
	WHERE f.rating = 'R' ) 
ORDER BY actor_id ;




문제2번) R등급의 영화에 출연했던 배우이면서, 동시에, Alone Trip의 영화에 출연한  영화배우의 ID 를 확인해주세요.
- 1) film_actor 테이블와 film 테이블을 이용하세요.
- 2) union, unionall,  intersect,  except 중 상황에 맞게 사용해주세요. 

-- 동시에 > INTERSECT를 사용하여 교집합을 구해본다.
SELECT actor_id 
FROM film_actor fa 
WHERE film_id IN ( -- Alone Trip에 출연한 배우
	SELECT f.film_id 
	FROM film f 
	WHERE f.title = 'Alone Trip') 
INTERSECT -- 두 쿼리를 union을 사용하여 합침. UNION은 DISTINCT가 자동으로 적용됨(중복제거)
-- R 등급에 해당하는 영화에 출연한 영화배우
SELECT actor_id 
FROM film_actor fa 
WHERE film_id IN ( -- R등급 영화에 출연한 배우
	SELECT f.film_id 
	FROM film f 
	WHERE f.rating = 'R' ) 
ORDER BY actor_id ;



문제3번) G 등급에 해당하는 필름을 찍었으나,   영화를 20편이상 찍지 않은 영화배우의 ID 를 확인해주세요.
- 1) film_actor 테이블와 film 테이블을 이용하세요.
- 2) union, unionall,  intersect,  except 중 상황에 맞게 사용해주세요. 

-- G등급을 찍은 영화배우
SELECT actor_id
FROM film_actor fa 
WHERE film_id IN( 
	SELECT f.film_id
	FROM film f 
	WHERE f.rating = 'G' )
EXCEPT 
-- 영화를 20편 이상 찍은 배우는 제외
SELECT DB.actor_id 
FROM (SELECT fa2.actor_id, COUNT(fa2.film_id) AS CNT
		FROM film_actor fa2 
		GROUP BY fa2.actor_id 
		HAVING COUNT(fa2.film_id) >= 20 ) AS DB 
ORDER BY actor_id;


-- 영화를 20편 이상 찍은 배우
SELECT actor_id, COUNT(film_id) AS CNT
FROM film_actor fa 
GROUP BY actor_id 
HAVING COUNT(film_id) >= 20;
				


문제4번) 필름 중에서,  필름 카테고리가 Action, Animation, Horror 에 해당하지 않는 필름 아이디를 알려주세요. 풀이
- category  테이블을 이용해서 알려주세요.	

-- 해당하지않는 > 차집합 사용
SELECT *
FROM film f ;

SELECT * FROM film_category fc ;

SELECT * FROM category c ;

SELECT film_id -- SELECT 할 칼럼이 동일해야 결과를 얻을 수 있음.
FROM film f 
EXCEPT
SELECT f.film_id -- ACTION, ANIMATION, HORROR를 갖는 집합을 구함.
FROM film f 
JOIN film_category fc ON f.film_id = fc.film_id 
JOIN category c ON fc.category_id = c.category_id 
WHERE c."name" IN ('Action', 'Animation', 'Horror') ;


문제5번) Staff  의  id , 이름, 성 에 대한 데이터와 , Customer 의 id, 이름 , 성에 대한 데이터를  하나의  데이터셋의 형태로 보여주세요. 풀이
 - 컬럼 구성 : id, 이름 , 성,   flag (직원/고객여부)  로 구성해주세요.
 
SELECT s.staff_id , s.first_name , s.last_name , 'Staff' as flag
FROM staff s 
UNION ALL -- 중복을 제거하지 않고 두 컬럼을 전부 합쳐버린다.
SELECT c.customer_id , c.first_name , c.first_name , 'Customer' as flag
FROM customer c ;


문제6번) 직원과  고객의 이름이 동일한 사람이 혹시 있나요? 있다면, 해당 사람의 이름과 성을 알려주세요.	풀이

SELECT first_name
FROM staff s 
INTERSECT
SELECT first_name
FROM customer c ;

문제7번) 반납이 되지 않은 대여점(store)별 영화 재고 (inventory)와 전체 영화 재고를 같이 구하세요. (union all)	 

SELECT * FROM inventory i ;
SELECT * FROM rental r ;
SELECT * FROM store s ;

-- 반납되지 않은 대여점 별 영화 재고
SELECT i.store_id , COUNT(i.inventory_id) AS INVENTORY_CNT
FROM rental r 
JOIN inventory i ON r.inventory_id = i.inventory_id 
WHERE r.return_date IS NULL
GROUP BY i.store_id 
UNION ALL
-- 전체 영화 재고
SELECT NULL, COUNT(i.inventory_id)
FROM inventory i ;


문제8번) 국가(country)별 도시(city)별 매출액, 국가(country)매출액 소계 그리고 전체 매출액을 구하세요. (union all)	 풀이

SELECT *
FROM payment p ;

-- UNION 시에는 모든 컬럼이 동일해야한다.
-- 고객이 어느 지역에 살고 있는 지 확인: 고객, 도시, 국가, 매출액
SELECT c.customer_id , c2.city , c3.country , p.amount 
FROM payment p 
JOIN customer c ON p.customer_id = c.customer_id 
JOIN address a ON c.address_id = a.address_id 
JOIN city c2 ON a.city_id = c2.city_id 
JOIN country c3 ON c2.country_id = c3.country_id ;

-- 1. 국가별 도시별 매출액
SELECT country, city, SUM(amount) AS SUM
FROM ( 
	SELECT c.customer_id , c2.city , c3.country , p.amount 
	FROM payment p 
	JOIN customer c ON p.customer_id = c.customer_id 
	JOIN address a ON c.address_id = a.address_id 
	JOIN city c2 ON a.city_id = c2.city_id 
	JOIN country c3 ON c2.country_id = c3.country_id ) AS DB
GROUP BY country, city 
-- 2. 국가 매출액 소계
UNION ALL
SELECT country, NULL , SUM(amount) AS SUM
FROM ( 
	SELECT c.customer_id , c2.city , c3.country , p.amount 
	FROM payment p 
	JOIN customer c ON p.customer_id = c.customer_id 
	JOIN address a ON c.address_id = a.address_id 
	JOIN city c2 ON a.city_id = c2.city_id 
	JOIN country c3 ON c2.country_id = c3.country_id ) AS DB
GROUP BY country
-- 3. 전체 매출액 
UNION ALL
SELECT NULL, NULL, SUM(amount) AS SUM -- 컬럼을 맞추기 위하여 NULL을 사용해 임시로 값이 없는 컬럼을 지정해준다.
FROM ( 
	SELECT c.customer_id , c2.city , c3.country , p.amount 
	FROM payment p 
	JOIN customer c ON p.customer_id = c.customer_id 
	JOIN address a ON c.address_id = a.address_id 
	JOIN city c2 ON a.city_id = c2.city_id 
	JOIN country c3 ON c2.country_id = c3.country_id ) AS DB ;

