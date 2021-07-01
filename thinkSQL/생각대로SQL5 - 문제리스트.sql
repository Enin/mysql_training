����1��) ��ȭ ��찡,  ��ȭ 180�� �̻��� ���� �� ��ȭ�� �⿬�ϰų�, ��ȭ�� rating �� R �� ��޿� �ش��ϴ� ��ȭ�� �⿬��  ��ȭ ��쿡 ���ؼ�,  
��ȭ ��� ID �� (180���̻� / R��޿�ȭ)�� ���� Flag �÷��� �˷��ּ���. 
- 1) film_actor ���̺�� film ���̺��� �̿��ϼ���.
- 2) union, unionall,  intersect,  except �� ��Ȳ�� �°� ������ּ���. 
- 3) actor_id �� ������ flag �� �� ������ ������ �ʵ��� ���ּ���.	Ǯ��

SELECT *
FROM film_actor fa ;

SELECT * FROM film f ;

-- 180 �̻��� ������ ��ȭ�� �⿬�� ��ȭ��� ���̺�
SELECT actor_id , 'over_length_180' as flag
FROM film_actor fa 
WHERE film_id IN ( -- 180 �� �̻��� ��ȭ
	SELECT f.film_id 
	FROM film f 
	WHERE f.length >= 180 ) 
UNION -- �� ������ union�� ����Ͽ� ��ħ. UNION�� DISTINCT�� �ڵ����� �����(�ߺ�����)
-- R ��޿� �ش��ϴ� ��ȭ�� �⿬�� ��ȭ���
SELECT actor_id , 'rating_R' as flag
FROM film_actor fa 
WHERE film_id IN ( -- R��� ��ȭ�� �⿬�� ���
	SELECT f.film_id 
	FROM film f 
	WHERE f.rating = 'R' ) 
ORDER BY actor_id ;




����2��) R����� ��ȭ�� �⿬�ߴ� ����̸鼭, ���ÿ�, Alone Trip�� ��ȭ�� �⿬��  ��ȭ����� ID �� Ȯ�����ּ���.
- 1) film_actor ���̺�� film ���̺��� �̿��ϼ���.
- 2) union, unionall,  intersect,  except �� ��Ȳ�� �°� ������ּ���. 

-- ���ÿ� > INTERSECT�� ����Ͽ� �������� ���غ���.
SELECT actor_id 
FROM film_actor fa 
WHERE film_id IN ( -- Alone Trip�� �⿬�� ���
	SELECT f.film_id 
	FROM film f 
	WHERE f.title = 'Alone Trip') 
INTERSECT -- �� ������ union�� ����Ͽ� ��ħ. UNION�� DISTINCT�� �ڵ����� �����(�ߺ�����)
-- R ��޿� �ش��ϴ� ��ȭ�� �⿬�� ��ȭ���
SELECT actor_id 
FROM film_actor fa 
WHERE film_id IN ( -- R��� ��ȭ�� �⿬�� ���
	SELECT f.film_id 
	FROM film f 
	WHERE f.rating = 'R' ) 
ORDER BY actor_id ;



����3��) G ��޿� �ش��ϴ� �ʸ��� �������,   ��ȭ�� 20���̻� ���� ���� ��ȭ����� ID �� Ȯ�����ּ���.
- 1) film_actor ���̺�� film ���̺��� �̿��ϼ���.
- 2) union, unionall,  intersect,  except �� ��Ȳ�� �°� ������ּ���. 

-- G����� ���� ��ȭ���
SELECT actor_id
FROM film_actor fa 
WHERE film_id IN( 
	SELECT f.film_id
	FROM film f 
	WHERE f.rating = 'G' )
EXCEPT 
-- ��ȭ�� 20�� �̻� ���� ���� ����
SELECT DB.actor_id 
FROM (SELECT fa2.actor_id, COUNT(fa2.film_id) AS CNT
		FROM film_actor fa2 
		GROUP BY fa2.actor_id 
		HAVING COUNT(fa2.film_id) >= 20 ) AS DB 
ORDER BY actor_id;


-- ��ȭ�� 20�� �̻� ���� ���
SELECT actor_id, COUNT(film_id) AS CNT
FROM film_actor fa 
GROUP BY actor_id 
HAVING COUNT(film_id) >= 20;
				


����4��) �ʸ� �߿���,  �ʸ� ī�װ��� Action, Animation, Horror �� �ش����� �ʴ� �ʸ� ���̵� �˷��ּ���. Ǯ��
- category  ���̺��� �̿��ؼ� �˷��ּ���.	

-- �ش������ʴ� > ������ ���
SELECT *
FROM film f ;

SELECT * FROM film_category fc ;

SELECT * FROM category c ;

SELECT film_id -- SELECT �� Į���� �����ؾ� ����� ���� �� ����.
FROM film f 
EXCEPT
SELECT f.film_id -- ACTION, ANIMATION, HORROR�� ���� ������ ����.
FROM film f 
JOIN film_category fc ON f.film_id = fc.film_id 
JOIN category c ON fc.category_id = c.category_id 
WHERE c."name" IN ('Action', 'Animation', 'Horror') ;


����5��) Staff  ��  id , �̸�, �� �� ���� �����Ϳ� , Customer �� id, �̸� , ���� ���� �����͸�  �ϳ���  �����ͼ��� ���·� �����ּ���. Ǯ��
 - �÷� ���� : id, �̸� , ��,   flag (����/������)  �� �������ּ���.
 
SELECT s.staff_id , s.first_name , s.last_name , 'Staff' as flag
FROM staff s 
UNION ALL -- �ߺ��� �������� �ʰ� �� �÷��� ���� ���Ĺ�����.
SELECT c.customer_id , c.first_name , c.first_name , 'Customer' as flag
FROM customer c ;


����6��) ������  ���� �̸��� ������ ����� Ȥ�� �ֳ���? �ִٸ�, �ش� ����� �̸��� ���� �˷��ּ���.	Ǯ��

SELECT first_name
FROM staff s 
INTERSECT
SELECT first_name
FROM customer c ;

����7��) �ݳ��� ���� ���� �뿩��(store)�� ��ȭ ��� (inventory)�� ��ü ��ȭ ��� ���� ���ϼ���. (union all)	 

SELECT * FROM inventory i ;
SELECT * FROM rental r ;
SELECT * FROM store s ;

-- �ݳ����� ���� �뿩�� �� ��ȭ ���
SELECT i.store_id , COUNT(i.inventory_id) AS INVENTORY_CNT
FROM rental r 
JOIN inventory i ON r.inventory_id = i.inventory_id 
WHERE r.return_date IS NULL
GROUP BY i.store_id 
UNION ALL
-- ��ü ��ȭ ���
SELECT NULL, COUNT(i.inventory_id)
FROM inventory i ;


����8��) ����(country)�� ����(city)�� �����, ����(country)����� �Ұ� �׸��� ��ü ������� ���ϼ���. (union all)	 Ǯ��

SELECT *
FROM payment p ;

-- UNION �ÿ��� ��� �÷��� �����ؾ��Ѵ�.
-- ���� ��� ������ ��� �ִ� �� Ȯ��: ��, ����, ����, �����
SELECT c.customer_id , c2.city , c3.country , p.amount 
FROM payment p 
JOIN customer c ON p.customer_id = c.customer_id 
JOIN address a ON c.address_id = a.address_id 
JOIN city c2 ON a.city_id = c2.city_id 
JOIN country c3 ON c2.country_id = c3.country_id ;

-- 1. ������ ���ú� �����
SELECT country, city, SUM(amount) AS SUM
FROM ( 
	SELECT c.customer_id , c2.city , c3.country , p.amount 
	FROM payment p 
	JOIN customer c ON p.customer_id = c.customer_id 
	JOIN address a ON c.address_id = a.address_id 
	JOIN city c2 ON a.city_id = c2.city_id 
	JOIN country c3 ON c2.country_id = c3.country_id ) AS DB
GROUP BY country, city 
-- 2. ���� ����� �Ұ�
UNION ALL
SELECT country, NULL , SUM(amount) AS SUM
FROM ( 
	SELECT c.customer_id , c2.city , c3.country , p.amount 
	FROM payment p 
	JOIN customer c ON p.customer_id = c.customer_id 
	JOIN address a ON c.address_id = a.address_id 
	JOIN city c2 ON a.city_id = c2.city_id 
	JOIN country c3 ON c2.country_id = c3.country_id ) AS DB
GROUP BY country
-- 3. ��ü ����� 
UNION ALL
SELECT NULL, NULL, SUM(amount) AS SUM -- �÷��� ���߱� ���Ͽ� NULL�� ����� �ӽ÷� ���� ���� �÷��� �������ش�.
FROM ( 
	SELECT c.customer_id , c2.city , c3.country , p.amount 
	FROM payment p 
	JOIN customer c ON p.customer_id = c.customer_id 
	JOIN address a ON c.address_id = a.address_id 
	JOIN city c2 ON a.city_id = c2.city_id 
	JOIN country c3 ON c2.country_id = c3.country_id ) AS DB ;

