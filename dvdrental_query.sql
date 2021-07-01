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


		
		
-- ���� �ǽ�
		
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
WHERE C.CUSTOMER_ID = 2 ; -- ���ǹ� �߰�

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
WHERE B.ID IS NULL; -- LEFT ONLY�� ���Ҷ�. B�� �������� A�� ���� �Ӽ�(NULL)�� ���� ���� ã�Ƽ� ���� A�� ���ϴ� ���� ���Ѵ�.

SELECT *
FROM employee e ;

SELECT E.FIRST_NAME ||' '|| E.LAST_NAME AS EMPLOYEE
	,  M.FIRST_NAME ||' '|| M.LAST_NAME AS MANAGER
FROM EMPLOYEE E 
INNER JOIN EMPLOYEE M -- ��Ī�� �ٸ��� �Ͽ� INNER JOIN�� ����.
ON M.EMPLOYEE_ID = E.MANAGER_ID -- �̶� NULL ���� ���Ե��� �ʴ´�.
ORDER BY MANAGER ;

SELECT E.FIRST_NAME ||' '|| E.LAST_NAME AS EMPLOYEE
	,  M.FIRST_NAME ||' '|| M.LAST_NAME AS MANAGER
FROM EMPLOYEE E 
LEFT JOIN EMPLOYEE M -- LEFT OUTER JOIN�� ����Ͽ� NULL ������ ���Խ�Ų��.
ON M.EMPLOYEE_ID = E.MANAGER_ID -- 
ORDER BY MANAGER ;

-- ������ ����
SELECT F.TITLE, F2.TITLE, F.LENGTH
FROM FILM F 
INNER JOIN FILM F2 
ON F.FILM_ID <> F2.FILM_ID
AND F.LENGTH = F2.LENGTH ;

-- ���� ���̺� > ���� �ٸ����� ���� (��������) > �׾ȿ��� ���ϴ� ������ ����.
-- ���̺� 1���� ����� ��� ���������� �Ұ����� ��ȸ����� �� �� �ִ�.

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
ON D.DEPARTMENT_ID = e.department_id ; -- Ǯ�ƿ����������� ���.

SELECT e.employee_name , d.department_name 
FROM employees e 
FULL OUTER JOIN departments d 
ON D.DEPARTMENT_ID = e.department_id
WHERE e.employee_name is NULL ; -- ������ NULL�� ���� = RIGHT ONLY ����

SELECT *
FROM cross_t1 ct 
CROSS JOIN cross_t2 ct2 ;

SELECT * 
FROM cross_t1 ct , cross_t2 ct2 ;

SELECT *
FROM products p 
NATURAL JOIN categories c ;

SELECT CUSTOMER_ID -- �ߺ����� ������ customer_id �� ���.
FROM payment p 
GROUP BY customer_id ;

SELECT CUSTOMER_ID
	 , SUM(amount) AS AMOUNT_SUM -- �����Լ� SUM���� AMOUNT�� �հ踦 ���
FROM payment p 
GROUP BY customer_id -- CUSTOMER_ID�� �������� AMOUNT�� SUM�� ���
ORDER BY SUM(AMOUNT) DESC; -- �հ�ġ�� �������� ���� ���� AMOUNT�� ���� ID�� ���� ���� ����.

SELECT STAFF_ID
	 , COUNT(PAYMENT_ID) AS COUNT_
FROM payment p 
GROUP BY staff_id ;      


SELECT CUSTOMER_ID
	 , SUM(amount) AS AMOUNT_SUM -- �����Լ� SUM���� AMOUNT�� �հ踦 ���
FROM payment p 
GROUP BY customer_id -- CUSTOMER_ID�� �������� AMOUNT�� SUM�� ���
HAVING SUM(AMOUNT) > 200 -- GROUP BY �ٷ� �ڿ� �����Ͽ� ���ǿ� �´� GROUP ����� ���.
ORDER BY SUM(AMOUNT) DESC ; -- ORDER BY�� ���� �Ʒ��� �����Ѵ�.


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
SELECT NAME FROM sales2007_2 s2 ; -- NAME�� �������� �ߺ��� ���ŵ�.

SELECT AMOUNT FROM sales2007_1 s 
UNION
SELECT amount FROM sales2007_2 s2 ;

SELECT NAME FROM sales2007_1 s 
UNION ALL
SELECT NAME FROM sales2007_2 s2 ;



SELECT * FROM keys k 
INTERSECT
SELECT * FROM hipos h ; -- �������� ���. �ǹ����� ���� ������ ����. ��� INNER JOIN�� ���



SELECT DISTINCT i.film_id , f.title 
FROM inventory i 
INNER JOIN film f -- ��� �ִ� ��ȭ�� ã��(INVENTORY�� ����ְ�) 
ON f.film_id = i.film_id 
ORDER BY f.title ; -- TITLE ������ ���.
-- �ʸ��� �κ��丮�� 1:N���� -> �� ���̺� ���ν� ��ȭ 1���� ���� ��� ����. -> �ߺ� ���Ÿ� ���� DISTINCT ���.

-- ��� �������� �ʴ� ��ȭ�� �����ϴ� ���? �ʸ�-������� = ��� ����
SELECT f2.film_id , f2.title -- ��ü
FROM film f2
EXCEPT
SELECT DISTINCT i.film_id , f.title -- ��� �ִ� �ʸ����� ����
FROM inventory i 
INNER JOIN film f -- ��� �ִ� ��ȭ�� ã��(INVENTORY�� ����ְ�) 
ON f.film_id = i.film_id 
ORDER BY title ; -- ������ϸ� ������.





