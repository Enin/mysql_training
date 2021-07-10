문제1번)  각 제품 가격을 5 % 줄이면 어떻게 될까요?

SELECT retailprice * 0.95 AS retailprice 
FROM products p ;

문제2번) orders 테이블을 활용하여, 고객번호가 1001 에 해당하는 사람이 employeeid 가 707인 직원으로부터  산 주문의 id 와 주문 날짜를 알려주세요.  
         * 주문일자가 오름차순으로 정렬하여, 보여주세요.

SELECT ordernumber 
	, orderdate 
FROM orders o
WHERE employeeid = 707
AND customerid =1001
ORDER BY orderdate ASC ;

문제3번)  vendors 테이블을 이용하여, 벤더가 위치한 state 주가 어떻게 되는지, 확인해보세요.  중복된 주가 있다면, 중복제거 후에 알려주세요. 

SELECT DISTINCT vendstate 
FROM vendors v ;


문제4번) products 테이블을 활용하여, productdescription에 상품 상세 설명 값이 없는  상품 데이터를 모두 알려주세요.

SELECT *
FROM products p
WHERE productdescription IS NULL ;


문제5번)  customers 테이블을 이용하여, 고객의 id 별로,  custstate 지역 중 WA 지역에 사는 사람과  WA 가 아닌 지역에 사는 사람을 구분해서  보여주세요.
 - customerid 와,  newstate_flag 컬럼으로 구성해주세요 .
 - newstate_flag 컬럼은 WA 와 OTHERS 로  노출해주시면 됩니다.

SELECT customerid ,
	CASE WHEN custstate = 'WA' THEN 'WA'
		 ELSE 'OTHERS'
	END AS newstate_flag
FROM customers c ;


1. employees 테이블을 이용하여, 705 아이디를 갖은 직원의 이름과, 태어난 해를 알려주세요.

SELECT empfirstname , empbirthdate 
FROM employees e  
WHERE employeeid = 705;

3. 2017-09-02~ 09-03일 사이에 주문을 한, 주문번호의 갯수는 총 몇개인가요?

SELECT COUNT(*)
FROM orders o 
WHERE orderdate between '2017-09-02' AND '2017-09-03';

5. vendor의 State 지역이 NY 또는 WA 인 업체 의 갯수가 어떻게 되나요? (vendors 테이블을 이용 하여 알려주세요)

SELECT COUNT(*)
FROM vendors v 
WHERE vendstate IN ('NY', 'WA') ;

select *
FROM vendors v 
WHERE vendstate IN ('NY', 'WA') ;



