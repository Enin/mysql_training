����1��) dvd �뿩�� ���� ������ �� �̸���?   (with �� Ȱ��)	

WITH TB1 AS (
	SELECT r.customer_id , COUNT (r.rental_id) AS CNT
	FROM rental r
	GROUP BY r.customer_id 
	LIMIT 1	)
SELECT c.first_name , c.last_name 
FROM customer c 
JOIN TB1 ON c.customer_id = TB1.customer_id ;


����2��) ��ȭ �ð� ���� (length_type)�� ���� ��ȭ ���� ���ϼ���.
��ȭ �� �ð� ������ ���Ǵ� ������ �����ϴ�.
��ȭ ���� (length) �� 60�� ���� short , 61�� �̻� 120�� ���� middle , 121 ���̻� long ���� �Ѵ�. Ǯ��

WITH TB1 AS(
	SELECT 0 AS CHK1, 60 AS CHK2, 'SHORT' AS LENGTH_FLAG
	UNION ALL
	SELECT 61 AS CHK1, 120 AS CHK2, 'MIDDLE' AS LENGTH_FLAG
	UNION ALL
	SELECT 121 AS CHK1, 999 AS CHK2, 'LONG' AS LENGTH_FLAG
)
SELECT length_flag, count(film_id) as cnt
FROM (
SELECT f.film_id , f.length , tb1.length_flag
FROM film f 
LEFT OUTER JOIN TB1 ON f.length BETWEEN TB1.CHK1 AND TB1.CHK2 ) AS DB -- �����Ҷ� F.LENGTH�� CHK1 ~ CHK2 ���̿� �ִ��� Ȯ��
GROUP BY length_flag ;


����3��) ���� ǥ���Ǿ� �ִ� ��ȭ���(rating) �� ������, �ѱ۸�� ���� ǥ���� �ּ���. (with �� Ȱ��) Ǯ��

G        ? General Audiences (��� ���ɴ� ��û����)
PG      ? Parental Guidance Suggested. (��� ���ɴ� ��û�����ϳ�, �θ��� ������ �ʿ�)
PG-13 ? Parents Strongly Cautioned (13�� �̸��� �Ƶ����� ������ �� �� ������, �θ��� ���Ǹ� ����)
R         ? Restricted. (17�� �Ǵ� ���̻��� ����)
NC-17 ? No One 17 and Under Admitted.  (17�� ���� ��û �Ұ�)	

WITH TB1 AS ( 
	SELECT 'G' AS RATING, 'General Audiences' AS ENG_TEXT, '(��� ���ɴ� ��û����)' AS KR_TEXT UNION ALL
	SELECT 'PG' AS RATING, 'Parental Guidance Suggested' AS ENG_TEXT, '(��� ���ɴ� ��û�����ϳ�, �θ��� ������ �ʿ�)' AS KR_TEXT UNION ALL
	SELECT 'PG-13' AS RATING, 'Parents Strongly Cautioned' AS ENG_TEXT, '(13�� �̸��� �Ƶ����� ������ �� �� ������, �θ��� ���Ǹ� ����)' AS KR_TEXT UNION ALL
	SELECT 'R' AS RATING, 'Restricted' AS ENG_TEXT, '(17�� �Ǵ� ���̻��� ����)' AS KR_TEXT UNION ALL
	SELECT 'NC-17' AS RATING, 'No One 17 and Under Admitted' AS ENG_TEXT, '(17�� ���� ��û �Ұ�)' AS KR_TEXT )
SELECT *
FROM film f 
LEFT OUTER JOIN TB1 ON CAST(f.rating as varchar) = TB1.rating ; -- CAST �Լ��� f.rating �� Ÿ���� varchar�� ����


����4��) �� ��޺� �� ���� ���ϼ���. (�뿩 Ƚ���� ���� �� ����� ������ ������ �Ʒ��� �����ϴ�.)

A ����� 31ȸ �̻�
B ����� 21ȸ �̻� 30ȸ ���� 
C ����� 11ȸ �̻� 20ȸ ����
D ����� 10ȸ ����

WITH TB1 AS (
	SELECT 'A' AS RATING, 31 CHK1, 999 CHK2 UNION ALL
	SELECT 'B' AS RATING, 21 CHK1, 30 CHK2 UNION ALL
	SELECT 'C' AS RATING, 11 CHK1, 20 CHK2 UNION ALL
	SELECT 'D' AS RATING, 0  CHK1, 10 CHK2 )
SELECT rating, count(customer_id) as cnt
FROM (
	SELECT customer_id , rating
	FROM (
		SELECT r.customer_id , COUNT(r.rental_id) AS CNT
		FROM rental r 
		GROUP BY r.customer_id ) AS DB	
	LEFT OUTER JOIN TB1 ON DB.CNT BETWEEN TB1.CHK1 AND TB1.CHK2 ) AS DB 
GROUP BY rating 
ORDER BY rating;


����5��) �� �̸� ���� , flag  �� �ٿ��� �����ּ���. Ǯ��
- ���� first_name �̸��� ù��° ���ڰ�, A, B,C �� �ش� �ϴ� �����  �� A,B,C �� flag �� �ٿ��ֽð� 
   A,B,C �� �ش����� �ʴ� �ο��� ���ؼ��� Others ��� flag ��  �ٿ��ּ���.	
   
-- coalesce() ~= NVL() ==> NULL ���� �߻������� ���� ġȯ�ϴ� �Լ�.
WITH TB1 AS ( 
	SELECT 'A' CHK1, 'A' flag union all
	SELECT 'B' CHK1, 'B' flag union all
    SELECT 'C' CHK1, 'C' flag )
SELECT customer_id , first_name , COALESCE (flag, 'others') as flag
FROM customer c 
LEFT OUTER JOIN TB1 ON substring(c.first_name, 1, 1) = TB1.CHK1 ;  -- SUBSTRING = ���ڿ����� Ư�� ���ڸ� �̾Ƴ��� �Լ�, �빮�� ��ȯ UPPER(), �ҹ��ں�ȯ LOWER()


   
����6��) payment ���̺��� ��������,  2007�� 1��~ 3�� ������ �����Ͽ� �ش��ϸ�,  staff2�� �ο����� ������ ������  �����ǿ� ���ؼ���, Y ��   
�� �ܿ� ���ؼ��� N ���� ǥ�����ּ���. with ���� �̿����ּ���.	

WITH TB1 AS (
	SELECT 2 AS STAFF_ID, 'Y' AS FLAG, CAST('2007-01-01 00:00:00' AS TIMESTAMP) AS D1, CAST('2007-03-31 23:59:59' AS TIMESTAMP) AS D2 )
SELECT p.* , COALESCE (TB1.FLAG, 'N') AS FLAG
FROM payment p 
LEFT OUTER JOIN TB1 ON p.staff_id = TB1.STAFF_ID AND p.payment_date BETWEEN TB1.D1 AND TB1.D2 ;



����7��) Payement ���̺��� ��������,  ������ ���� Quarter �б⸦ �Բ� ǥ�����ּ���.
with ���� Ȱ���ؼ� Ǯ�����ּ���.
1~���� ��� Q1
4~6�� �� ��� Q2
7~9���� ��� Q3
10~12���� ��� Q4

WITH TB1 AS (
	SELECT 1 CHK1, 3 CHK2, 'Q1' QUATERS UNION ALL
	SELECT 4 CHK1, 6 CHK2, 'Q2' QUATERS UNION ALL
	SELECT 7 CHK1, 9 CHK2, 'Q3' QUATERS UNION ALL
	SELECT 10 CHK1, 12 CHK2, 'Q4' QUATERS )
SELECT p.* , TB1.QUATERS
FROM payment p 
LEFT OUTER JOIN TB1 ON CAST(TO_CHAR(p.payment_date, 'MM') AS INT) BETWEEN TB1.CHK1 AND TB1.CHK2 ;


����8��) Rental ���̺��� ��������,  ȸ�����ڿ� ���� Quater �б⸦ �Բ� ǥ�����ּ���. Ǯ��
with ���� Ȱ���ؼ� Ǯ�����ּ���.
1~3���� ��� Q1
4~6�� �� ��� Q2
7~9���� ��� Q3
10~12���� ��� Q4 �� �Բ� �����ּ���.

WITH TB1 AS (
	SELECT CAST('2005-01-01 00:00:00' AS TIMESTAMP) CHK1, CAST('2005-03-31 23:59:59' AS TIMESTAMP) CHK2, 'Q1' QUATERS UNION ALL
	SELECT CAST('2005-04-01 00:00:00' AS TIMESTAMP) CHK1, CAST('2005-06-30 23:59:59' AS TIMESTAMP) CHK2, 'Q2' QUATERS UNION ALL
	SELECT CAST('2005-07-01 00:00:00' AS TIMESTAMP) CHK1, CAST('2005-09-30 23:59:59' AS TIMESTAMP) CHK2, 'Q3' QUATERS UNION ALL
	SELECT CAST('2005-10-01 00:00:00' AS TIMESTAMP) CHK1, CAST('2005-12-31 23:59:59' AS TIMESTAMP) CHK2, 'Q4' QUATERS )
SELECT r.* , TB1.QUATERS
FROM rental r 
LEFT OUTER JOIN TB1 ON r.rental_date BETWEEN TB1.CHK1 AND TB1.CHK2 ;
	


����9��) ��������  ����  �뿩�� ���� ��  �뿩 ������ ��� �Ǵ� �� �˷��ּ���. 
�뿩 ������   �Ʒ��� �ش� �ϴ� ��쿡 ���ؼ�, �� flag �� �˷��ּ��� .

0~ 500�� �� ���  under_500 
501~ 3000 ���� ���  under_3000
3001 ~ 99999 ���� ���  over_3001  

WITH TB1 AS (
	SELECT 0 CHK1 , 500 CHK2 , 'UNDER_500' FLAG UNION ALL
	SELECT 501 CHK1 , 3000 CHK2 , 'UNDER_3000' FLAG UNION ALL
	SELECT 3001 CHK1 , 99999 CHK2 , 'OVER_3001' FLAG )
SELECT DB.*, TB1.FLAG
FROM (
	SELECT r.staff_id , TO_CHAR(r.rental_date, 'mm') as months , count(r.rental_id) as cnt
	FROM rental r 
	GROUP BY GROUPING SETS ((r.staff_id , TO_CHAR(r.rental_date, 'mm')))
	ORDER BY TO_CHAR(r.rental_date, 'mm') ) AS DB
LEFT OUTER JOIN TB1 ON DB.CNT BETWEEN TB1.CHK1 AND TB1.CHK2 ;


����10��) ������ ���� �н����忡 ���ؼ�, ������  �н����带 �����Ϸ��� �մϴ�. Ǯ��
����1�� ���ο� �н������ 12345  ,  ����2�� ���ο� �н������ 54321�Դϴ�.
�ش��� ���, �������� ���� �н������ ���� ������ ������Ʈ�� �н����带 
�Բ� �����ּ���.
with ���� Ȱ���Ͽ�  ���ο� �н����� ������ ���� �� , �˷��ּ���.	

WITH NEW_PASSWORD AS (
	SELECT 1 AS staff_id , '12345' AS NEW_PWD UNION ALL
	SELECT 2 AS staff_id , '54321' AS NEW_PWD )
SELECT s.staff_id , s."password" , np.new_pwd
FROM staff s
JOIN NEW_PASSWORD AS NP ON s.staff_id = np.staff_id ;



