use world;

# 시티 테이블에서 모두 선택한 다음, join을 사용하여 country, countrylanguage를 합친다.
select * 
from city
join country on city.countrycode = country.code
join countrylanguage on city.countrycode = countrylanguage.countrycode;

# city.name, country.serficearea, city.population, countrylanguage.language 를 갖는 뷰 생성.
create view allview as
select city.name, country.surfacearea, city.population, countrylanguage.language
from city
join country on city.countrycode = country.code
join countrylanguage on city.countrycode = countrylanguage.countrycode
where city.countrycode = 'kor';

select * from allview;

use keeh;

insert into test
value(1, 123, 1.1, 'test');

select * from test;

insert into test2
select *
from test;

select * from test2;

update test
set col1=1, col2=0.1, col3='hello'
where id=1;

select * from test;

delete from test
where id=1;

select * from test; 

drop table test;

drop database keeh;
