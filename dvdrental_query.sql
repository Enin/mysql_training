-- select �ǽ�
select *
from customer;

select A.first_name, A.last_name, A.email
from customer A;

select a.first_name, a.last_name, a.email
from customer
order by a.first_name desc ; -- ������ �÷��� �������� ��������/�������� �����Ѵ�.

select first_name, last_name
from customer
order by first_name, last_name desc;

select first_name, last_name
from customer
order by 1, 2 desc; -- ���� ������� ���ڷ� �÷��� ������ �� �� ����.


-- select distinct �ߺ����� �ɼ�
select distinct bcolor -- �ش� �÷��� �ߺ����� ������� �ߺ��� ����. null �� ǥ�õ�.
from t1
order by bcolor ;

select distinct on (bcolor) bcolor, fcolor -- on(�÷�) �������� ���ŵ� ���� ���������� �ȴ�.
from t1
order by bcolor, fcolor  ; -- �÷� 2�� �̻� ������ on(�÷�)�� ���


select last_name, first_name
from customer
where first_name = 'Jamie'; -- where <����> �� �����ϴ� �÷��� ���.

SELECT last_name, first_name
FROM customer
WHERE first_name = 'Jamie' -- where <����> �� �����ϴ� �÷��� ���.
AND last_name = 'Rice'; -- AND, OR ���� ����Ͽ� ������ �߰��� �� ����.

SELECT CUSTOMER_ID, AMOUNT, PAYMENT_DATE
FROM PAYMENT 
WHERE AMOUNT <= 1 OR AMOUNT >= 8 ;	-- AMOUNT�� 1���� �Ǵ� 8�̻��� ���� ���.
