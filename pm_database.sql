CREATE DATABASE pm_dataset;

use pm_dataset;

# 테이블 생성
CREATE TABLE pmdatabase(	
	days DATE NULL,
    pm_seoul FLOAT NULL,
    pm_beijing FLOAT NULL,
    avg_temprature FLOAT NULL,
    avg_humidity FLOAT NULL,
    avg_wind_speed_seoul FLOAT NULL,
    max_wind_direction_seoul INT NULL,
    avg_wind_speed_westsea FLOAT NULL,
	avg_wind_direction_westsea INT NULL	);

# secure 파일 경로를 확인. 5.1.17 버전부터 해당 경로를 통해서만 파일 입출력이 가능.
# 경로 변경을 하고 싶으면 mysql 설정파일 my.ini 파일을 수정.    
show variables
like 'secure_file%';

CREATE TABLE pmdatabase2(	
	days DATE NULL,
    pm_seoul FLOAT NULL,
    pm_beijing FLOAT NULL,
    avg_temprature FLOAT NULL,
    avg_humidity FLOAT NULL,
    avg_wind_speed_seoul FLOAT NULL,
    max_wind_direction_seoul INT NULL,
    avg_wind_speed_westsea FLOAT NULL,
	avg_wind_direction_westsea INT NULL	);
# CSV 파일 경로 식별
LOAD DATA
INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/pm.csv'
INTO TABLE pmdatabase2
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 ROWS;

select *
from pmdatabase;
show table status;
describe pmdatabase;

# days를 프라임 키로 세팅
alter table pmdatabase
add primary key(days);

# 지역 테이블, pm 테이블, 풍향테이블, 풍속테이블, 온습도 테이블 생성
create table loaction (
	country varchar(10) not null primary key,
    city varchar(10) null );
    
create table pmdb (
	day date not null primary key,
    country varchar(10) null,
    city varchar(10) null,
    pm float null,
    temprature float null,
    windspeed float null,
    winddegree int null	);

# 서울 테이블 생성
create table seoul (
	day date null,
	country varchar(10) null,
    city varchar(10) null,
    pm float null,
	temprature float null,
    humidity float null,
    windspeed float null,
	winddegree int null	);
    
create table westsea (
	day date null,
	country varchar(10) null,
    city varchar(10) null,
    windspeed float null,
	winddegree int null	);

create table beijing (
	day date null,
	country varchar(10) null,
    city varchar(10) null,
    pm float null ) ;
    
drop table westsea;
drop table beijing;
select * from beijing2;

alter table beijing modify pm FLOAT;
alter table beijing
drop pm2;

LOAD DATA
INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/beijing.csv'
INTO TABLE beijing2
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 ROWS;

# 서울 테이블 가져오기
insert into seoul (day, pm, temprature, humidity, windspeed, winddegree)
select days, pm_seoul, avg_temprature, avg_humidity, avg_wind_speed_seoul, max_wind_direction_seoul
from pmdatabase;

# 프로시저 (함수) 선언. 반복문 같은 기능 사용 시 프로시저로 함수화하여 호출.
drop procedure if exists auto_input;
DELIMITER $$
CREATE PROCEDURE auto_input()
begin
	# declare str varchar(10) default 'korea';	# 변수 선언하기
    declare day_len int;
    declare i int;
    select count(days) into day_len from pmdatabase; # into i 로 days를 샌 갯수를 i에 넣어줌
    set i = 1;
    while (i < day_len) do
		insert into seoul (country, city) order by desc
        select country, city
        from location
        where 
    
    
    while i do
		
end $$
DELIMITER ;

select count(days) from pmdatabase;

select * from seoul;

# 위치 테이블
create table location (
	country varchar(10) null,
    city varchar(10) null );

select * from location;

insert into location
values ('seoul', 'korea'), ('westsea', 'korea'), ('beijing', 'china');

insert into seoul (country, city)
select country, city
from location
where city = ( select city from location where city = 'seoul');




