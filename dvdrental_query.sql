-- select �ǽ�
select *
from customer;

select A.first_name, A.last_name, A.email
from customer A;

select a.first_name, a.last_name, a.email
from customer
order by a.first_name desc ; -- ������ �÷��� �������� ��������/�������� �����Ѵ�.

select first_name, last_name
from customer
order by first_name, last_name desc;

select first_name, last_name
from customer
order by 1, 2 desc; -- ���� ������� ���ڷ� �÷��� ������ �� �� ����.


-- select distinct �ߺ����� �ɼ�
select distinct bcolor -- �ش� �÷��� �ߺ����� ������� �ߺ��� ����. null �� ǥ�õ�.
from t1
order by bcolor ;

select distinct on (bcolor) bcolor, fcolor -- on(�÷�) �������� ���ŵ� ���� ���������� �ȴ�.
from t1
order by bcolor, fcolor  ; -- �÷� 2�� �̻� ������ on(�÷�)�� ���


select last_name, first_name
from customer
where first_name = 'Jamie'; -- where <����> �� �����ϴ� �÷��� ���.

SELECT last_name, first_name
FROM customer
WHERE first_name = 'Jamie' -- where <����> �� �����ϴ� �÷��� ���.
AND last_name = 'Rice'; -- AND, OR ���� ����Ͽ� ������ �߰��� �� ����.

SELECT CUSTOMER_ID, AMOUNT, PAYMENT_DATE
FROM PAYMENT 
WHERE AMOUNT <= 1 OR AMOUNT >= 8 ;	-- AMOUNT�� 1���� �Ǵ� 8�̻��� ���� ���.


SELECT film_id, title, release_year
FROM film f 
ORDER BY film_id LIMIT 5; -- film_id �� �������� ���� �׷��� ������ 5����

SELECT film_id, title, release_year
FROM film f 
ORDER BY film_id LIMIT 5 -- film_id �� �������� ���� �׷��� ������ 5���� �����
				OFFSET 3 ; -- ������ ���� 0���� �����ؼ� 3 INDEX > 4��° ���
				
SELECT film_id, title, release_year
FROM film f 
ORDER BY film_id DESC -- ���ı��ص� �߰�
LIMIT 5 -- film_id �� �������� ���� �׷��� ������ 5���� �����
OFFSET 3 ; -- ������ ���� 0���� �����ؼ� 3 INDEX > 4��° ���


SELECT FILM_ID, TITLE
FROM film f 
ORDER BY title 
FETCH FIRST 5 ROW ONLY ;


SELECT customer_id, rental_id, return_date
FROM rental r 
WHERE customer_id IN (1, 2)  -- customer_id �� 1 �Ǵ� 2�� ���� �ش��Ҷ�.
ORDER BY return_date  DESC ;

SELECT customer_id, rental_id, return_date
FROM rental r 
WHERE customer_id = 1 OR customer_id = 2 -- in�� ������ ���. in�� or�������� ���� where���� ����.
ORDER BY return_date  DESC ;

SELECT customer_id, rental_id, return_date
FROM rental r 
WHERE customer_id NOT IN (1, 2)  -- customer_id �� 1 �Ǵ� 2�� ���� �ش��Ҷ�.
ORDER BY return_date  DESC ;


SELECT CUSTOMER_ID -- 2 ã���� customer_id �� �޾ƿ���.
FROM rental r 
WHERE customer_id IN( SELECT customer_id -- 1 ���������� customer_id �� ������ �ɷ��� ã�ƿ�.
						FROM rental r2
						WHERE CAST (return_date AS DATE) = '2005-05-27') ;

					
SELECT CUSTOMER_ID, PAYMENT_ID, AMOUNT
FROM payment p 
WHERE AMOUNT BETWEEN 5 AND 8 ;

SELECT CUSTOMER_ID, PAYMENT_ID
FROM payment p 
WHERE CAST(payment_date AS DATE) -- CAST �Լ��� DATE Ÿ������ ����. �����ϰ� TO_CHAR(�÷�, 'yyyy-mm-dd') �̷������� ���氡��.
BETWEEN '2007-02-07' AND '2007-02-15' ;

SELECT FIRST_NAME, LAST_NAME
FROM customer c 
WHERE first_name LIKE '%er%' ; -- ����� ���ڸ� �Ϻθ� �˰� ������ Ž���� ����.


SELECT *
FROM contact c 
WHERE phone IS NOT NULL ;


-- �ǽ� 1
-- ��������
SELECT DISTINCT p.customer_id 
FROM payment p
WHERE p.amount IN (SELECT p2.amount 
				FROM payment p2
				ORDER BY p2.amount DESC
				LIMIT 1) ;
				
-- Ǯ��
SELECT 

-- �ǽ� 2
-- ��������
-- �� �̸��� �ּ� ����
SELECT EMAIL
FROM customer c ;

-- �̶� �̸��� ������ Ȯ��.
SELECT EMAIL
FROM customer c
WHERE EMAIL LIKE '%@%'
			AND email NOT LIKE '@%'
			AND email NOT LIKE '%@' ;


