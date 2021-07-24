����1��)  ��ǰ�� �ֹ� �� �� ��ü �ֹ����� �Բ� �����ּ���.

SELECT od.productnumber , count(ordernumber) as cnt
FROM order_details od 
group by grouping sets( (od.productnumber), () ) 
order by productnumber ;


����2��)  ��ǰ �̸��� ī�װ��� ��ü ������� �˷��ּ���. ����, ī�װ��� ��ü ����� �� �Բ� �˷��ּ���.

-- ��ǰ�̸�, ��ǰ ����׿� ���� ��������

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


����3��) ������ ī�װ� �ֹ� ���� �Ŵ� �����ϰ� �ֳ���? (2017�� 1�� ~ 12�� ���� �Ǹŷ��� Ȯ���Ͻø� �˴ϴ�.)
���� �ֹ����� ���� �� �ֹ����� �Բ� ǥ���� ���� ���θ� �˷��ּ���. (analytic function Ȱ��)


	Hint �Ʒ��� ǥ�� ������ ���� ���ּ���. 
	1) �� �� ���� ���� ũ�ٸ� PLUS
	2) ���� ���� ���� ���� �� ���� ũ�ٸ� MINUS
	3) ���� ���� �Ǹ� ���� ���� �� ���� ���ٸ� SAME
	4) �� ���� Case ? NULL

select *
from orders o ;

select *
from categories c ; -- bikes : 2��

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


����4��) ��ǰ ī�װ�, ��(state) �������� ������ ������ �����ְ�, ��(state) ��ü ���������� �Բ� �����ϼ���. (analytic function Ȱ��)

 
select p.categoryid , v.vendstate , count(p.productnumber * p.quantityonhand) as cnt 
from products p 
join product_vendors pv on p.productnumber = pv.productnumber 
join vendors v on pv.vendorid = v.vendorid 
group by grouping sets ( (p.categoryid, v.vendstate), (v.vendstate) ) 
order by v.vendstate ;


����5��)  �ֹ����ڰ� 2017/09/01 ~ 2017/12/31 �Ͽ� �ش��ϴ� �ֹ� �� ���ؼ�,  ���� ���� ���� �ݾ��� �������� ���� �ݾ׿� ���� flag �� �Բ� �����ּ���. 
flag �� �Ʒ��� �����ϴ�.

- ���� �����ݾ��� 10000 �޷� �Ʒ��� ��� under1000
- ���� �����ݾ��� 10001 ~ 100000 �� �ش��ϴ� ��� under100000 
- ���� �����ݾ��� 100001 ~ 500000�� �ش��ϴ� ��� under500000
- ���� �����ݾ��� 500001 �̻��� ��� over500000


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



����1��

select pv.vendorid , avg(pv.daystodeliver) over() as avgs
from products p 
join product_vendors pv on p.productnumber = pv.productnumber 
where pv.vendorid = 7 

����2��

select count(ordernumber)
from orders o 
where employeeid = 701 ;

����3��
