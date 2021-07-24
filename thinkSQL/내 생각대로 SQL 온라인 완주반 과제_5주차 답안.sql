����1��) �ֹ����ڰ� 2017/09/01 ~ 2017/12/31 �Ͽ� �ش��ϴ� �ֹ� �߿��� , 
           �ֹ� ������ , ���� �ǸŰ� ���Ҵ� ��ǰ (productname) Top 5 ���� �����ּ���. 

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


����2��) �ֹ����ڰ� 2017/09/01 ~ 2017/12/31 �Ͽ� �ش��ϴ� �ֹ� �߿��� , �ֹ� ������ , ���� �ݾ��� ���� �� Top 3���� �����ּ���. �ֹ� ������, �� 3���� �˷��ֽð� / ���� Full name �� �Բ� �����ּ���. 

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

����3��) �ֹ����ڰ� 2017/09/01 ~ 2017/12/31 �Ͽ� �ش��ϴ� �ֹ� �߿��� , �ֹ� ������ , ���� �ݾ��� ���� �� Top 3�� 2�� �̻� ���Ե� ���� �ִ� ���� �̸��� Top3�� ���Ե� Ƚ���� �˷��ּ���. 

 
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


����4��) ��ǰ ��ȣ�� ��������, ������ �����Ͽ�, ��ǰ��ȣ �׷��� ��������մϴ�. �� ��ǰ ��ȣ �׷� ����, �ֹ� ���� �˷��ּ���.


��ǰ��ȣ��ȣ�� �׷��� �Ʒ��� �����ϴ�. 
 - ��ǰ��ȣ�� 1~ 10�� �ش��ϸ� between1_10  
 - ��ǰ��ȣ�� 11~20�� �ش��ϸ� between11_20  
 - ��ǰ��ȣ�� 21~30�� �ش��ϸ� between21_30 
 - ��ǰ��ȣ�� 31~40�� �ش��ϸ� between31_40

 
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




����5��) Ÿ�̾�(Tires)  ī�װ��� �ش��ϴ� 2017/09/01 ~ 2017/09/10�Ͽ� �ֹ� ��, �ֹ� ���ں� Ÿ�̾� ī�װ��� �ֹ� ���� Ȯ���ϰ�. 
�߰��� Ÿ�̾� ī�װ��� ���� �ֹ������� �ֹ� ���� �����ϰ�, ���� �ֹ����ڿ� �� �ֹ����ڸ� �����ּ���.  (with �� Ȱ��)


�ֹ� �� �񱳿� ���� �÷��� ������ �Ʒ��� �����ϴ�. 
 - ���� �ֹ����ں��� �ֹ� ���� �þ��ٸ� plus 
 - ���� �ֹ����ڿ� �ֹ� ���� �����ϴٸ� same 
 - ���� �ֹ����ں��� �ֹ� ���� �پ��ٸ� minus

 ī�װ� 6 = Tier

 
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
