����1��) ������ ���� ���� �ø� dvd �� �̸���? (subquery Ȱ��)	 

SELECT c.first_name , c.last_name 
FROM customer c 
WHERE c.customer_id IN( -- IN ���� ����Ҷ� ���� �÷��� �������� �÷� ���� �����ϰ� ������Ѵ�.
	-- ������ ���� ���� ���.
	SELECT customer_id --, SUM(p.amount) AS SUM_AMOUNT
	FROM payment p 
	GROUP BY customer_id 
	ORDER BY SUM(p.amount) DESC 
	LIMIT 1 ) ;


����2��) �뿩�� �ѹ����̶� �� ��ȭ ī�� �� �̸��� �˷��ּ���. (������, Exists������ �̿��Ͽ� Ǯ��ô�)

SELECT c.name
FROM category c 
WHERE EXISTS ( -- �뿩�� �ѹ��̶� ����� ī�װ�
	SELECT 1 -- DISTINCT r.rental_id , i.film_id , fc.category_id 
	FROM rental r 
	JOIN inventory i ON r.inventory_id = i.inventory_id 
	JOIN film_category fc ON i.film_id = fc.film_id 
	WHERE c.category_id = fc.category_id -- exists �ʼ�. �������� �÷��� ���������� ���� ���� �����ϰ� where���� ����.
) ;


����3��) �뿩�� �ѹ����̶� �� ��ȭ ī�� �� �̸��� �˷��ּ���. (������, Any ������ �̿��Ͽ� Ǯ��ô�)

SELECT c.name
FROM category c 
WHERE category_id = ANY ( -- ANY �����ڸ� ����ϸ� �뿩�� �ѹ��̶� ���� �÷��� 1:1�� ��ġ���ش�.
	SELECT fc.category_id 
	FROM rental r 
	JOIN inventory i ON r.inventory_id = i.inventory_id 
	JOIN film_category fc ON i.film_id = fc.film_id 
) ;

 
����4��) �뿩�� ���� ���� ����� ī�װ��� �����ΰ���? (Any, All ���� �� �ϳ��� ����Ͽ� Ǯ��ô�)	

select * from rental r ;
select * from inventory i ;

SELECT c."name" 
FROM category c  
WHERE c.category_id = ANY(
	SELECT fc.category_id 
	FROM rental r 
	JOIN inventory i ON r.inventory_id = i.inventory_id 
	JOIN film_category fc ON i.film_id = fc.film_id 
	GROUP BY fc.category_id 
	order by count(DISTINCT r.rental_id) desc
	LIMIT 1 );

 
����5��) dvd �뿩�� ���� ������ �� �̸���? (subquery Ȱ��)	

SELECT c.first_name, c.last_name
FROM customer c 
WHERE c.customer_id IN (
	SELECT customer_id 
	FROM rental r
	GROUP BY customer_id 
	ORDER BY COUNT(DISTINCT r.rental_id) DESC
	LIMIT 1 );
	

����6��) ��ȭ ī�װ����� �������� �ʴ� ��ȭ�� �ֳ���?	   

SELECT *
FROM film f
WHERE f.film_id NOT IN (
	SELECT film_id 
	FROM film_category fc 
	);

SELECT *
FROM film f
WHERE NOT EXISTS (
	SELECT 1
	FROM film_category fc 
	WHERE fc.film_id = f.film_id 
	);


-- not in, not exists ����

select *
from address a 
where not exists ( -- Null ���� Ž���� �� ����. ���� ���� ��� �����͸� ����ϹǷ�.
	select 1
	from ( 
		select '' as a -- �����϶� 1�� �����ϴ� ��������. NULL ���̶�� 0�� �� �� > NOT EXISTS���� 0�� ����� ��µ�.
		) as db
		where db.a = a.address2 );
	
SELECT *
FROM address a 
WHERE address2 NOT IN (SELECT '') ; -- ���� Ž��. NULL�� ã�� �� ����.
