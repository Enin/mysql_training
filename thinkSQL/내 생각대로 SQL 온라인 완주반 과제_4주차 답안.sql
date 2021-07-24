문제1번)  상품별 주문 수 와 전체 주문수를 함께 보여주세요.

SELECT od.productnumber , count(ordernumber) as cnt
FROM order_details od 
group by grouping sets( (od.productnumber), () ) 
order by productnumber ;


문제2번)  상품 이름과 카테고리별 전체 매출액을 알려주세요. 또한, 카테고리별 전체 매출액 도 함께 알려주세요.

-- 상품이름, 상품 매출액에 대한 서브쿼리

select db.categoryid, sum(db.saleprice) as sum_sale
from (
	select p.categoryid , od.quotedprice * od.quantityordered as saleprice
	from products p 
	join order_details od on p.productnumber = od.productnumber ) as db
group by db.categoryid ;

with cs as (
	select p.categoryid , sum(od.quotedprice * od.quantityordered) as saleprice
	from products p 
	join order_details od on p.productnumber = od.productnumber
	group by p.categoryid )
select p2.productname , p2.categoryid , cs.saleprice
from products p2 
join cs on p2.categoryid = cs.categoryid 
union all 
select NULL, cs.categoryid, cs.saleprice
from cs 
order by categoryid , productname ;


문제3번) 자전거 카테고리 주문 량이 매달 증가하고 있나요? (2017년 1월 ~ 12월 까지 판매량만 확인하시면 됩니다.)
월별 주문량을 이전 달 주문량과 함께 표기해 증가 여부를 알려주세요. (analytic function 활용)


	Hint 아래의 표기 값으로 산출 해주세요. 
	1) 전 달 보다 값이 크다면 PLUS
	2) 이전 달의 값이 현재 값 보다 크다면 MINUS
	3) 현재 달의 판매 량과 이전 달 값이 같다면 SAME
	4) 이 외의 Case ? NULL

select *
from orders o ;

select *
from categories c ; -- bikes : 2번

select tb.monthly , tb.order_cnt, lag(tb.order_cnt, 1) over(order by monthly) as pre_month_order_cnt ,
	case when lag(tb.order_cnt, 1) over(order by monthly) < tb.order_cnt then 'PLUS'
		 when lag(tb.order_cnt, 1) over(order by monthly) > tb.order_cnt then 'MINUS'
		 when lag(tb.order_cnt, 1) over(order by monthly) = tb.order_cnt then 'SAME'
		 else NULL
		 end as cases
from (
	select to_char(o.orderdate, 'yyyy-mm') as monthly , count(od.ordernumber) as order_cnt 
	from order_details od 
	join products p on od.productnumber = p.productnumber 
	join orders o on od.ordernumber = o.ordernumber 
	where p.categoryid = 2 and o.orderdate < cast('2018-01-01' as timestamp)
	group by to_char(o.orderdate, 'yyyy-mm') ) as tb


문제4번) 제품 카테고리, 주(state) 기준으로 보유한 물량을 보여주고, 주(state) 전체 보유물량도 함께 나열하세요. (analytic function 활용)

 
select p.categoryid , v.vendstate , count(p.productnumber * p.quantityonhand) as cnt 
from products p 
join product_vendors pv on p.productnumber = pv.productnumber 
join vendors v on pv.vendorid = v.vendorid 
group by grouping sets ( (p.categoryid, v.vendstate), (v.vendstate) ) 
order by v.vendstate ;


문제5번)  주문일자가 2017/09/01 ~ 2017/12/31 일에 해당하는 주문 에 대해서,  월별 고객별 결제 금액을 기준으로 결제 금액에 대한 flag 를 함께 보여주세요. 
flag 는 아래와 같습니다.

- 고객의 결제금액이 10000 달러 아래에 경우 under1000
- 고객의 결제금액이 10001 ~ 100000 에 해당하는 경우 under100000 
- 고객의 결제금액이 100001 ~ 500000에 해당하는 경우 under500000
- 고객의 결제금액이 500001 이상인 경우 over500000


with tb as ( 
	select 0 ck1 , 10000 ck2 ,  'under10000' flag union all 
	select 10000 ck1 , 100000 ck2 ,  'under100000' flag union all 
	select 100001 ck1 , 500000 ck2 ,  'under500000' flag union all 
	select 500001 ck1 , 9999999999 ck2 ,  'over500000' flag )
select db.* , tb.flag
from (
	select o.orderdate , o.customerid , sum(od.quotedprice*od.quantityordered) as payment
	from orders o 
	join order_details od on o.ordernumber = od.ordernumber 
	where o.orderdate >= to_date('2017-09-01', 'yyyy-mm-dd') and o.orderdate <= to_date('2017-12-31', 'yyyy-mm-dd')
	group by grouping sets ( (o.orderdate, o.customerid) )  ) as db
left outer join tb on db.payment between tb.ck1 and tb.ck2
order by orderdate , customerid ;



퀴즈1번

select pv.vendorid , avg(pv.daystodeliver) over() as avgs
from products p 
join product_vendors pv on p.productnumber = pv.productnumber 
where pv.vendorid = 7 

퀴즈2번

select count(ordernumber)
from orders o 
where employeeid = 701 ;

퀴즈3번
