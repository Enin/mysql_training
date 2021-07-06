문제1번) 대여점(store)별 영화 재고(inventory) 수량과 전체 영화 재고 수량은? (grouping set)	 

SELECT i.store_id , COUNT(DISTINCT inventory_id) AS CNT
FROM inventory i
GROUP BY GROUPING SETS ((store_id), ()) ;

문제2번) 대여점(store)별 영화 재고(inventory) 수량과 전체 영화 재고 수량은? (rollup)	 

SELECT i.store_id, COUNT(DISTINCT inventory_id) AS CNT
FROM inventory i 
GROUP BY ROLLUP (store_id) ;

문제3번) 국가(country)별 도시(city)별 매출액, 국가(country)매출액 소계 그리고 전체 매출액을 구하세요. (grouping set)	풀이

SELECT c3.country , c2.city , SUM(p.amount)
FROM payment p
JOIN customer c ON p.customer_id = c.customer_id -- 필요한 테이블을 모두 조인한다.
JOIN address a ON c.address_id = a.address_id 
JOIN city c2 ON a.city_id = c2.city_id 
JOIN country c3 ON c2.country_id = c3.country_id 
GROUP BY GROUPING SETS ((c3.country, c2.city) , (c3.country), ()) ; -- 그룹 셋을 사용하여 항목별 집계결과를 출력. 빈공백은 전체 매출액


문제4번) 국가(country)별 도시(city)별 매출액, 국가(country)매출액 소계 그리고 전체 매출액을 구하세요. (rollup)	풀이

SELECT c3.country , c2.city , SUM(p.amount)
FROM payment p
JOIN customer c ON p.customer_id = c.customer_id -- 필요한 테이블을 모두 조인한다.
JOIN address a ON c.address_id = a.address_id 
JOIN city c2 ON a.city_id = c2.city_id 
JOIN country c3 ON c2.country_id = c3.country_id 
GROUP BY ROLLUP (c3.country, c2.city) ; -- ROLLUP은 입력의 하위 조합까지 전부 출력해준다. 위의 GROUPING SETS 보다 간단. 


문제5번) 영화배우별로  출연한 영화 count 수 와,   모든 배우의 전체 출연 영화 수를 합산 해서 함께 보여주세요.	풀이

-- 전체값 합산 > ROLLUP사용
SELECT actor_id , COUNT(DISTINCT film_id) AS CNT
FROM film_actor fa 
GROUP BY
	ROLLUP(actor_id) -- GROUPING SETS ((ACTOR_ID, ()) 도 가능.
ORDER BY CNT DESC;


문제6번) 국가 (Country)별, 도시(City)별  고객의 수와 ,  전체 국가별 고객의 수를 함께 보여주세요. (grouping sets)	

SELECT c3.country , c2.city , count(c.customer_id) AS CNT
FROM customer c 
JOIN address a ON c.address_id = a.address_id 
JOIN city c2 ON a.city_id = c2.city_id 
JOIN country c3 ON c2.country_id = c3.country_id 
GROUP BY GROUPING SETS ( (c3.country) , (c3.country, c2.city), ()) ;


문제7번) 영화에서 사용한 언어와  영화 개봉 연도 에 대한 영화  갯수와  , 영화 개봉 연도에 대한 영화 갯수를 함께 보여주세요.	풀이

-- 개봉 연도 갯수, 영화 연도 갯수 각각. LANGUAGE_ID, RELEASE_YEAR
SELECT language_id , release_year , COUNT(DISTINCT film_id) AS CNT
FROM film f 
GROUP BY GROUPING SETS ((language_id, release_year), (release_year)) ;


문제8번) 연도별, 일별 결제  수량과,  연도별 결제 수량을 함께 보여주세요.
 - 결제수량은  결제 의 id 갯수 를 의미합니다.	
 
SELECT to_char(p.payment_date, 'yyyy') as YEAR, 
	   to_char(p.payment_date, 'dd') AS DAY, 
	   count(DISTINCT p.payment_id) AS CNT 
FROM payment p 
GROUP BY GROUPING SETS ( (to_char(p.payment_date, 'yyyy'), to_char(p.payment_date, 'dd')),
						 (to_char(p.payment_date, 'yyyy')) ) ;



문제9번) 지점 별,  active 고객의 수와 ,   active 고객 수 를  함께 보여주세요.  풀이
 지점과, active 여부에 대해서는 customer 테이블을 이용하여 보여주세요.
 -  grouping sets 를 이용해서 풀이해주세요.	
 
SELECT store_id , active , COUNT(DISTINCT customer_id) AS CNT
FROM customer c 
GROUP BY GROUPING SETS ((store_id, active), (active)) ;


문제10번) 지점 별,  active 고객의 수와 ,   active 고객 수 를  함께 보여주세요. 
 지점과, active 여부에 대해서는 customer 테이블을 이용하여 보여주세요.
 -  roll up으로 풀이해보면서,  grouping sets 과의 차이를 확인해보세요.	
 
SELECT c.store_id , c.active , count(c.customer_id)
FROM customer c 
GROUP BY 
ROLLUP (c.store_id, c.active) ; -- 전체 결과가 무조건 같이 나옴.
 