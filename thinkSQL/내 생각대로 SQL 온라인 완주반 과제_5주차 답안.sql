문제1번) 주문일자가 2017/09/01 ~ 2017/12/31 일에 해당하는 주문 중에서 , 
           주문 월별로 , 가장 판매가 많았던 상품 (productname) Top 5 개를 보여주세요. 

select db2.monthly , db2.productname , db2.ranking        
from (
	select db.monthly , db.productname , row_number() over(partition by db.monthly order by db.cnt desc) as ranking
	from (
		select p.productnumber , p.productname , to_char(o.orderdate, 'mm') as monthly ,
			count(o.ordernumber) as cnt
		from orders o 
		join order_details od on o.ordernumber = od.ordernumber
		join products p on od.productnumber = p.productnumber 
		where o.orderdate between to_date('2017-09-01', 'yyyy-mm-dd') and to_date('2017-12-31', 'yyyy-mm-dd') 
		group by grouping sets ( (to_char(o.orderdate, 'mm'), p.productnumber) )
		) as db ) as db2
where db2.ranking <= 5 ;


문제2번) 주문일자가 2017/09/01 ~ 2017/12/31 일에 해당하는 주문 중에서 , 주문 월별로 , 결제 금액이 높은 고객 Top 3명을 보여주세요. 주문 월별로, 고객 3명을 알려주시고 / 고객의 Full name 을 함께 보여주세요. 

select db2.monthly , c.custfirstname ||' '|| c.custlastname as fullname , db2.payment , db2.ranking
from (
	select db.monthly , db.customerid , db.payment, row_number() over(partition by db.monthly order by db.payment desc) as ranking
	from (
		select to_char(o.orderdate, 'mm') as monthly ,
			o.customerid , sum(od.quotedprice * od.quantityordered) as payment 
		from orders o 
		join order_details od on o.ordernumber = od.ordernumber
		where o.orderdate between to_date('2017-09-01', 'yyyy-mm-dd') and to_date('2017-12-31', 'yyyy-mm-dd') 
		group by grouping sets((to_char(o.orderdate, 'mm'), o.customerid)) ) as db ) as db2
join customers c on db2.customerid = c.customerid 
where db2.ranking <= 3 ;

문제3번) 주문일자가 2017/09/01 ~ 2017/12/31 일에 해당하는 주문 중에서 , 주문 월별로 , 결제 금액이 높은 고객 Top 3에 2번 이상 포함된 적이 있는 고객의 이름과 Top3에 포함된 횟수를 알려주세요. 

 
with tb as (
	select db2.monthly , c.custfirstname ||' '|| c.custlastname as fullname , db2.payment , db2.ranking
	from (
		select db.monthly , db.customerid , db.payment, row_number() over(partition by db.monthly order by db.payment desc) as ranking
		from (
			select to_char(o.orderdate, 'mm') as monthly ,
				o.customerid , sum(od.quotedprice * od.quantityordered) as payment 
			from orders o 
			join order_details od on o.ordernumber = od.ordernumber
			where o.orderdate between to_date('2017-09-01', 'yyyy-mm-dd') and to_date('2017-12-31', 'yyyy-mm-dd') 
			group by grouping sets((to_char(o.orderdate, 'mm'), o.customerid)) ) as db ) as db2
	join customers c on db2.customerid = c.customerid 
	where db2.ranking <= 3 )
select tb.fullname , count(tb.fullname) as cnt
from tb
group by tb.fullname 
having count(tb.fullname) >= 2 ;


문제4번) 상품 번호를 기준으로, 범위를 지정하여, 상품번호 그룹을 만들려고합니다. 각 상품 번호 그룹 별로, 주문 수를 알려주세요.


상품번호번호에 그룹은 아래와 같습니다. 
 - 상품번호가 1~ 10에 해당하면 between1_10  
 - 상품번호가 11~20에 해당하면 between11_20  
 - 상품번호가 21~30에 해당하면 between21_30 
 - 상품번호가 31~40에 해당하면 between31_40

 
with tb as (
	select 1 ck1 , 10 ck2 , 'between1_10' flag union all
	select 11 ck1 , 20 ck2 , 'between11_20' flag union all
	select 21 ck1 , 30 ck2 , 'between21_30' flag union all
	select 31 ck1 , 40 ck2 , 'between31_40' flag )
select tb.flag as productgroup , count(od.ordernumber) as cnt
from order_details od 
inner join tb on od.productnumber between tb.ck1 and tb.ck2 
group by tb.flag 
order by tb.flag ;




문제5번) 타이어(Tires)  카테고리에 해당하는 2017/09/01 ~ 2017/09/10일에 주문 중, 주문 일자별 타이어 카테고리별 주문 수를 확인하고. 
추가로 타이어 카테고리가 이전 주문일자의 주문 수를 노출하고, 이전 주문일자와 현 주문일자를 비교해주세요.  (with 절 활용)


주문 수 비교에 대한 컬럼의 구성은 아래와 같습니다. 
 - 이전 주문일자보다 주문 수가 늘었다면 plus 
 - 이전 주문일자와 주문 수가 동일하다면 same 
 - 이전 주문일자보다 주문 수가 줄었다면 minus

 카테고리 6 = Tier

 
with tb as (
	select o.orderdate , count(od.ordernumber) as cnt
	from orders o 
	join order_details od on o.ordernumber = od.ordernumber
	join products p on od.productnumber = p.productnumber 
	where o.orderdate between to_date('2017-09-01', 'yyyy-mm-dd') and to_date('2017-09-10', 'yyyy-mm-dd') 
	and p.categoryid = 6
	group by o.orderdate )
select tb.* , lag(tb.cnt, 1) over(order by tb.orderdate) as later_cnt , 
	case when lag(tb.cnt, 1) over(order by tb.orderdate) < tb.cnt then 'plus'
		 when lag(tb.cnt, 1) over(order by tb.orderdate) = tb.cnt then 'same'
		 when lag(tb.cnt, 1) over(order by tb.orderdate) > tb.cnt then 'minus'
		 else null 
		 end as flag
from tb ;

select *
from categories c ;
