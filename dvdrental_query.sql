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


