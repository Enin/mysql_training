����1��) 1�� �ֹ� ��ȣ�� ���ؼ�, ��ǰ��, �ֹ� �ݾװ� 1�� �ֹ� �ݾ׿� ���� �� ���űݾ��� �Բ� �����ּ���. 

SELECT p.productname , od.quotedprice 
FROM orders o 
JOIN order_details od ON o.ordernumber = od.ordernumber 
JOIN products p ON od.productnumber = p.productnumber 
WHERE o.ordernumber = 1
UNION all 
SELECT 'All PAYMENT PRICE:' , sum(od2.quotedprice)
FROM order_details od2 
WHERE ordernumber = 1
GROUP BY ordernumber ;



����2��) ����� �ֹ��� ��� ���� �����Ÿ� �ֹ��� ��� ���� �����ϼ���. (Union Ȱ��) ���� �����Ŵ� Products ���̺��� productname �÷��� �̿��ؼ� Ȯ�����ּ���.

SELECT c.customerid
FROM orders o 
JOIN order_details od ON o.ordernumber = od.ordernumber 
JOIN products p ON od.productnumber = p.productnumber 
JOIN customers c ON o.customerid = c.customerid 
WHERE p.productname LIKE ('%Helmet') 
union
SELECT c2.customerid
FROM orders o2 
JOIN order_details od2 ON o2.ordernumber = od2.ordernumber 
JOIN products p2 ON od2.productnumber = p2.productnumber 
JOIN customers c2 ON o2.customerid = c2.customerid 
WHERE p2.productname LIKE ('%Bike') 
ORDER BY customerid ;

SELECT CUSTOMERID
FROM customers c ;


����3��) �ֹ����ڰ� 2017/09/01 ~ 2017/09/30 �Ͽ� �ش��ϴ� �ֹ��� ���ؼ� �ֹ����ڿ� ������ �ֹ� ���� Ȯ�����ּ���. 
���� ���� �ֹ� ���� �Բ� �˷��ּ���.


WITH TB1 AS (
	SELECT CAST('2017-09-01' AS TIMESTAMP) CHK1, CAST('2017-09-30' AS TIMESTAMP) CHK2 )
SELECT o.orderdate , o.customerid , COUNT(o.ordernumber) AS CNT
FROM orders o 
JOIN TB1 ON o.orderdate BETWEEN TB1.CHK1 AND TB1.CHK2 
GROUP BY GROUPING SETS ( (o.customerid , o.orderdate), (o.customerid) ) 
ORDER BY o.orderdate , o.customerid ;




����4��) �ֹ����ڰ� 2017/09/01 ~ 2017/09/30�Ͽ� �ش��ϴ� �ֹ��� ���ؼ�, �ֹ����ڿ� ������ �ֹ� ���� Ȯ�����ּ���. 
���� �ֹ����ں� �ֹ� ���� �Բ� �˷��ֽð�, ��ü �ֹ� ���� �Բ� �˷��ּ���.

 
WITH TB1 AS (
	SELECT CAST('2017-09-01' AS TIMESTAMP) CHK1, CAST('2017-09-30' AS TIMESTAMP) CHK2 )
SELECT o.orderdate , o.customerid , COUNT(o.ordernumber) AS CNT
FROM orders o 
JOIN TB1 ON o.orderdate BETWEEN TB1.CHK1 AND TB1.CHK2 
GROUP BY ROLLUP ( o.customerid , o.orderdate ) 
ORDER BY o.orderdate , o.customerid ;


����5��) 2017�⵵�� �ֹ��� �� �ֹ� �ݾװ�, ���� �ֹ� �� �ݾ��� �Բ� �����ּ���. 
���ÿ� �Ϻ� �ֹ� �ݾ��� ���� �ֹ� �ݾ׿� �ش��ϴ� ������ ���� �����ּ���. (analytic function Ȱ��)


WITH MONTHLY AS ( 
	SELECT TO_CHAR(o.orderdate, 'MM') AS MONTHS ,
		   SUM(od.quotedprice * od.quantityordered) AS TOTAL_MONTH_PRICE
	FROM orders o 
	JOIN order_details od ON o.ordernumber = od.ordernumber
	WHERE TO_CHAR(o.orderdate, 'YYYY') = '2017'
	GROUP BY TO_CHAR(o.orderdate, 'MM') )
SELECT DB.*,
	DB.TOTAL_PRICE * 100 / MONTHLY.TOTAL_MONTH_PRICE AS PERSENTAGE
FROM (-- �ֹ��Ϻ� �ֹ� �ݾ�
	SELECT TO_CHAR(o.orderdate, 'MM') AS MONTHS ,
		   TO_CHAR(o.orderdate, 'DD') AS DAYS ,
		   SUM(od.quotedprice * od.quantityordered) AS TOTAL_PRICE
	FROM orders o 
	JOIN order_details od ON o.ordernumber = od.ordernumber
	WHERE TO_CHAR(o.orderdate, 'YYYY') = '2017'
	GROUP BY GROUPING SETS ( (TO_CHAR(o.orderdate, 'MM'), TO_CHAR(o.orderdate, 'DD')) , TO_CHAR(o.orderdate, 'MM') ) 
	ORDER BY TO_CHAR(o.orderdate, 'MM') , TO_CHAR(o.orderdate, 'DD') ) AS DB
JOIN MONTHLY ON DB.MONTHS = MONTHLY.MONTHS ;





-- ����1
select *
from (
	select p.productnumber , count(pv.vendorid) as cnt
	from products p 
	join product_vendors pv on p.productnumber = pv.productnumber 
	group by p.productnumber ) as db
where cnt >= 4 ;


-- ����2
select sum(db.quotedprice * db.quantityordered) as sums
from (
	select *
	from order_details od 
	join orders o on od.ordernumber = o.ordernumber 
	where o.customerid = 1024 and
		to_char(o.orderdate, 'yyyy-mm-dd') = '2018-01-11' and 
		o.ordernumber = 652 ) as db ;

	
-- ����4
	
with tb1 as (
	select avg(retailprice) over() as avgs
	from products p2 
	limit 1 )
select distinct p.productnumber , od.quotedprice , tb1.avgs
from order_details od 
join products p on od.productnumber = p.productnumber 
join tb1 on od.quotedprice > tb1.avgs 
order by p.productnumber ;




















