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
