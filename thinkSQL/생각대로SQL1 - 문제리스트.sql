
����1��) dvd ��Ż ��ü��  dvd �뿩�� �־��� ��¥�� Ȯ�����ּ���. Ǯ��

SELECT * FROM RENTAL;

SELECT r.rental_date -- ��Ż ��¥�� �����´�.
FROM rental r; -- �뿩 ������ ���� rental ���̺��� �����ϰ� 

SELECT DISTINCT DATE(RENTAL_DATE) -- �ߺ����� �Ͽ� ��¥ �ߺ� ����.
FROM RENTAL;

����2��) ��ȭ���̰� 120�� �̻��̸鼭, �뿩�Ⱓ�� 4�� �̻��� ������, ��ȭ������ �˷��ּ���.	

SELECT * FROM film f ;
SELECT title
FROM film f 
WHERE length >= 120 and
	rental_duration >= 4;

����3��) ������ id �� 2 ����  ������  id, �̸�, ���� �˷��ּ���	

SELECT * FROM staff s ;
SELECT staff_id, first_name, last_name
FROM staff s 
WHERE staff_id = 2;

����4��) ���� ���� �߿���,   ���� ���� ��ȣ�� 17510 �� �ش��ϴ�  ,  ���� ���� ���� (amount ) �� ���ΰ���?	

SELECT * FROM payment p ;

SELECT amount
FROM payment p 
WHERE payment_id = 17510 ;

����5��) ��ȭ ī�װ� �߿��� ,Sci-Fi  ī�װ���  ī�װ� ��ȣ�� ����ΰ���?	Ǯ��

SELECT * FROM category c; -- 14�� SCI-FI ī�װ� ��ȣ�� Ȯ���Ͽ���.

SELECT category_id -- ī�װ� ���̵� ���.
FROM category c 
WHERE NAME = 'Sci-Fi'; -- where���� sci-fi��� �̸��� ���� Ʃ�� Ž��.


����6��) film ���̺��� Ȱ���Ͽ�, rating  ���(?) �� ���ؼ�, ��� ����� �ִ��� Ȯ���غ�����. 	Ǯ��.

SELECT * FROM film f ;
SELECT COUNT(*) FROM film f ; -- FILM ���̺��� ��ü Ʃ�ü�.

SELECT DISTINCT rating
FROM film f ; -- ��޿� ���ؼ� �ߺ������Ͽ� �� 5���� �ִٴ� ���� Ȯ��.
/*
PG-13
NC-17
G
PG
R
*/

-- ���� 5�� ������ �Ϸ��� ���??		
SELECT COUNT(DISTINCT rating) -- ī��Ʈ �ȿ� �ߺ����� �÷����� �־��ָ� ��.
FROM film f;


����7��) �뿩 �Ⱓ�� (ȸ�� - �뿩��) 10�� �̻��̿��� rental ���̺� ���� ��� ������ �˷��ּ���.
�� , �뿩�Ⱓ��  �뿩���ں��� �뿩�Ⱓ���� �����Ͽ� ����մϴ�.	 Ǯ��

SELECT *
from rental r ;

SELECT DATE(rental_date), 
		DATE(return_date), 
		DATE(return_date) - DATE(rental_date) + 1 as chk
FROM rental r 
where DATE(return_date) - DATE(rental_date) + 1 >= 10 ; -- where ���� �����ϰ� ���� �÷��� ���ؼ� ������ ���� �� ����.

SELECT DATE(return_date) - DATE(rental_date) + 1 as chk -- as �ӽ��÷��� ���� ��Ÿ�� �÷��� ���� ����.
FROM rental r 
where DATE(return_date) - DATE(rental_date) + 1 >= 10 ; -- where �÷��� ���ؼ� ������ ����ϴ� ���� ����.


����8��) ���� id ��  50,100,150 ..�� 50���� ����� �ش��ϴ� ���鿡 ���ؼ�, 
ȸ�� ���� ���� �̺�Ʈ�� �����Ϸ����մϴ�.
�� ���̵� 50�� ����� ���̵��, ���� �̸� (��, �̸�)�� �̸��Ͽ� ���ؼ� 
Ȯ�����ּ���.	Ǯ��.

SELECT * FROM customer c ;
SELECT customer_id, 
		last_name, 
		first_name,
		last_name ||','|| first_name as full_name, -- ||''|| �� ����Ͽ� ������ ���ڸ� �߰��� �� �ְ� �� �÷��� ��ĥ �� ����.
		email
		--MOD(customer_id, 50) as MOD_50 -- mod() �� �����Ϳ� �������� �������� ���ϴ� ��.
FROM customer c  
WHERE MOD(customer_id, 50) = 0 ;  -- mod() �� �����Ϳ� �������� �������� ���ϴ� ��.



����9��) ��ȭ ������ ���̰� 8������, ��ȭ ���� ����Ʈ�� �������ּ���.	

SELECT * FROM film f ;
SELECT title
FROM film f 
WHERE length(title) > 8 ;

����10��)	city ���̺��� city ������ ��ΰ���?	Ǯ��

SELECT * FROM city ;

-- Ǯ��1
SELECT count(city_id)
FROM city c ;
-- Ǯ��2
SELECT city_id
FROM city c 
ORDER BY city DESC;
-- Ǯ��3
SELECT max(city_id)
from city;
-- Ǯ��4
SELECT count(DISTINCT city) -- city�� �ߺ����� ������ �� ���ڸ� ����. ��Ȯ�ϰ� ������ �÷��� ���� ���°�.
from city; -- city_id �÷��� �ߺ��� ���� ���� �ִ�. �� ������ Ȯ���ϱ� ���� ��ȣ.


����11��)	��ȭ����� �̸� (�̸�+' '+��) �� ���ؼ�,  �빮�ڷ� �̸��� �����ּ���.  �� ��(?)�� �̸��� ������ ����� �ִٸ�,  �ߺ� �����ϰ�, �˷��ּ���.	Ǯ��.

SELECT * FROM actor a ;
-- �̸��� �ߺ�����
-- �̸���ġ��
-- �̸��� �빮�ڷ� 
SELECT DISTINCT UPPER(first_name ||' '|| last_name) as full_name -- UPPER, LOWER �Լ��� �־ ��ü �빮��/��ü�ҹ��ڷ� ����. 
FROM actor a ;


����12��)	�� �߿���,  active ���°� 0 �� �� ���� ������� �ʰ� �ִ� ���� ���� �˷��ּ���.	

SELECT * FROM customer c ;
SELECT count(customer_id)
FROM customer c 
where active = 0 ;

����13��)	Customer ���̺��� Ȱ���Ͽ�,  store_id = 1 �� ���ε�  ���� ���� ������� Ȯ���غ�����.	

SELECT * FROM customer c ;

SELECT count(DISTINCT customer_id)
FROM customer c 
WHERE store_id = 1;

����14��)	rental ���̺��� Ȱ���Ͽ�,  ���� return �ߴ� ��¥�� 2005��6��20�Ͽ� �ش��ߴ� rental �� ������ ������� Ȯ���غ�����.	

SELECT * FROM rental r ;

SELECT count(rental_id)
FROM rental r 
WHERE DATE(return_date) = DATE('2005-06-20') ;

����15��)	film ���̺��� Ȱ���Ͽ�, 2006�⿡ ��ð� �ǰ� rating �� 'G' ��޿� �ش��ϸ�, �뿩�Ⱓ�� 3�Ͽ� �ش��ϴ�  �Ϳ� ���� film ���̺��� ��� �÷��� �˷��ּ���.	

SELECT *
FROM film f
WHERE release_year = 2006 and rating = 'G' and rental_duration = 3 ;

����16��)	langugage ���̺� �ִ� id, name �÷��� Ȯ���غ����� . 	

SELECT language_id, name FROM "language" l ;

����17��)	film ���̺��� Ȱ���Ͽ�,  rental_duration ��  7�� �̻� �뿩�� ������  film �� ���ؼ�  film_id,   title,  description �÷��� Ȯ���غ�����.	Ǯ��
-- �������� �ʿ��� ������� ��� ������ ���������� ǥ���� �ϸ� ��.
SELECT * FROM film f ;

SELECT film_id, title, description
FROM film f 
WHERE rental_duration >= 7 ; -- > < = != ���.

����18��)	film ���̺��� Ȱ���Ͽ�,  rental_duration   �뿩�� ������ ���ڰ� 3�� �Ǵ� 5�Ͽ� �ش��ϴ�  film_id,  title, desciption �� Ȯ�����ּ���.	

SELECT film_id, title, description
FROM film f 
WHERE rental_duration = 3 or rental_duration = 5 ;

����19��)	Actor ���̺��� �̿��Ͽ�,  �̸��� Nick �̰ų�  ���� Hunt ��  �����  id ��  �̸�, ���� Ȯ�����ּ���.

SELECT actor_id , first_name , last_name 
FROM actor a 
WHERE first_name = 'Nick' or last_name = 'Hunt' ;

����20��)	Actor ���̺��� �̿��Ͽ�, Actor ���̺���  first_name �÷��� last_name �÷��� , firstname, lastname ���� �÷����� �ٲ㼭 �����ּ���	

SELECT first_name as firstname ,
		last_name as lastname 
FROM actor a ;

