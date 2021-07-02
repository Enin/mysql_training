����1��)  �ֹ����� 2017-09-02 �Ͽ� �ش� �ϴ� �ֹ��ǿ� ���ؼ�,  � ����, ��� ��ǰ�� ���ؼ� �󸶸� �����Ͽ�  ��ǰ�� �����ߴ��� Ȯ�����ּ���.

-- ����
SELECT c.custfirstname||' '||c.custlastname as customername
	 , p.productname , od.quotedprice , od.quantityordered , od.quotedprice * od.quantityordered as Total_Payment
FROM orders o 
JOIN customers c ON o.customerid = c.customerid 
JOIN order_details od ON o.ordernumber = od.ordernumber 
JOIN products p ON od.productnumber = p.productnumber 
WHERE date(o.orderdate) = '2017-09-02' ;

����2��)  ����� �ֹ��� �� ���� ���� �����ּ���. �����, Products ���̺��� productname �÷��� �̿��ؼ� Ȯ�����ּ���.

--EXCEPT ����Ͽ� ��ü��-�۸��ֹ��� ��

select * FROM products p WHERE p.productname LIKE '%Helmet';

-- ��ü ��
SELECT c2.customerid , c2.custfirstname , c2.custlastname 
FROM customers c2
EXCEPT -- ����� �ֹ��� �� ����.
SELECT c.customerid , c.custfirstname , c.custlastname 
FROM orders o 
JOIN customers c ON o.customerid = c.customerid 
JOIN order_details od ON o.ordernumber = od.ordernumber 
JOIN products p ON od.productnumber = p.productnumber 
WHERE p.productname LIKE '%Helmet' ;

����3��)  ��� ��ǰ �� �ֹ� ���ڸ� �����ϼ���. (�ֹ����� ���� ��ǰ�� �����ؼ� �����ּ���.)

-- OUTER JOIN(�ֹ����� ���� ��ǰ NULL)
-- �����ǰ ����
SELECT od.ordernumber , p.productnumber , p.productname , o.orderdate 
FROM products p 
LEFT OUTER JOIN order_details od ON p.productnumber = od.productnumber -- ORDER NUMBER NULL�� ��ǰ�� ����.
LEFT OUTER JOIN orders o ON od.ordernumber = o.ordernumber ; -- db�� ���� �ʾƵ� ���� ���.

-- �ֹ� ���ڴ� orders ���̺� �ִ�. > join ����.

SELECT DB.ordernumber, DB.productnumber , DB.productname, o.orderdate 
FROM (SELECT od.ordernumber , p.productnumber , p.productname 
		FROM products p 
		LEFT OUTER JOIN order_details od ON p.productnumber = od.productnumber) AS DB
LEFT OUTER JOIN orders o ON DB.ordernumber = o.ordernumber ;



����4��) �뿩��(store)�� ��ȭ ���(inventory) ������ ��ü ��ȭ ��� ������? (union all)

-- �뿩�� �� ��ȭ���
SELECT *
FROM product_vendors pv ;
SELECT *
FROM products p ;
SELECT * FROM vendors v ;

-- PRODUCT_VENDERS ��������  VENDERS�� PRODUCTS�� JOIN�� ���̺�
SELECT pv.vendorid , v.vendname , SUM(p.quantityonhand) AS QUANTITY_SUM
FROM product_vendors pv 
JOIN vendors v ON pv.vendorid = v.vendorid 
JOIN products p ON pv.productnumber = p.productnumber
GROUP BY pv.vendorid, v.vendname
UNION ALL
-- ��ü ��ȭ ���
 SELECT NULL , NULL , SUM(p.quantityonhand) AS QUANTITY_SUM 
FROM product_vendors pv 
JOIN vendors v ON pv.vendorid = v.vendorid 
JOIN products p ON pv.productnumber = p.productnumber ;


����5��) Ÿ�̾�� ����� ��� ������ �ִ� ���� ID �� �˷��ּ���.
- Ÿ�̾�� ��信 ���ؼ��� , Products ���̺��� productname �÷��� �̿��ؼ� Ȯ�����ּ���.

-- Ÿ�̾ ������ �� ID
SELECT c.customerid -- , c.custfirstname , c.custlastname 
FROM orders o 
JOIN customers c ON o.customerid = c.customerid 
JOIN order_details od ON o.ordernumber = od.ordernumber 
JOIN products p ON od.productnumber = p.productnumber 
WHERE p.productname LIKE '%Tires'
intersect 
-- ����� ������ �� ID INTERSECT
SELECT c.customerid -- , c.custfirstname , c.custlastname
FROM orders o 
JOIN customers c ON o.customerid = c.customerid 
JOIN order_details od ON o.ordernumber = od.ordernumber 
JOIN products p ON od.productnumber = p.productnumber 
WHERE p.productname LIKE '%Helmet' 
ORDER BY customerid ;






