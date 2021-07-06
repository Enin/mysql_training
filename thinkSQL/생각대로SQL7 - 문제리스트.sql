����1��) �뿩��(store)�� ��ȭ ���(inventory) ������ ��ü ��ȭ ��� ������? (grouping set)	 

SELECT i.store_id , COUNT(DISTINCT inventory_id) AS CNT
FROM inventory i
GROUP BY GROUPING SETS ((store_id), ()) ;

����2��) �뿩��(store)�� ��ȭ ���(inventory) ������ ��ü ��ȭ ��� ������? (rollup)	 

SELECT i.store_id, COUNT(DISTINCT inventory_id) AS CNT
FROM inventory i 
GROUP BY ROLLUP (store_id) ;

����3��) ����(country)�� ����(city)�� �����, ����(country)����� �Ұ� �׸��� ��ü ������� ���ϼ���. (grouping set)	Ǯ��

SELECT c3.country , c2.city , SUM(p.amount)
FROM payment p
JOIN customer c ON p.customer_id = c.customer_id -- �ʿ��� ���̺��� ��� �����Ѵ�.
JOIN address a ON c.address_id = a.address_id 
JOIN city c2 ON a.city_id = c2.city_id 
JOIN country c3 ON c2.country_id = c3.country_id 
GROUP BY GROUPING SETS ((c3.country, c2.city) , (c3.country), ()) ; -- �׷� ���� ����Ͽ� �׸� �������� ���. ������� ��ü �����


����4��) ����(country)�� ����(city)�� �����, ����(country)����� �Ұ� �׸��� ��ü ������� ���ϼ���. (rollup)	Ǯ��

SELECT c3.country , c2.city , SUM(p.amount)
FROM payment p
JOIN customer c ON p.customer_id = c.customer_id -- �ʿ��� ���̺��� ��� �����Ѵ�.
JOIN address a ON c.address_id = a.address_id 
JOIN city c2 ON a.city_id = c2.city_id 
JOIN country c3 ON c2.country_id = c3.country_id 
GROUP BY ROLLUP (c3.country, c2.city) ; -- ROLLUP�� �Է��� ���� ���ձ��� ���� ������ش�. ���� GROUPING SETS ���� ����. 


����5��) ��ȭ��캰��  �⿬�� ��ȭ count �� ��,   ��� ����� ��ü �⿬ ��ȭ ���� �ջ� �ؼ� �Բ� �����ּ���.	Ǯ��

-- ��ü�� �ջ� > ROLLUP���
SELECT actor_id , COUNT(DISTINCT film_id) AS CNT
FROM film_actor fa 
GROUP BY
	ROLLUP(actor_id) -- GROUPING SETS ((ACTOR_ID, ()) �� ����.
ORDER BY CNT DESC;


����6��) ���� (Country)��, ����(City)��  ���� ���� ,  ��ü ������ ���� ���� �Բ� �����ּ���. (grouping sets)	

SELECT c3.country , c2.city , count(c.customer_id) AS CNT
FROM customer c 
JOIN address a ON c.address_id = a.address_id 
JOIN city c2 ON a.city_id = c2.city_id 
JOIN country c3 ON c2.country_id = c3.country_id 
GROUP BY GROUPING SETS ( (c3.country) , (c3.country, c2.city), ()) ;


����7��) ��ȭ���� ����� ����  ��ȭ ���� ���� �� ���� ��ȭ  ������  , ��ȭ ���� ������ ���� ��ȭ ������ �Բ� �����ּ���.	Ǯ��

-- ���� ���� ����, ��ȭ ���� ���� ����. LANGUAGE_ID, RELEASE_YEAR
SELECT language_id , release_year , COUNT(DISTINCT film_id) AS CNT
FROM film f 
GROUP BY GROUPING SETS ((language_id, release_year), (release_year)) ;


����8��) ������, �Ϻ� ����  ������,  ������ ���� ������ �Բ� �����ּ���.
 - ����������  ���� �� id ���� �� �ǹ��մϴ�.	
 
SELECT to_char(p.payment_date, 'yyyy') as YEAR, 
	   to_char(p.payment_date, 'dd') AS DAY, 
	   count(DISTINCT p.payment_id) AS CNT 
FROM payment p 
GROUP BY GROUPING SETS ( (to_char(p.payment_date, 'yyyy'), to_char(p.payment_date, 'dd')),
						 (to_char(p.payment_date, 'yyyy')) ) ;



����9��) ���� ��,  active ���� ���� ,   active �� �� ��  �Բ� �����ּ���.  Ǯ��
 ������, active ���ο� ���ؼ��� customer ���̺��� �̿��Ͽ� �����ּ���.
 -  grouping sets �� �̿��ؼ� Ǯ�����ּ���.	
 
SELECT store_id , active , COUNT(DISTINCT customer_id) AS CNT
FROM customer c 
GROUP BY GROUPING SETS ((store_id, active), (active)) ;


����10��) ���� ��,  active ���� ���� ,   active �� �� ��  �Բ� �����ּ���. 
 ������, active ���ο� ���ؼ��� customer ���̺��� �̿��Ͽ� �����ּ���.
 -  roll up���� Ǯ���غ��鼭,  grouping sets ���� ���̸� Ȯ���غ�����.	
 
SELECT c.store_id , c.active , count(c.customer_id)
FROM customer c 
GROUP BY 
ROLLUP (c.store_id, c.active) ; -- ��ü ����� ������ ���� ����.
 