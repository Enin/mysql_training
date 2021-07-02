문제1번)  주문일이 2017-09-02 일에 해당 하는 주문건에 대해서,  어떤 고객이, 어떠한 상품에 대해서 얼마를 지불하여  상품을 구매했는지 확인해주세요.

-- 조인
SELECT c.custfirstname||' '||c.custlastname as customername
	 , p.productname , od.quotedprice , od.quantityordered , od.quotedprice * od.quantityordered as Total_Payment
FROM orders o 
JOIN customers c ON o.customerid = c.customerid 
JOIN order_details od ON o.ordernumber = od.ordernumber 
JOIN products p ON od.productnumber = p.productnumber 
WHERE date(o.orderdate) = '2017-09-02' ;

문제2번)  헬멧을 주문한 적 없는 고객을 보여주세요. 헬맷은, Products 테이블의 productname 컬럼을 이용해서 확인해주세요.

--EXCEPT 사용하여 전체고객-핼멧주문한 고객

select * FROM products p WHERE p.productname LIKE '%Helmet';

-- 전체 고객
SELECT c2.customerid , c2.custfirstname , c2.custlastname 
FROM customers c2
EXCEPT -- 헬멧을 주문한 고객 제거.
SELECT c.customerid , c.custfirstname , c.custlastname 
FROM orders o 
JOIN customers c ON o.customerid = c.customerid 
JOIN order_details od ON o.ordernumber = od.ordernumber 
JOIN products p ON od.productnumber = p.productnumber 
WHERE p.productname LIKE '%Helmet' ;

문제3번)  모든 제품 과 주문 일자를 나열하세요. (주문되지 않은 제품도 포함해서 보여주세요.)

-- OUTER JOIN(주문되지 않은 제품 NULL)
-- 모든제품 기준
SELECT od.ordernumber , p.productnumber , p.productname , o.orderdate 
FROM products p 
LEFT OUTER JOIN order_details od ON p.productnumber = od.productnumber -- ORDER NUMBER NULL인 상품도 포함.
LEFT OUTER JOIN orders o ON od.ordernumber = o.ordernumber ; -- db로 묶지 않아도 같은 결과.

-- 주문 일자는 orders 테이블에 있다. > join 수행.

SELECT DB.ordernumber, DB.productnumber , DB.productname, o.orderdate 
FROM (SELECT od.ordernumber , p.productnumber , p.productname 
		FROM products p 
		LEFT OUTER JOIN order_details od ON p.productnumber = od.productnumber) AS DB
LEFT OUTER JOIN orders o ON DB.ordernumber = o.ordernumber ;



문제4번) 대여점(store)별 영화 재고(inventory) 수량과 전체 영화 재고 수량은? (union all)

-- 대여점 별 영화재고
SELECT *
FROM product_vendors pv ;
SELECT *
FROM products p ;
SELECT * FROM vendors v ;

-- PRODUCT_VENDERS 기준으로  VENDERS와 PRODUCTS를 JOIN한 테이블
SELECT pv.vendorid , v.vendname , SUM(p.quantityonhand) AS QUANTITY_SUM
FROM product_vendors pv 
JOIN vendors v ON pv.vendorid = v.vendorid 
JOIN products p ON pv.productnumber = p.productnumber
GROUP BY pv.vendorid, v.vendname
UNION ALL
-- 전체 영화 재고
 SELECT NULL , NULL , SUM(p.quantityonhand) AS QUANTITY_SUM 
FROM product_vendors pv 
JOIN vendors v ON pv.vendorid = v.vendorid 
JOIN products p ON pv.productnumber = p.productnumber ;


문제5번) 타이어과 헬멧을 모두 산적이 있는 고객의 ID 를 알려주세요.
- 타이어와 헬멧에 대해서는 , Products 테이블의 productname 컬럼을 이용해서 확인해주세요.

-- 타이어를 구매한 고객 ID
SELECT c.customerid -- , c.custfirstname , c.custlastname 
FROM orders o 
JOIN customers c ON o.customerid = c.customerid 
JOIN order_details od ON o.ordernumber = od.ordernumber 
JOIN products p ON od.productnumber = p.productnumber 
WHERE p.productname LIKE '%Tires'
intersect 
-- 헬맷을 구매한 고객 ID INTERSECT
SELECT c.customerid -- , c.custfirstname , c.custlastname
FROM orders o 
JOIN customers c ON o.customerid = c.customerid 
JOIN order_details od ON o.ordernumber = od.ordernumber 
JOIN products p ON od.productnumber = p.productnumber 
WHERE p.productname LIKE '%Helmet' 
ORDER BY customerid ;






