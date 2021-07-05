문제1번) 매출을 가장 많이 올린 dvd 고객 이름은? (subquery 활용)	 

SELECT c.first_name , c.last_name 
FROM customer c 
WHERE c.customer_id IN( -- IN 절로 사용할때 밖의 컬럼과 서브쿼리 컬럼 수를 동일하게 맞춰야한다.
	-- 매출이 가장 많은 사람.
	SELECT customer_id --, SUM(p.amount) AS SUM_AMOUNT
	FROM payment p 
	GROUP BY customer_id 
	ORDER BY SUM(p.amount) DESC 
	LIMIT 1 ) ;


문제2번) 대여가 한번도이라도 된 영화 카테 고리 이름을 알려주세요. (쿼리는, Exists조건을 이용하여 풀어봅시다)

SELECT c.name
FROM category c 
WHERE EXISTS ( -- 대여가 한번이라도 수행된 카테고리
	SELECT 1 -- DISTINCT r.rental_id , i.film_id , fc.category_id 
	FROM rental r 
	JOIN inventory i ON r.inventory_id = i.inventory_id 
	JOIN film_category fc ON i.film_id = fc.film_id 
	WHERE c.category_id = fc.category_id -- exists 필수. 메인쿼리 컬럼과 서브쿼리의 비교할 값과 동일하게 where절로 지정.
) ;


문제3번) 대여가 한번도이라도 된 영화 카테 고리 이름을 알려주세요. (쿼리는, Any 조건을 이용하여 풀어봅시다)

SELECT c.name
FROM category c 
WHERE category_id = ANY ( -- ANY 연산자를 사용하면 대여가 한번이라도 비교할 컬럼을 1:1로 매치해준다.
	SELECT fc.category_id 
	FROM rental r 
	JOIN inventory i ON r.inventory_id = i.inventory_id 
	JOIN film_category fc ON i.film_id = fc.film_id 
) ;

 
문제4번) 대여가 가장 많이 진행된 카테고리는 무엇인가요? (Any, All 조건 중 하나를 사용하여 풀어봅시다)	

select * from rental r ;
select * from inventory i ;

SELECT c."name" 
FROM category c  
WHERE c.category_id = ANY(
	SELECT fc.category_id 
	FROM rental r 
	JOIN inventory i ON r.inventory_id = i.inventory_id 
	JOIN film_category fc ON i.film_id = fc.film_id 
	GROUP BY fc.category_id 
	order by count(DISTINCT r.rental_id) desc
	LIMIT 1 );

 
문제5번) dvd 대여를 제일 많이한 고객 이름은? (subquery 활용)	

SELECT c.first_name, c.last_name
FROM customer c 
WHERE c.customer_id IN (
	SELECT customer_id 
	FROM rental r
	GROUP BY customer_id 
	ORDER BY COUNT(DISTINCT r.rental_id) DESC
	LIMIT 1 );
	

문제6번) 영화 카테고리값이 존재하지 않는 영화가 있나요?	   

SELECT *
FROM film f
WHERE f.film_id NOT IN (
	SELECT film_id 
	FROM film_category fc 
	);

SELECT *
FROM film f
WHERE NOT EXISTS (
	SELECT 1
	FROM film_category fc 
	WHERE fc.film_id = f.film_id 
	);


-- not in, not exists 차이

select *
from address a 
where not exists ( -- Null 값을 탐색할 수 있음. 같지 않은 모든 데이터를 출력하므로.
	select 1
	from ( 
		select '' as a -- 공백일때 1을 리턴하는 서브쿼리. NULL 값이라면 0이 들어갈 것 > NOT EXISTS에서 0인 결과만 출력됨.
		) as db
		where db.a = a.address2 );
	
SELECT *
FROM address a 
WHERE address2 NOT IN (SELECT '') ; -- 빈값을 탐색. NULL을 찾을 수 없음.
