����1��) store ���� staff�� ����� �ִ��� Ȯ�����ּ���.	

SELECT store_id , count(manager_staff_id) as cnt 
FROM store s 
GROUP BY store_id ;


����2��) ��ȭ���(rating) ���� � ��ȭfilm�� ������ �ִ��� Ȯ�����ּ���.	Ǯ��

SELECT f.rating 
	 , COUNT(f.film_id) AS FILM_CNT
FROM film f 
GROUP BY f.rating ;


����3��) ������ ��ȭ���(actor)��  10�� �ʰ��� ��ȭ���� �����ΰ���?	

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

����4��) ��ȭ ���(actor)���� �⿬�� ��ȭ�� ���� �� ���ΰ���?  Ǯ��
- ��ȭ ����� �̸� , �� �� �Բ� �⿬ ��ȭ ���� �˷��ּ���.	

SELECT actor_id , COUNT(DISTINCT film_id) AS CNT_FILM_ID
FROM film_actor fa 
GROUP BY actor_id ;

-- 2��. 1�� �����ͼ°� ACTOR�� �����Ͽ� �̸��� ȹ��.
SELECT d.*, a.first_name , a.last_name 
FROM ( -- 1��. ACTOR_ID���� GROUP �ϴ� �����ͼ�.
	SELECT actor_id , COUNT(DISTINCT film_id) AS FILM_CNT
	FROM film_actor fa 
	GROUP BY actor_id ) AS d
LEFT OUTER JOIN actor a ON d.actor_id = a.actor_id -- ACTOR ID�� �����Ͱ� ���� ���� �־ OUTER ����.
ORDER BY actor_id ;

����5��) ����(country)�� ��(customer) �� ����ΰ���?	Ǯ��

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

����6��) ��ȭ ��� (inventory) ������ 3�� �̻��� ��ȭ(film) ��? 
- store�� ��� ���� Ȯ�����ּ���.	

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

����7��) dvd �뿩�� ���� ������ �� �̸���?	 

SELECT r.customer_id , count(r.rental_id) AS CNT 
FROM rental r 
GROUP BY r.customer_id ;

SELECT c.first_name , c.last_name , DB.CNT
FROM ( SELECT r.customer_id , count(r.rental_id) AS CNT 
		FROM rental r 
		GROUP BY r.customer_id ) AS DB
JOIN customer c ON DB.customer_id = c.customer_id ;

����8��) rental ���̺���  ��������,   2005�� 5��26�Ͽ� �뿩�� ����� �� ��, �Ϸ翡 2�� �̻� �뿩�� �� ���� ID ���� Ȯ�����ּ���.	Ǯ��

SELECT * FROM rental r ;

SELECT r.customer_id , COUNT(DISTINCT rental_id) AS CNT_RENTAL
FROM rental r 
WHERE r.rental_date BETWEEN '2005-05-26 00:00:00' AND '2005-05-26 23:59:59' -- 1�� ��������
GROUP BY r.customer_id
HAVING COUNT(DISTINCT rental_id) >= 2 ; -- 2�� ���� ���� & �׷����� �ǹ����̺� ���� �� �������� �߰�.

����9��) film_actor ���̺��� ��������, ������ ��ȭ�� ���� ����  5���� actor_id �� , ������ ��ȭ �� �� �˷��ּ���.	Ǯ��

SELECT actor_id , COUNT(film_id) AS CNT
FROM film_actor fa
GROUP BY actor_id -- �ߺ��Ǵ� ���� �ϳ��� ������.
ORDER BY COUNT(film_id) DESC 
LIMIT 5 ;

����10��) payment ���̺��� ��������,  �������ڰ� 2007��2��15�Ͽ� �ش� �ϴ� �ֹ� �߿���  ,  �Ϸ翡 2�� �̻� �ֹ��� ����  �� ���� �ݾ��� 10�޷� �̻��� ���� ���ؼ� �˷��ּ���.  
(���� id,  �ֹ��Ǽ� , �� ���� �ݾױ��� �˷��ּ���)	

SELECT p.* 
FROM payment p
WHERE DATE(p.payment_date) = '2007-02-15' ;

SELECT p.customer_id , COUNT(p.rental_id) AS CNT , SUM(p.amount) AS SUM
FROM payment p
WHERE DATE(p.payment_date) = '2007-02-15' 
GROUP BY p.customer_id 
HAVING COUNT(p.rental_id) >= 2 AND SUM(p.amount) > 10 ;

����11��) ���Ǵ� �� ��ȭ ����?	

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

����12��) 40�� �̻� �⿬�� ��ȭ ���(actor) �� �����ΰ���?	

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

����13��) �� ��޺� �� ���� ���ϼ���. (�뿩 �ݾ� Ȥ�� �����  �� ���� �� ����� ������ ������ �Ʒ��� �����ϴ�.) Ǯ��
/*
A ����� 151 �̻� 
B ����� 101 �̻� 150 ���� 
C �����   51 �̻� 100 ����
D �����   50 ����

* �뿩 �ݾ��� �Ҽ����� �ݿø� �ϼ���. 

HINT
�ݿø� �ϴ� �Լ��� ROUND �Դϴ�.	
*/

SELECT *
FROM rental r 
ORDER BY rental_id ;

SELECT * FROM payment p ;



-->�� �� �ݾ� ����
SELECT p.customer_id , ROUND(SUM(p.amount), 0) AS SUM_AMOUNT 
	 , CASE WHEN ROUND(SUM(p.amount), 0) >= 151 THEN 'A'
	 		WHEN ROUND(SUM(p.amount), 0) BETWEEN 101 AND 150 THEN 'B'
	 		WHEN ROUND(SUM(p.amount), 0) BETWEEN 51 AND 100 THEN 'C'
	 		WHEN ROUND(SUM(p.amount), 0) <= 50 THEN 'D'
 			ELSE 'EMPTY' END CUS_RATING
FROM rental r 
JOIN payment p ON r.customer_id = p.customer_id 
			   AND r.rental_id = p.rental_id 
			   --AND r.staff_id = p.staff_id -- ��ġ ����(����)
GROUP BY p.customer_id ;

--> 2�� CASE ����
SELECT DB.customer_id
	 , CASE WHEN DB.SUM_AMOUNT >= 151 THEN 'A'
	 		WHEN DB.SUM_AMOUNT BETWEEN 101 AND 150 THEN 'B' -- BETWEEN ������ AND ū��
	 		WHEN DB.SUM_AMOUNT BETWEEN 51 AND 100 THEN 'C'
	 		WHEN DB.SUM_AMOUNT <= 50 THEN 'D'
 			ELSE 'EMPTY' END CUS_RATING
--> 1�� ���̺��� ������.
FROM (  SELECT p.customer_id , ROUND(SUM(p.amount), 0) AS SUM_AMOUNT 
		FROM rental r 
		JOIN payment p ON r.customer_id = p.customer_id 
					   AND r.rental_id = p.rental_id 
					   --AND r.staff_id = p.staff_id -- ��ġ ����(����)
		GROUP BY p.customer_id ) AS DB ;
	
	
-- ������ �������� CUSTOMER ������ ����.
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
					   --AND r.staff_id = p.staff_id -- ��ġ ����(����)
		GROUP BY p.customer_id ) AS DB 
GROUP BY DB.CUS_RATING ;

-- ���� ���� ���̸�Ʈ ���̺� ����ص� ��������. �����غ���
SELECT *
FROM payment p ;

-- ID ���� AMOUNT�� SUM�Ѵ�.

SELECT p.customer_id, round(SUM(p.amount), 0) AS SUM_AMT
FROM payment p 
GROUP BY p.customer_id ;

SELECT CASE WHEN SUM_AMT >= 151 THEN 'A' -- 2�� AMT ���� ����� ����
	 		WHEN SUM_AMT BETWEEN 101 AND 150 THEN 'B'
	 		WHEN SUM_AMT BETWEEN 51 AND 100 THEN 'C'
	 		ELSE 'D' END CUS_RATE	 
	 , COUNT(DB.customer_id) -- ��� �� ����
FROM (	SELECT p.customer_id, round(SUM(p.amount), 0) AS SUM_AMT -- 1��. ID�� AMOUNT ���
		FROM payment p 
		GROUP BY p.customer_id) AS DB
GROUP BY CASE WHEN SUM_AMT >= 151 THEN 'A' -- ��޺��� �׷�
	 		WHEN SUM_AMT BETWEEN 101 AND 150 THEN 'B'
	 		WHEN SUM_AMT BETWEEN 51 AND 100 THEN 'C'
	 		ELSE 'D' END -- �̶� ����̽�
ORDER BY CUS_RATE ; -- ��޼����� ����.



