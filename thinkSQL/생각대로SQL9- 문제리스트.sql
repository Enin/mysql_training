����1��) dvd �뿩�� ���� ������ �� �̸���?   (with �� Ȱ��)	

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


����7��) Payement ���̺��� ��������,  ������ ���� Quarter �б⸦ �Բ� ǥ�����ּ���.
with ���� Ȱ���ؼ� Ǯ�����ּ���.
1~���� ��� Q1
4~6�� �� ��� Q2
7~9���� ��� Q3
10~12���� ��� Q4


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



