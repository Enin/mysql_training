����1��)  �� ��ǰ ������ 5 % ���̸� ��� �ɱ��?

SELECT retailprice * 0.95 AS retailprice 
FROM products p ;

����2��) orders ���̺��� Ȱ���Ͽ�, ����ȣ�� 1001 �� �ش��ϴ� ����� employeeid �� 707�� �������κ���  �� �ֹ��� id �� �ֹ� ��¥�� �˷��ּ���.  
         * �ֹ����ڰ� ������������ �����Ͽ�, �����ּ���.

SELECT ordernumber 
	, orderdate 
FROM orders o
WHERE employeeid = 707
AND customerid =1001
ORDER BY orderdate ASC ;

����3��)  vendors ���̺��� �̿��Ͽ�, ������ ��ġ�� state �ְ� ��� �Ǵ���, Ȯ���غ�����.  �ߺ��� �ְ� �ִٸ�, �ߺ����� �Ŀ� �˷��ּ���. 

SELECT DISTINCT vendstate 
FROM vendors v ;


����4��) products ���̺��� Ȱ���Ͽ�, productdescription�� ��ǰ �� ���� ���� ����  ��ǰ �����͸� ��� �˷��ּ���.

SELECT *
FROM products p
WHERE productdescription IS NULL ;


����5��)  customers ���̺��� �̿��Ͽ�, ���� id ����,  custstate ���� �� WA ������ ��� �����  WA �� �ƴ� ������ ��� ����� �����ؼ�  �����ּ���.
 - customerid ��,  newstate_flag �÷����� �������ּ��� .
 - newstate_flag �÷��� WA �� OTHERS ��  �������ֽø� �˴ϴ�.

SELECT customerid ,
	CASE WHEN custstate = 'WA' THEN 'WA'
		 ELSE 'OTHERS'
	END AS newstate_flag
FROM customers c ;


1. employees ���̺��� �̿��Ͽ�, 705 ���̵� ���� ������ �̸���, �¾ �ظ� �˷��ּ���.

SELECT empfirstname , empbirthdate 
FROM employees e  
WHERE employeeid = 705;

3. 2017-09-02~ 09-03�� ���̿� �ֹ��� ��, �ֹ���ȣ�� ������ �� ��ΰ���?

SELECT COUNT(*)
FROM orders o 
WHERE orderdate between '2017-09-02' AND '2017-09-03';

5. vendor�� State ������ NY �Ǵ� WA �� ��ü �� ������ ��� �ǳ���? (vendors ���̺��� �̿� �Ͽ� �˷��ּ���)

SELECT COUNT(*)
FROM vendors v 
WHERE vendstate IN ('NY', 'WA') ;

select *
FROM vendors v 
WHERE vendstate IN ('NY', 'WA') ;



