문제1번) 1번 주문 번호에 대해서, 상품명, 주문 금액과 1번 주문 금액에 대한 총 구매금액을 함께 보여주세요. 

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



문제2번) 헬멧을 주문한 모든 고객과 자전거를 주문한 모든 고객을 나열하세요. (Union 활용) 헬멧과 자전거는 Products 테이블의 productname 컬럼을 이용해서 확인해주세요.

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


문제3번) 주문일자가 2017/09/01 ~ 2017/09/30 일에 해당하는 주문에 대해서 주문일자와 고객별로 주문 수를 확인해주세요. 
또한 고객별 주문 수도 함께 알려주세요.


WITH TB1 AS (
	SELECT CAST('2017-09-01' AS TIMESTAMP) CHK1, CAST('2017-09-30' AS TIMESTAMP) CHK2 )
SELECT o.orderdate , o.customerid , COUNT(o.ordernumber) AS CNT
FROM orders o 
JOIN TB1 ON o.orderdate BETWEEN TB1.CHK1 AND TB1.CHK2 
GROUP BY GROUPING SETS ( (o.customerid , o.orderdate), (o.customerid) ) 
ORDER BY o.orderdate , o.customerid ;




문제4번) 주문일자가 2017/09/01 ~ 2017/09/30일에 해당하는 주문에 대해서, 주문일자와 고객별로 주문 수를 확인해주세요. 
또한 주문일자별 주문 수도 함께 알려주시고, 전체 주문 수도 함께 알려주세요.

 
WITH TB1 AS (
	SELECT CAST('2017-09-01' AS TIMESTAMP) CHK1, CAST('2017-09-30' AS TIMESTAMP) CHK2 )
SELECT o.orderdate , o.customerid , COUNT(o.ordernumber) AS CNT
FROM orders o 
JOIN TB1 ON o.orderdate BETWEEN TB1.CHK1 AND TB1.CHK2 
GROUP BY ROLLUP ( o.customerid , o.orderdate ) 
ORDER BY o.orderdate , o.customerid ;


문제5번) 2017년도의 주문일 별 주문 금액과, 월별 주문 총 금액을 함께 보여주세요. 
동시에 일별 주문 금액이 월별 주문 금액에 해당하는 비율을 같이 보여주세요. (analytic function 활용)


WITH MONTHLY AS ( 
	SELECT TO_CHAR(o.orderdate, 'MM') AS MONTHS ,
		   SUM(od.quotedprice * od.quantityordered) AS TOTAL_MONTH_PRICE
	FROM orders o 
	JOIN order_details od ON o.ordernumber = od.ordernumber
	WHERE TO_CHAR(o.orderdate, 'YYYY') = '2017'
	GROUP BY TO_CHAR(o.orderdate, 'MM') )
SELECT DB.*,
	DB.TOTAL_PRICE * 100 / MONTHLY.TOTAL_MONTH_PRICE AS PERSENTAGE
FROM (-- 주문일별 주문 금액
	SELECT TO_CHAR(o.orderdate, 'MM') AS MONTHS ,
		   TO_CHAR(o.orderdate, 'DD') AS DAYS ,
		   SUM(od.quotedprice * od.quantityordered) AS TOTAL_PRICE
	FROM orders o 
	JOIN order_details od ON o.ordernumber = od.ordernumber
	WHERE TO_CHAR(o.orderdate, 'YYYY') = '2017'
	GROUP BY GROUPING SETS ( (TO_CHAR(o.orderdate, 'MM'), TO_CHAR(o.orderdate, 'DD')) , TO_CHAR(o.orderdate, 'MM') ) 
	ORDER BY TO_CHAR(o.orderdate, 'MM') , TO_CHAR(o.orderdate, 'DD') ) AS DB
JOIN MONTHLY ON DB.MONTHS = MONTHLY.MONTHS ;





-- 퀴즈1
select *
from (
	select p.productnumber , count(pv.vendorid) as cnt
	from products p 
	join product_vendors pv on p.productnumber = pv.productnumber 
	group by p.productnumber ) as db
where cnt >= 4 ;


-- 퀴즈2
select sum(db.quotedprice * db.quantityordered) as sums
from (
	select *
	from order_details od 
	join orders o on od.ordernumber = o.ordernumber 
	where o.customerid = 1024 and
		to_char(o.orderdate, 'yyyy-mm-dd') = '2018-01-11' and 
		o.ordernumber = 652 ) as db ;

	
-- 퀴즈4
	
with tb1 as (
	select avg(retailprice) over() as avgs
	from products p2 
	limit 1 )
select distinct p.productnumber , od.quotedprice , tb1.avgs
from order_details od 
join products p on od.productnumber = p.productnumber 
join tb1 on od.quotedprice > tb1.avgs 
order by p.productnumber ;




















