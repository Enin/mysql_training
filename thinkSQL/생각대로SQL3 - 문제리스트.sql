����1��) ���� �⺻ ������, �� id, �̸�, ��, �̸��ϰ� �Բ� ���� �ּ� address, district, postal_code, phone ��ȣ�� �Բ� �����ּ���. 	Ǯ��

SELECT * FROM customer c ;
SELECT * FROM address a ;
-- ADDRESS �Ӽ����� JOIN
SELECT C.CUSTOMER_ID, C.FIRST_NAME, C.LAST_NAME, C.EMAIL ,
A.ADDRESS, A.DISTRICT, A.POSTAL_CODE, A.PHONE
FROM CUSTOMER C 
JOIN ADDRESS A 
ON C.ADDRESS_ID = A.ADDRESS_ID ;

����2��) ����  �⺻ ������, �� id, �̸�, ��, �̸��ϰ� �Բ� ���� �ּ� address, district, postal_code, phone , city �� �Բ� �˷��ּ���. 	Ǯ��

SELECT C.CUSTOMER_ID, C.FIRST_NAME, C.LAST_NAME, C.EMAIL ,
A.ADDRESS, A.DISTRICT, A.POSTAL_CODE, A.PHONE ,
C2.CITY
FROM CUSTOMER C 
JOIN ADDRESS A ON C.ADDRESS_ID = A.ADDRESS_ID
JOIN CITY C2 ON A.CITY_ID = C2.CITY_ID ; -- �߰� ������ ����.

����3��) Lima City�� ��� ���� �̸���, ��, �̸���, phonenumber�� ���ؼ� �˷��ּ���.	Ǯ��

SELECT c.first_name , c.last_name , c.email
	, A.phone
	, C2.city 
FROM customer c 
JOIN ADDRESS A ON C.ADDRESS_ID = A.ADDRESS_ID
JOIN CITY C2 ON A.CITY_ID = C2.CITY_ID
WHERE C2.CITY IN ('Lima') ;

����4��) rental ������ �߰���, ���� �̸���, ������ �̸��� �Բ� �����ּ���.
- ���� �̸�, ���� �̸��� �̸��� ����  fullname �÷����θ��� �����̸�/���̸� 2���� �÷����� Ȯ�����ּ���.	 Ǯ��

SELECT * FROM RENTAL ;
SELECT r.* ,
	   c.first_name ||' '|| c.last_name AS C_FULLNAME,
	   s.first_name ||' '|| s.last_name AS S_FULLNAME
FROM rental r 
JOIN staff s ON r.staff_id = s.staff_id 
JOIN customer c ON r.customer_id = c.customer_id ;

����5��) seth.hannon@sakilacustomer.org �̸��� �ּҸ� ���� ����  �ּ� address, address2, postal_code, phone, city �ּҸ� �˷��ּ���.	

SELECT * FROM customer c ;
SELECT * FROM address a ;
SELECT * FROM city c ;

SELECT a.address, a.address2, a.postal_code, a.phone, 
	   c2.city
FROM address a 
JOIN customer c ON a.address_id = c.address_id 
JOIN city c2 ON a.city_id = c2.city_id 
WHERE c.email = 'seth.hannon@sakilacustomer.org' ;

����6��) Jon Stephens ������ ���� dvd�뿩�� �� payment ��� ������  Ȯ���Ϸ��� �մϴ�. 
      - payment_id,  �� �̸� �� ��,  rental_id, amount, staff �̸��� ���� �˷��ּ���. 	
      
SELECT * FROM payment p ;

SELECT p.payment_id , 
	   c.first_name ||' '|| c.last_name AS C_FULLNAME , p.rental_id , p.amount ,
	   s.first_name ||' '|| s.last_name AS S_FULLNAME 
FROM payment p 
JOIN staff s ON p.staff_id = s.staff_id 
JOIN customer c ON p.customer_id = c.customer_id 
WHERE s.first_name ||' '|| s.last_name = 'Jon Stephens' ;


����7��) ��찡 �⿬���� �ʴ� ��ȭ�� film_id, title, release_year, rental_rate, length �� �˷��ּ���. 	

SELECT * FROM film f;
SELECT * FROM film_actor fa ;

-- ��찡 �⿬���� �ʴ� ��ȭ: film_actoer���� �� actor_id�� �ѹ��� ������ �ʴ� film_id.
SELECT *
FROM film f 
WHERE 

SELECT f.film_id, f.title, f.release_year , f.rental_rate , f.length
FROM film f 
LEFT OUTER JOIN film_actor fa ON f.film_id = fa.film_id 
WHERE fa.actor_id IS NULL
ORDER BY film_id ;

����8��) store ���� id�� �ּ� (address, address2, distict) �� �ش� ������ ��ġ�� city �ּҸ� �˷��ּ���. 	

SELECT * FROM STORE ;
SELECT * FROM address a ;
SELECT * FROM city c ;

SELECT a.address , a.address2 , a.district , c.city 
FROM address a 
LEFT OUTER JOIN store s ON a.address_id = s.address_id 
JOIN city c ON a.city_id = c.city_id 
WHERE s.address_id IS NOT NULL;

����9��) ���� id ���� ���� �̸� (first_name, last_name), �̸���, ���� �ּ� (address, district), phone��ȣ, city, country �� �˷��ּ���. 	

SELECT * FROM customer c ;

SELECT c.first_name ||', '|| c.last_name AS CUSTOMER_NAME ,
	   c.email,
	   a.address ||', '|| a.district AS CUSTOMER_ADDRESS ,
	   a.phone ,
	   ct.city ,
	   cn.country 
FROM customer c 
JOIN address a ON c.address_id = a.address_id 
JOIN city ct ON a.city_id = ct.city_id 
JOIN country cn ON ct.country_id = cn.country_id ;

����10��) country �� china �� �ƴ� ������ ���, ���� �̸�(first_name, last_name)�� , email, phonenumber, country, city �� �˷��ּ���	Ǯ��

--�ƴ�����: �̳����λ��
SELECT * FROM customer c ;

SELECT c.first_name , c.last_name, c.email , a.phone , cn.country , ct.city 
FROM customer c 
JOIN address a ON c.address_id = a.address_id 
JOIN city ct ON a.city_id = ct.city_id
JOIN country cn ON ct.country_id = cn.country_id
WHERE cn.country NOT IN ('China') ;

����11��) Horror ī�װ� �帣�� �ش��ϴ� ��ȭ�� �̸��� description �� ���ؼ� �˷��ּ��� 	

SELECT * FROM film f ;
SELECT * FROM film_category fc ;
SELECT * FROM category c ;

SELECT f.title, f.description
FROM film f 
JOIN film_category fc ON f.film_id = fc.film_id 
JOIN category c ON fc.category_id = c.category_id 
WHERE c.name = 'Horror' ;

����12��) Music �帣�̸鼭, ��ȭ���̰� 60~180�� ���̿� �ش��ϴ� ��ȭ�� title, description, length �� �˷��ּ���. Ǯ��
   -  ��ȭ ���̰� ª�� ������ �����ؼ� �˷��ּ���. 	
   
SELECT * FROM film f ;
SELECT * FROM film_category fc ;
SELECT * FROM category c ;

SELECT F.TITLE , F.DESCRIPTION , F.LENGTH 
FROM FILM F 
JOIN FILM_CATEGORY FC ON F.FILM_ID = FC.FILM_ID
JOIN CATEGORY C ON FC.CATEGORY_ID = C.CATEGORY_ID 
WHERE C.NAME = 'MUSIC'
AND F.LENGTH BETWEEN 60 AND 180
ORDER BY F.LENGTH ;
 
����13��) actor ���̺��� �̿��Ͽ�,  ����� ID, �̸�, �� �÷��� �߰���    
'Angels Life' ��ȭ�� ���� ��ȭ ��� ���θ� Y , N ���� �÷��� �߰� ǥ�����ּ���.  �ش� �÷��� angelslife_flag�� ������ּ���.	         Ǯ��

SELECT * FROM actor a ;
SELECT * FROM film f ;
SELECT * FROM film_actor fa ;

-- Angels Life ��� �̸��� ���� ��ȭ�� Ȯ��.
SELECT *
FROM film f 
WHERE title = 'Angels Life' ;

-- film�� film_actor ���̺��� �����Ͽ� Angels Life�� ���� ��ȭ������ Ȯ��.
SELECT f.film_id , f.title , fa.actor_id 
FROM film f 
JOIN film_actor fa ON f.film_id = fa.film_id
WHERE title = 'Angels Life' ;
/* 1,4,7,47,91,136,166,167,187 */

SELECT a.actor_id , a.first_name , a.last_name ,
	   CASE WHEN angels_actor.actor_id IS NOT NULL THEN 'Y'
	   ELSE 'N'
	   END AS angelslife_flag
FROM actor a -- actor ���̺� �ߺ��� �߻����� �ʴ´�.
LEFT OUTER JOIN ( --��ȭ�� ���� ��ȭ������ ������ ���������� ����� actor�� outer join. �� �ʸ��� �⿬�ϴ� ���� �ߺ� �߻�����.
				  -- left outer join�� ����Ͽ� NULL �������� ��� �����;� �Ѵ�.
					SELECT f.film_id , f.title , fa.actor_id 
					FROM film f 
					JOIN film_actor fa ON f.film_id = fa.film_id
					WHERE title = 'Angels Life' 
) AS angels_actor -- �ش� ���������� �̸��� angels_actor �� ������
ON a.actor_id = angels_actor.actor_id ; -- LEFT OUTER JOIN�� ������ actor_id�� ����.

film_actor fa ON a.actor_id = fa.actor_id -- NULL ������ ���������� OUTER JOIN�� ����
JOIN film f ON fa.film_id = f.film_id ;

����14��) �뿩���ڰ� 2005-06-01~ 14�Ͽ� �ش��ϴ� �ֹ� �߿��� , 
������ �̸�(�̸� ��) = 'Mike Hillyer' �̰ų�  ���� �̸��� (�̸� ��) ='Gloria Cook'  �� �ش� �ϴ� rental �� ��� ������ �˷��ּ���. Ǯ��
 - �߰���  �����̸���, ���̸��� ���ؼ���  fullname ���� �����ؼ� �˷��ּ���.	
 
SELECT * FROM rental r ;

SELECT r.* , 
	   c.first_name ||' '|| c.last_name AS c_fullname , 
	   s.first_name ||' '|| s.last_name AS s_fullname 
FROM rental r 
JOIN customer c ON r.customer_id = c.customer_id 
JOIN staff s ON r.staff_id = s.staff_id 
WHERE date(rental_date) BETWEEN '2005-06-01' AND '2005-06-14'
AND (s.first_name ||' '|| s.last_name = 'Mike Hillyer'
	OR c.first_name ||' '|| c.last_name = 'Gloria Cook') ;

����15��) �뿩���ڰ� 2005-06-01~ 14�Ͽ� �ش��ϴ� �ֹ� �߿��� , ������ �̸�(�̸� ��) = 'Mike Hillyer' �� �ش� �ϴ� ��������  �������� ����  rental �� ��� ������ �˷��ּ���.
 - �߰���  �����̸���, ���̸��� ���ؼ���  fullname ���� �����ؼ� �˷��ּ���.	
 
SELECT *
FROM rental r
WHERE date(r.rental_date) BETWEEN '2005-06-01' AND '2005-06-14' ;

SELECT r.*
FROM rental r 
JOIN (SELECT *
		FROM staff s2
		WHERE s2.first_name||' '|| s2.last_name = 'Mike Hillyer' 
) AS s ON r.staff_id = s.staff_id
WHERE date(r.rental_date) BETWEEN '2005-06-01' AND '2005-06-14' ;