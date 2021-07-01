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





