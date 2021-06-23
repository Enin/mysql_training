����1��) film ���̺��� Ȱ���Ͽ�,  film ���̺���  100���� row �� Ȯ���غ�����. 	

SELECT *
FROM film f 
LIMIT 100 ;

����2��) actor �� ��(last_name) ��  Jo �� �����ϴ� ����� id ���� ���� ���� ��� �ѻ���� ���Ͽ�, �����  id ����  �̸�, �� �� �˷��ּ���.	Ǯ��.

SELECT * FROM ACTOR;

SELECT a.ACTOR_ID, a.FIRST_NAME, a.LAST_NAME
FROM actor a 
WHERE a.last_name LIKE 'Jo%'	-- LIKE �� ���
ORDER BY actor_id -- ACTOR ID �������� �������� ����
LIMIT 1 ; -- ���� ���� ��� 1�� ���.

����3��)film ���̺��� �̿��Ͽ�, film ���̺��� ���̵��� 1~10 ���̿� �ִ� ��� �÷��� Ȯ�����ּ���.	Ǯ��

SELECT *
FROM film f 
WHERE film_id BETWEEN 1 AND 10 ; -- ���� ���� �����ϴ� Ʃ�� ���.

SELECT *
FROM rental r 
WHERE DATE(rental_date) BETWEEN '2005-05-25' AND '2005-06-20' ;

����4��) country ���̺��� �̿��Ͽ�, country �̸��� A �� �����ϴ� country �� Ȯ�����ּ���.	

SELECT COUNTRY
FROM country c 
WHERE country LIKE 'A%' ;

����5��) country ���̺��� �̿��Ͽ�, country �̸��� s �� ������ country �� Ȯ�����ּ���.	

SELECT COUNTRY
FROM country c 
WHERE country LIKE '%s' ;

����6��) address ���̺��� �̿��Ͽ�, �����ȣ(postal_code) ���� 77�� �����ϴ�  �ּҿ� ���Ͽ�, address_id, address, district ,postal_code  �÷��� Ȯ�����ּ���.	

SELECT ADDRESS_ID, ADDRESS, DISTRICT, POSTAL_CODE
FROM address a 
WHERE postal_code LIKE '77%' ;

����7��) address ���̺��� �̿��Ͽ�, �����ȣ(postal_code) ����  �ι�°���ڰ� 1�� �����ȣ��  address_id, address, district ,postal_code  �÷��� Ȯ�����ּ���.	Ǯ��

SELECT ADDRESS_ID, ADDRESS, DISTRICT, POSTAL_CODE,
		substring(postal_code, 1, 1) as test1, -- substring(�÷�, ����idx, ����� ����) ���� idx�� 1���� ���� ����.
		substring(postal_code, 2, 1) as test2, -- ���ڿ��� ���������� ����~���� ��ŭ ����ϴ� �Լ�.
		substring(postal_code, 3, 1) as test2
FROM address a ;

SELECT ADDRESS_ID, ADDRESS, DISTRICT, POSTAL_CODE
FROM address a
WHERE substring(postal_code, 2, 1) = '1' ; -- SUBSTRING �Լ��� ����Ͽ� Ư�� �ι��� ������ Ȯ��. 

����8��) payment ���̺��� �̿��Ͽ�,  ����ȣ�� 341�� �ش� �ϴ� ����� ������ 2007�� 2�� 15~16�� ���̿� �� ��� ���������� Ȯ�����ּ���.

SELECT *
FROM payment p
WHERE customer_id = 341
AND DATE(payment_date) BETWEEN '2007-02-15' AND '2007-02-16' ;

����9��) payment ���̺��� �̿��Ͽ�, ����ȣ�� 355�� �ش� �ϴ� ����� ���� �ݾ��� 1~3�� ���̿� �ش��ϴ� ��� ���� ������ Ȯ�����ּ���.	Ǯ��.

SELECT * FROM payment p
WHERE customer_id = 355
AND amount BETWEEN 1 AND 3;

����10��) customer ���̺��� �̿��Ͽ�, ���� �̸��� Maria, Lisa, Mike �� �ش��ϴ� ����� id, �̸�, ���� Ȯ�����ּ���.	

SELECT c.customer_id, c.first_name , c.last_name 
FROM customer c
WHERE c.first_name IN ('Maria', 'Lisa', 'Mike') ; 

����11��) film ���̺��� �̿��Ͽ�,  film�� ���̰�  100~120 �� �ش��ϰų� �Ǵ� rental �뿩�Ⱓ�� 3~5�Ͽ� �ش��ϴ� film �� ��� ������ Ȯ�����ּ���.	Ǯ��

SELECT *
FROM film f
WHERE length BETWEEN 100 AND 120
OR rental_duration BETWEEN 3 AND 5 ;

����12��) address ���̺��� �̿��Ͽ�, postal_code ����  ����('') �̰ų� 35200, 17886 �� �ش��ϴ� address �� ��� ������ Ȯ�����ּ���.	Ǯ��

SELECT *
FROM address a 
WHERE postal_code IN ('', '35200', '17886') ; -- postal code�� varchar(10) �̱� ������ ���ڿ��� �Է�.

SELECT *,
	CASE WHEN postal_code  = '' THEN 'empty' -- case when���� ����Ͽ� ������ �����ϴ� ���ο� �÷��� ����. ���� ������ �ش� ���� �־���.
		WHEN postal_code = '35200' THEN '35200_' -- WHEN���� ������ �̾ ������ �̾��� �� �ִ�.
		ELSE postal_code 					-- else���� case���� �������� ������ ���: postal_code ���� �״�� ���� ���ο� �÷� �߰�.
	END AS postal_code_emptyflag			-- �÷����� as�������� ����.
FROM address a 
WHERE postal_code IN ('', '35200', '17886') ;

����13��) address ���̺��� �̿��Ͽ�,  address �� ���ּ�(=address2) ����  �������� �ʴ� ��� �����͸� Ȯ���Ͽ� �ּ���. 	

SELECT *
FROM address a 
WHERE address2 IS NULL ;

����14��) staff ���̺��� �̿��Ͽ�, staff ��  picture  ������ ���� �ִ�  ������  id, �̸�,���� Ȯ�����ּ���.  �� �̸��� ����  �ϳ��� �÷����� �̸�, �������·�  ���ο� �÷� name �÷����� �������ּ���.	

SELECT staff_id , first_name ||', '|| last_name AS name
FROM STAFF
WHERE picture IS NOT NULL ;

����15��) rental ���̺��� �̿��Ͽ�,  �뿩�������� ���� �ݳ� ����� ���� �뿩���� ��� ������ Ȯ�����ּ���.	

SELECT *
FROM rental r
WHERE rental_date IS NOT NULL 
AND return_date IS NULL ;

����16��) address ���̺��� �̿��Ͽ�, postal_code ����  �� ��(NULL) �̰ų� 35200, 17886 �� �ش��ϴ� address �� ��� ������ Ȯ�����ּ���.	
�������� > ADDRESS2���� NULL ���� �ְų��� ����!

SELECT *
FROM address a
WHERE postal_code IN ('35200', 
					  '17886') -- IN ���� ����
OR address2 IS NULL ; -- ������ ������ OR�� ó��.
 
����17��) ���� ���� John �̶�� �ܾ ����, ���� �̸��� ���� ��� ã���ּ���.	Ǯ��

SELECT first_name , last_name 
FROM customer c
WHERE last_name LIKE '%John%' ;

����18��) �ּ� ���̺���, address2 ���� null ���� row ��ü�� Ȯ���غ����? Ǯ��

SELECT *
FROM address a
WHERE address2 IS NULL ;

