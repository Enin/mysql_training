
문제1번) dvd 렌탈 업체의  dvd 대여가 있었던 날짜를 확인해주세요. 풀이

SELECT * FROM RENTAL;

SELECT r.rental_date -- 렌탈 날짜만 가져온다.
FROM rental r; -- 대여 정보를 가진 rental 테이블을 선택하고 

SELECT DISTINCT DATE(RENTAL_DATE) -- 중복제거 하여 날짜 중복 제거.
FROM RENTAL;

문제2번) 영화길이가 120분 이상이면서, 대여기간이 4일 이상이 가능한, 영화제목을 알려주세요.	

SELECT * FROM film f ;
SELECT title
FROM film f 
WHERE length >= 120 and
	rental_duration >= 4;

문제3번) 직원의 id 가 2 번인  직원의  id, 이름, 성을 알려주세요	

SELECT * FROM staff s ;
SELECT staff_id, first_name, last_name
FROM staff s 
WHERE staff_id = 2;

문제4번) 지불 내역 중에서,   지불 내역 번호가 17510 에 해당하는  ,  고객의 지출 내역 (amount ) 는 얼마인가요?	

SELECT * FROM payment p ;

SELECT amount
FROM payment p 
WHERE payment_id = 17510 ;

문제5번) 영화 카테고리 중에서 ,Sci-Fi  카테고리의  카테고리 번호는 몇번인가요?	풀이

SELECT * FROM category c; -- 14번 SCI-FI 카테고리 번호를 확인하였음.

SELECT category_id -- 카테고리 아이디만 출력.
FROM category c 
WHERE NAME = 'Sci-Fi'; -- where절로 sci-fi라는 이름만 갖는 튜플 탐색.


문제6번) film 테이블을 활용하여, rating  등급(?) 에 대해서, 몇개의 등급이 있는지 확인해보세요. 	풀이.

SELECT * FROM film f ;
SELECT COUNT(*) FROM film f ; -- FILM 테이블의 전체 튜플수.

SELECT DISTINCT rating
FROM film f ; -- 등급에 대해서 중복제거하여 총 5개가 있다는 것을 확인.
/*
PG-13
NC-17
G
PG
R
*/

-- 숫자 5만 나오게 하려면 어떻게??		
SELECT COUNT(DISTINCT rating) -- 카운트 안에 중복제거 컬럼명을 넣어주면 됨.
FROM film f;


문제7번) 대여 기간이 (회수 - 대여일) 10일 이상이였던 rental 테이블에 대한 모든 정보를 알려주세요.
단 , 대여기간은  대여일자부터 대여기간으로 포함하여 계산합니다.	 풀이

SELECT *
from rental r ;

SELECT DATE(rental_date), 
		DATE(return_date), 
		DATE(return_date) - DATE(rental_date) + 1 as chk
FROM rental r 
where DATE(return_date) - DATE(rental_date) + 1 >= 10 ; -- where 문은 지정하고 싶으 컬럼에 대해서 조건을 넣을 수 있음.

SELECT DATE(return_date) - DATE(rental_date) + 1 as chk -- as 임시컬럼명 으로 나타낼 컬럼명 지정 가능.
FROM rental r 
where DATE(return_date) - DATE(rental_date) + 1 >= 10 ; -- where 컬럼에 대해서 조건을 통과하는 값만 얻음.


문제8번) 고객의 id 가  50,100,150 ..등 50번의 배수에 해당하는 고객들에 대해서, 
회원 가입 감사 이벤트를 진행하려고합니다.
고객 아이디가 50번 배수인 아이디와, 고객의 이름 (성, 이름)과 이메일에 대해서 
확인해주세요.	풀이.

SELECT * FROM customer c ;
SELECT customer_id, 
		last_name, 
		first_name,
		last_name ||','|| first_name as full_name, -- ||''|| 를 사용하여 구문에 문자를 추가할 수 있고 두 컬럼을 합칠 수 있음.
		email
		--MOD(customer_id, 50) as MOD_50 -- mod() 는 데이터에 나눴을때 나머지는 구하는 값.
FROM customer c  
WHERE MOD(customer_id, 50) = 0 ;  -- mod() 는 데이터에 나눴을때 나머지는 구하는 값.



문제9번) 영화 제목의 길이가 8글자인, 영화 제목 리스트를 나열해주세요.	

SELECT * FROM film f ;
SELECT title
FROM film f 
WHERE length(title) > 8 ;

문제10번)	city 테이블의 city 갯수는 몇개인가요?	풀이

SELECT * FROM city ;

-- 풀이1
SELECT count(city_id)
FROM city c ;
-- 풀이2
SELECT city_id
FROM city c 
ORDER BY city DESC;
-- 풀이3
SELECT max(city_id)
from city;
-- 풀이4
SELECT count(DISTINCT city) -- city의 중복값을 제거한 후 숫자를 센다. 정확하게 봐야할 컬럼의 수를 세는것.
from city; -- city_id 컬럼의 중복이 있을 수도 있다. 이 정보를 확인하기 위해 선호.


문제11번)	영화배우의 이름 (이름+' '+성) 에 대해서,  대문자로 이름을 보여주세요.  단 고객(?)의 이름이 동일한 사람이 있다면,  중복 제거하고, 알려주세요.	풀이.

SELECT * FROM actor a ;
-- 이름의 중복제거
-- 이름합치기
-- 이름을 대문자로 
SELECT DISTINCT UPPER(first_name ||' '|| last_name) as full_name -- UPPER, LOWER 함수를 넣어서 전체 대문자/전체소문자로 변경. 
FROM actor a ;


문제12번)	고객 중에서,  active 상태가 0 인 즉 현재 사용하지 않고 있는 고객의 수를 알려주세요.	

SELECT * FROM customer c ;
SELECT count(customer_id)
FROM customer c 
where active = 0 ;

문제13번)	Customer 테이블을 활용하여,  store_id = 1 에 매핑된  고객의 수는 몇명인지 확인해보세요.	

SELECT * FROM customer c ;

SELECT count(DISTINCT customer_id)
FROM customer c 
WHERE store_id = 1;

문제14번)	rental 테이블을 활용하여,  고객이 return 했던 날짜가 2005년6월20일에 해당했던 rental 의 갯수가 몇개였는지 확인해보세요.	

SELECT * FROM rental r ;

SELECT count(rental_id)
FROM rental r 
WHERE DATE(return_date) = DATE('2005-06-20') ;

문제15번)	film 테이블을 활용하여, 2006년에 출시가 되고 rating 이 'G' 등급에 해당하며, 대여기간이 3일에 해당하는  것에 대한 film 테이블의 모든 컬럼을 알려주세요.	

SELECT *
FROM film f
WHERE release_year = 2006 and rating = 'G' and rental_duration = 3 ;

문제16번)	langugage 테이블에 있는 id, name 컬럼을 확인해보세요 . 	

SELECT language_id, name FROM "language" l ;

문제17번)	film 테이블을 활용하여,  rental_duration 이  7일 이상 대여가 가능한  film 에 대해서  film_id,   title,  description 컬럼을 확인해보세요.	풀이
-- 질문에서 필요한 내용들이 모두 있으며 쿼리문으로 표현만 하면 됨.
SELECT * FROM film f ;

SELECT film_id, title, description
FROM film f 
WHERE rental_duration >= 7 ; -- > < = != 등등.

문제18번)	film 테이블을 활용하여,  rental_duration   대여가 가능한 일자가 3일 또는 5일에 해당하는  film_id,  title, desciption 을 확인해주세요.	

SELECT film_id, title, description
FROM film f 
WHERE rental_duration = 3 or rental_duration = 5 ;

문제19번)	Actor 테이블을 이용하여,  이름이 Nick 이거나  성이 Hunt 인  배우의  id 와  이름, 성을 확인해주세요.

SELECT actor_id , first_name , last_name 
FROM actor a 
WHERE first_name = 'Nick' or last_name = 'Hunt' ;

문제20번)	Actor 테이블을 이용하여, Actor 테이블의  first_name 컬럼과 last_name 컬럼을 , firstname, lastname 으로 컬럼명을 바꿔서 보여주세요	

SELECT first_name as firstname ,
		last_name as lastname 
FROM actor a ;

