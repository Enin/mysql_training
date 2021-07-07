-- select 실습
select *
from customer;

select A.first_name, A.last_name, A.email
from customer A;

select a.first_name, a.last_name, a.email
from customer
order by a.first_name desc ; -- 지정한 컬럼을 기준으로 오름차순/내림차순 정렬한다.

select first_name, last_name
from customer
order by first_name, last_name desc;

select first_name, last_name
from customer
order by 1, 2 desc; -- 들어온 순서대로 숫자로 컬럼을 지정할 수 도 있음.

-- select distinct 중복제거 옵션
select distinct bcolor -- 해당 컬럼에 중복값이 있을경우 중복을 제거. null 도 표시됨.
from t1
order by bcolor ;

select distinct on (bcolor) bcolor, fcolor -- on(컬럼) 기준으로 제거된 값이 기준집합이 된다.
from t1
order by bcolor, fcolor  ; -- 컬럼 2개 이상 있을때 on(컬럼)을 사용


select last_name, first_name
from customer
where first_name = 'Jamie'; -- where <조건> 을 만족하는 컬럼을 출력.

SELECT last_name, first_name
FROM customer
WHERE first_name = 'Jamie' -- where <조건> 을 만족하는 컬럼을 출력.
AND last_name = 'Rice'; -- AND, OR 문을 사용하여 조건을 추가할 수 있음.

SELECT CUSTOMER_ID, AMOUNT, PAYMENT_DATE
FROM PAYMENT 
WHERE AMOUNT <= 1 OR AMOUNT >= 8 ;	-- AMOUNT가 1이하 또는 8이상인 값을 출력.


SELECT film_id, title, release_year
FROM film f 
ORDER BY film_id LIMIT 5; -- film_id 를 기준으로 정렬 그런데 제한이 5개인

SELECT film_id, title, release_year
FROM film f 
ORDER BY film_id LIMIT 5 -- film_id 를 기준으로 정렬 그런데 제한이 5개만 출력인
				OFFSET 3 ; -- 시작할 곳을 0에서 시작해서 3 INDEX > 4번째 출력
				
SELECT film_id, title, release_year
FROM film f 
ORDER BY film_id DESC -- 정렬기준도 추가
LIMIT 5 -- film_id 를 기준으로 정렬 그런데 제한이 5개만 출력인
OFFSET 3 ; -- 시작할 곳을 0에서 시작해서 3 INDEX > 4번째 출력


SELECT FILM_ID, TITLE
FROM film f 
ORDER BY title 
FETCH FIRST 5 ROW ONLY ;


SELECT customer_id, rental_id, return_date
FROM rental r 
WHERE customer_id IN (1, 2)  -- customer_id 가 1 또는 2인 값에 해당할때.
ORDER BY return_date  DESC ;

SELECT customer_id, rental_id, return_date
FROM rental r 
WHERE customer_id = 1 OR customer_id = 2 -- in과 동일한 결과. in은 or조건으로 묶인 where절과 같다.
ORDER BY return_date  DESC ;

SELECT customer_id, rental_id, return_date
FROM rental r 
WHERE customer_id NOT IN (1, 2)  -- customer_id 가 1 또는 2인 값에 해당할때.
ORDER BY return_date  DESC ;


SELECT CUSTOMER_ID -- 2 찾아진 customer_id 만 받아오기.
FROM rental r 
WHERE customer_id IN( SELECT customer_id -- 1 서브쿼리로 customer_id 의 조건을 걸러서 찾아옴.
						FROM rental r2
						WHERE CAST (return_date AS DATE) = '2005-05-27') ;

					
SELECT CUSTOMER_ID, PAYMENT_ID, AMOUNT
FROM payment p 
WHERE AMOUNT BETWEEN 5 AND 8 ;

SELECT CUSTOMER_ID, PAYMENT_ID
FROM payment p 
WHERE CAST(payment_date AS DATE) -- CAST 함수로 DATE 타입으로 변경. 동일하게 TO_CHAR(컬럼, 'yyyy-mm-dd') 이런식으로 변경가능.
BETWEEN '2007-02-07' AND '2007-02-15' ;

SELECT FIRST_NAME, LAST_NAME
FROM customer c 
WHERE first_name LIKE '%er%' ; -- 비슷한 글자를 일부만 알고 있을때 탐색에 유용.


SELECT *
FROM contact c 
WHERE phone IS NOT NULL ;


-- 실습 1
-- 직접설계
SELECT DISTINCT p.customer_id 
FROM payment p
WHERE p.amount IN (SELECT p2.amount 
				FROM payment p2
				ORDER BY p2.amount DESC
				LIMIT 1) ;
				
-- 풀이
SELECT 

-- 실습 2
-- 직접설계
-- 고객 이메일 주소 추출
SELECT EMAIL
FROM customer c ;

-- 이때 이메일 형식을 확인.
SELECT EMAIL
FROM customer c
WHERE EMAIL LIKE '%@%'
			AND email NOT LIKE '@%'
			AND email NOT LIKE '%@' ;


		
		
-- 조인 실습
		
select *
from employees e ;

SELECT C.CUSTOMER_ID , C.FIRST_NAME , C.LAST_NAME , C.EMAIL , P.AMOUNT, P.PAYMENT_DATE
FROM CUSTOMER C 
INNER JOIN PAYMENT P 
ON C.CUSTOMER_ID = P.CUSTOMER_ID ;

SELECT C.CUSTOMER_ID , C.FIRST_NAME , C.LAST_NAME , C.EMAIL , P.AMOUNT, P.PAYMENT_DATE
FROM CUSTOMER C 
INNER JOIN PAYMENT P 
ON C.CUSTOMER_ID = P.CUSTOMER_ID
WHERE C.CUSTOMER_ID = 2 ; -- 조건문 추가

SELECT C.CUSTOMER_ID , C.FIRST_NAME , C.LAST_NAME , C.EMAIL , P.AMOUNT, P.PAYMENT_DATE, S.STAFF_ID
FROM customer c 
INNER JOIN payment p 
ON c.customer_id = p.customer_id 
INNER JOIN staff s 
ON p.staff_id = s.staff_id ;

SELECT A.ID AS ID_A
	  ,A.FRUIT AS FRUIT_A
	  ,B.ID AS ID_B
	  ,B.FRUIT AS FRUIT_B
FROM BASKET_A A LEFT OUTER JOIN BASKET_B B
ON A.FRUIT = B.FRUIT ;

SELECT A.ID AS ID_A
	  ,A.FRUIT AS FRUIT_A
	  ,B.ID AS ID_B
	  ,B.FRUIT AS FRUIT_B
FROM BASKET_A A LEFT OUTER JOIN BASKET_B B
ON A.FRUIT = B.FRUIT
WHERE B.ID IS NULL; -- LEFT ONLY를 구할때. B를 기준으로 A에 없는 속성(NULL)을 갖는 값을 찾아서 오직 A에 속하는 값을 구한다.

SELECT *
FROM employee e ;

SELECT E.FIRST_NAME ||' '|| E.LAST_NAME AS EMPLOYEE
	,  M.FIRST_NAME ||' '|| M.LAST_NAME AS MANAGER
FROM EMPLOYEE E 
INNER JOIN EMPLOYEE M -- 별칭을 다르게 하여 INNER JOIN을 수행.
ON M.EMPLOYEE_ID = E.MANAGER_ID -- 이때 NULL 값이 포함되지 않는다.
ORDER BY MANAGER ;

SELECT E.FIRST_NAME ||' '|| E.LAST_NAME AS EMPLOYEE
	,  M.FIRST_NAME ||' '|| M.LAST_NAME AS MANAGER
FROM EMPLOYEE E 
LEFT JOIN EMPLOYEE M -- LEFT OUTER JOIN을 사용하여 NULL 값까지 포함시킨다.
ON M.EMPLOYEE_ID = E.MANAGER_ID -- 
ORDER BY MANAGER ;

-- 부정형 조건
SELECT F.TITLE, F2.TITLE, F.LENGTH
FROM FILM F 
INNER JOIN FILM F2 
ON F.FILM_ID <> F2.FILM_ID
AND F.LENGTH = F2.LENGTH ;

-- 동일 테이블 > 각각 다른집합 구성 (셀프조인) > 그안에서 원하는 정보를 추출.
-- 테이블 1개만 사용할 경우 물리적으로 불가능한 조회방법이 될 수 있다.

SELECT A.ID AS ID_A
	  ,A.FRUIT AS FRUIT_A
	  ,B.ID AS ID_B
	  ,B.FRUIT AS FRUIT_B
FROM BASKET_A A
FULL OUTER JOIN basket_b B
ON A.FRUIT = B.FRUIT ;

SELECT A.ID AS ID_A
	  ,A.FRUIT AS FRUIT_A
	  ,B.ID AS ID_B
	  ,B.FRUIT AS FRUIT_B
FROM BASKET_A A
FULL OUTER JOIN basket_b B
ON A.FRUIT = B.FRUIT
WHERE A.ID IS NULL
OR B.ID IS NULL ;


SELECT e.employee_name , d.department_name 
FROM employees e 
FULL OUTER JOIN departments d 
ON D.DEPARTMENT_ID = e.department_id ; -- 풀아우터조인으로 출력.

SELECT e.employee_name , d.department_name 
FROM employees e 
FULL OUTER JOIN departments d 
ON D.DEPARTMENT_ID = e.department_id
WHERE e.employee_name is NULL ; -- 왼쪽이 NULL인 조건 = RIGHT ONLY 조건

SELECT *
FROM cross_t1 ct 
CROSS JOIN cross_t2 ct2 ;

SELECT * 
FROM cross_t1 ct , cross_t2 ct2 ;

SELECT *
FROM products p 
NATURAL JOIN categories c ;

SELECT CUSTOMER_ID -- 중복값을 제거한 customer_id 를 출력.
FROM payment p 
GROUP BY customer_id ;

SELECT CUSTOMER_ID
	 , SUM(amount) AS AMOUNT_SUM -- 집계함수 SUM으로 AMOUNT의 합계를 계산
FROM payment p 
GROUP BY customer_id -- CUSTOMER_ID를 기준으로 AMOUNT의 SUM을 계산
ORDER BY SUM(AMOUNT) DESC; -- 합계치를 기준으로 가장 높은 AMOUNT를 갖는 ID가 위로 오게 수행.

SELECT STAFF_ID
	 , COUNT(PAYMENT_ID) AS COUNT_
FROM payment p 
GROUP BY staff_id ;      


SELECT CUSTOMER_ID
	 , SUM(amount) AS AMOUNT_SUM -- 집계함수 SUM으로 AMOUNT의 합계를 계산
FROM payment p 
GROUP BY customer_id -- CUSTOMER_ID를 기준으로 AMOUNT의 SUM을 계산
HAVING SUM(AMOUNT) > 200 -- GROUP BY 바로 뒤에 등장하여 조건에 맞는 GROUP 결과를 출력.
ORDER BY SUM(AMOUNT) DESC ; -- ORDER BY는 가장 아래에 가야한다.


SELECT p.customer_id , c.email 
	 , SUM(p.amount) AS AMOUNT_SUM
FROM payment p , customer c 
WHERE p.customer_id = c.customer_id 
GROUP BY p.customer_id , c.email 
HAVING SUM(p.amount) > 200 ;


SELECT * FROM sales2007_1 s 
UNION
SELECT * FROM sales2007_2 s2 ;

SELECT NAME FROM sales2007_1 s 
UNION
SELECT NAME FROM sales2007_2 s2 ; -- NAME을 기준으로 중복이 제거됨.

SELECT AMOUNT FROM sales2007_1 s 
UNION
SELECT amount FROM sales2007_2 s2 ;

SELECT NAME FROM sales2007_1 s 
UNION ALL
SELECT NAME FROM sales2007_2 s2 ;



SELECT * FROM keys k 
INTERSECT
SELECT * FROM hipos h ; -- 교집합이 출력. 실무에서 많이 쓰이진 않음. 대신 INNER JOIN을 사용



SELECT DISTINCT i.film_id , f.title 
FROM inventory i 
INNER JOIN film f -- 재고가 있는 영화를 찾고(INVENTORY에 들어있고) 
ON f.film_id = i.film_id 
ORDER BY f.title ; -- TITLE 순으로 출력.
-- 필름과 인벤토리는 1:N관계 -> 두 테이블 조인시 영화 1개당 여러 재고가 나옴. -> 중복 제거를 위해 DISTINCT 사용.

-- 재고가 존재하지 않는 영화를 추출하는 방법? 필름-재고가존재 = 재고가 없음
SELECT f2.film_id , f2.title -- 전체
FROM film f2
EXCEPT
SELECT DISTINCT i.film_id , f.title -- 재고가 있는 필름들을 제외
FROM inventory i 
INNER JOIN film f -- 재고가 있는 영화를 찾고(INVENTORY에 들어있고) 
ON f.film_id = i.film_id 
ORDER BY title ; -- 엘리어스하면 오류남.


--중첩 서브쿼리
SELECT f.film_id , f.title, f.rental_rate 
FROM film f 
WHERE rental_rate > ( -- 평균값보다 높은 렌탈레이트를 갖는 모든 쿼리를 가져옴
	SELECT 
	AVG(rental_rate) -- 렌탈레이트 평균을 구하는 서브쿼리
	FROM film f2 ) ;

--인라인 뷰 서브쿼리
SELECT f.film_id , f.title, f.rental_rate 
FROM film f , ( -- from 절에서 인라인 뷰로 서브쿼리 작성.
	SELECT AVG(rental_rate) as avg_rental_rate 
	from film ) f2
WHERE f.rental_rate > f2.avg_rental_rate ;

-- 스칼라서브쿼리
SELECT f.film_id , f.title, f.rental_rate 
FROM (
	SELECT f.film_id, f.title, f.rental_rate , ( -- 스칼라 서브쿼리. 인라인뷰 내에서 스칼라 값을 갖는 서브쿼리 작성
		SELECT AVG(f2.rental_rate) from film f2 ) as avg_rental_rate
	from film f ) f
where f.rental_rate > f.avg_rental_rate ;


-- ANY
SELECT title , length 
FROM film f 
WHERE length >= ANY ( 
	SELECT MAX(length)
	FROM film f2 , film_category fc 
	WHERE f2.film_id = fc.film_id 
	GROUP BY fc.category_id  ); 

SELECT title , length 
FROM film f 
WHERE length = ANY ( -- 정확히 일지하는 값만 출력
	SELECT MAX(length)
	FROM film f2 , film_category fc 
	WHERE f2.film_id = fc.film_id 
	GROUP BY fc.category_id  ); 


SELECT title , length 
FROM film f 
WHERE length >= ALL ( -- 서브쿼리를 모두 만족하는 값(제일큰값)을 출력해줌.
	SELECT MAX(length)
	FROM film f2 , film_category fc 
	WHERE f2.film_id = fc.film_id 
	GROUP BY fc.category_id  ); 


SELECT ROUND(AVG(LENGTH), 2)
FROM film f 
GROUP BY rating ; -- 평가기준으로 레이팅별 영화길이 평균을 구함.

SELECT title , length 
FROM film f 
WHERE length > ALL ( -- 서브쿼리를 모두 만족하는 값(제일큰값기준으로 그 이상)을 출력해줌.
	SELECT ROUND(AVG(LENGTH), 2) 
	FROM film 
	GROUP BY rating) ; -- 평가기준으로 레이팅별 영화길이 평균을 구함. 
	

-- A, B 집합을 합치면 전체 집합(CUSTOMER)이 나옴.
SELECT first_name, LAST_NAME -- A집합
FROM customer c 
WHERE EXISTS ( -- 서브쿼리 조건이 있으면 출력, 없으면 미출력
	SELECT 1 -- 있을경우 값을 1
	FROM payment p 
	WHERE p.customer_id = c.customer_id -- 지불내역 내에 c.고객이 있는지 확인
	AND p.amount > 11 ) -- 11달러 이상 소모한 고객만 고름
ORDER BY first_name , last_name ;


SELECT first_name, LAST_NAME -- B집합
FROM customer c 
WHERE NOT EXISTS ( -- 없으면 출력, 있으면 미출력
	SELECT 1
	FROM payment p 
	WHERE p.customer_id = c.customer_id -- 지불내역 내에 c.고객이 있는지 확인
	AND p.amount > 11 ) -- 11달러 이상 소모한 고객만 고름
ORDER BY first_name , last_name ;


-- FILM 테이블을 한번만 스캔하여 결과집합 구하기.
SELECT DB.FILM_ID, DB.TITLE, DB.RENTAL_RATE
FROM ( 
SELECT f.film_id , f.title , f.rental_rate , AVG(f.rental_rate) OVER() as avg_rental_rate 
FROM film f ) DB -- over 함수로 평균을 포함한 인라인뷰 테이블을 생성.
WHERE rental_rate > DB.avg_rental_rate ;

-- EXCEPT 연산을 사용하지 않고 재고가 없는 영화를 구하기.
SELECT FILM_ID, TITLE
FROM film f 
WHERE NOT EXISTS ( -- 서브쿼리에 존재하지 않는 값만 not exists로 획득.
	SELECT 1
	FROM inventory i 
	WHERE i.film_id = f.film_id ) -- inventory에 있는 필름을 확인하는 서브쿼리
ORDER BY title ;


SELECT brand, segment, sum(quantity)
FROM sales s 
GROUP BY brand , segment -- group by를 사용한 집계.
union all
SELECT brand, NULL, sum(quantity)
FROM sales s 
GROUP BY brand -- brand 기준 
union all
SELECT NULL, segment, sum(quantity)
FROM sales s 
GROUP BY segment -- segment 기준
union all
SELECT NULL, NULL, sum(quantity)
FROM sales s  ; -- 그냥 합계 구하는 방법
-- 위의 방법을 한번에 대기 위해선 union all을 계속 수행해야함.
-- SQL 복잡, 내용 길어짐, 성능저하, 유지보수에 불편.

-- 이를 grouping set 을 사용하여 간단하게 변경.
SELECT brand, segment, sum(quantity)
FROM sales s 
GROUP BY
GROUPING SETS ( -- 그룹하고 싶은 조건을 아래에 작성해준다.
	(BRAND, segment),
	(BRAND),
	(segment),
	());

SELECT GROUPING(BRAND) GROUPING_BRAND, GROUPING(SEGMENT) GROUPING_SEGMENT, -- GROUPING이 사용되었다면 1, 아니면 0인 값을 리턴한다.
	brand, segment, sum(quantity)
FROM sales s 
GROUP BY
GROUPING SETS ( -- 그룹하고 싶은 조건을 아래에 작성해준다.
	(BRAND, segment),
	(BRAND),
	(segment),
	());

-- ROLLUP 절
SELECT brand , segment , SUM(quantity)
FROM sales s 
GROUP BY ROLLUP(brand, segment) -- 브랜드, 세그먼트 합계, 브랜드별 합계, 세그먼트별합계, 전체합계 모두 출력
ORDER BY brand , segment ; -- GROUPING SETS를 전체 조합에 대해 수행한 것과 동일한 결과를 얻을 수 있다.

SELECT brand , SUM(quantity)
FROM sales s 
GROUP BY ROLLUP(brand) -- 브랜드별 합계와 전체합계 모두 출력
ORDER BY brand ;

-- 부분 ROLLUP
-- 전체 합계는 출력하지 않음.
SELECT brand , segment , SUM(quantity)
FROM sales s 
GROUP BY segment ,
ROLLUP(brand)
ORDER BY brand , segment ;
-- group by 별 합계, rollup 컬럼별 합계 , 전체 합계는 사용하지 않는다.


-- CUBE 함수
SELECT brand , segment , SUM(quantity)
FROM sales s 
GROUP BY CUBE( brand, segment)
ORDER BY brand , segment ;
-- CUBE = GROUP BY절 합계 + 각 속성별 합계 + 전체 합계

-- 부분 CUBE
SELECT brand , segment , SUM(quantity)
FROM sales s 
GROUP BY brand ,
	CUBE(segment)
ORDER BY brand , segment ;
-- 부분 CUBE = GROUP BY 절 합계 + 맨 앞에 쓴 컬럼(BRAND) 별 합계


-- 집계함수
SELECT COUNT(*) -- 일반 집계함수는 총합값만 나온다.
FROM product p ;

-- 분석함수 OVER()
SELECT COUNT(*) OVER() , p.* -- 전체 내용 * 과 함께 COUNT 결과를 출력해준다. 
FROM product p ;

-- AVG()
SELECT p.product_name , p.price , pg.group_name , 
	AVG (price) OVER(PARTITION BY pg.group_name ORDER BY pg.group_name) -- PARTITION BY를 사용하여 나누는 기준을 지정한다.
FROM product p 
INNER JOIN product_group pg ON p.group_id = pg.group_id ;

-- 누적 평균 수행방법
SELECT p.product_name , p.price , pg.group_name , 
	AVG (price) OVER(PARTITION BY pg.group_name ORDER BY p.price) -- ORDER BY를 기준으로 누적 집계를 수행.
FROM product p 
INNER JOIN product_group pg ON p.group_id = pg.group_id ;


-- ROW_NUMBER
SELECT p.product_name , p.price , pg.group_name , 
	ROW_NUMBER () OVER ( PARTITION BY pg.group_name ORDER BY p.price DESC) -- 가격을 기준으로 GROUP NAME에 대한 순번. 동일값도 순번 나눠짐
FROM product p 															   -- DESC 로 높은값 부더 순번 정할 수 있음.
INNER JOIN product_group pg ON p.group_id = pg.group_id ;

-- RANK
SELECT p.product_name , p.price , pg.group_name , 
	RANK () OVER ( PARTITION BY pg.group_name ORDER BY p.price DESC) -- 가격을 기준으로 순번 지정. 값이 같다면 동일 순번으로 지정하고 다음을 건너뜀. 1, 1, 3, 4
FROM product p 	
INNER JOIN product_group pg ON p.group_id = pg.group_id ;

-- DENSE RANK
SELECT p.product_name , p.price , pg.group_name , 
	DENSE_RANK () OVER ( PARTITION BY pg.group_name ORDER BY p.price DESC) -- 값이 같다면 동일 순번으로 지정하고 연속해서 순위지정. 1, 1, 2, 3
FROM product p 	
INNER JOIN product_group pg ON p.group_id = pg.group_id ;


-- FIRST_VALUE
SELECT p.product_name , p.price , pg.group_name , 
	FIRST_VALUE (p.price) OVER ( PARTITION BY pg.group_name ORDER BY p.price DESC) -- OVER 조건을 기준으로 가장 첫번째 p.price 값을 한개씩 출력한다.
FROM product p 	
INNER JOIN product_group pg ON p.group_id = pg.group_id ;

-- LAST_VALUE
SELECT p.product_name , p.price , pg.group_name , 
	LAST_VALUE (p.price)  									-- 가장 마지막 PRICE 를 출력
		OVER ( PARTITION BY pg.group_name ORDER BY p.price 	-- OVER 조건을 기준으로 가장 첫번째 p.price 컬럼을 정렬한 값들 중에서
			RANGE BETWEEN UNBOUNDED PRECEDING 				-- 파티션의 첫번째 ROW 부터
			AND UNBOUNDED FOLLOWING) 						-- 파티션의 마지막 ROW 까지 범위를 지정. 범위지정하지 않으면 CURRENT ROW가 DEFAULT이므로 값이 전체범위가 아니게됨.
			AS LOWEST_PRICE_PER_GROUP
FROM product p 	
INNER JOIN product_group pg ON p.group_id = pg.group_id ;


-- LAG 함수
SELECT p.product_name , p.price , pg.group_name , 
	LAG (p.price, 1) OVER ( PARTITION BY pg.group_name ORDER BY p.price ) AS PREV_PRICE , -- LAG(PRICE, N번째 이전행) 사용하여 이전 행 값을 구함.
	p.price  - LAG(p.price, 1) OVER ( PARTITION BY pg.group_name ORDER BY p.price) AS CUR_PREV_DIFF -- 현재 값 - 이전 값을 계산한 결과값
FROM product p 	
INNER JOIN product_group pg ON p.group_id = pg.group_id ;

-- LEAD 함수
SELECT p.product_name , p.price , pg.group_name , 
	LEAD (p.price, 1) OVER ( PARTITION BY pg.group_name ORDER BY p.price ) AS PREV_PRICE , -- LEAD(PRICE, N번째 다음행) 사용하여 다음 행 값을 구함.
	p.price  - LEAD(p.price, 1) OVER ( PARTITION BY pg.group_name ORDER BY p.price) AS CUR_PREV_DIFF -- 현재 값 - 이전 값을 계산한 결과값
FROM product p 	
INNER JOIN product_group pg ON p.group_id = pg.group_id ;


-- 실습문제 1
-- RENTAL 테이블 기준 연, 연월, 연월일, 전체 각각을 기준으로 대여가 발생한 횟수를 출력.

SELECT to_char(r.rental_date , 'YYYY') AS YYYY ,
	to_char(r.rental_date, 'MM') AS MM ,
	to_char(r.rental_date, 'DD') AS DD,
	COUNT(r.rental_id) AS CNT
FROM rental r 
GROUP BY ROLLUP (
	to_char(r.rental_date, 'YYYY'),
	to_char(r.rental_date, 'MM'),
	to_char(r.rental_date, 'DD') ) ;

-- 실습문제 2
-- RENTAL 과 CUSTOMER 테이블을 이용하여 가장 많이 RENTAL을 한 고객의 ID, 렌탈 순위, 누적 렌탈 횟수, 이름을 출력하라.
-- 순위 RANK, 누적 함수 사용

SELECT c.customer_id , c.first_name , c.last_name , -- r.customer_id 로 grouping 하면 max(c.first_name), max(C.last_name) 으로 가져올 수 있다.
	ROW_NUMBER() OVER (ORDER BY COUNT(r.rental_id) DESC) AS RENTAL_RANK ,
	COUNT(*) AS RENTAL_CNT -- COUNT 쓸려면 무조건 기준 컬럼으로 GROUPING 수행해야함.
FROM rental r 
JOIN customer c ON r.customer_id = c.customer_id 
GROUP BY c.customer_id -- COUNT 에대하여 그룹바이.
ORDER BY RENTAL_RANK 
LIMIT 1 ;




