문제1번) dvd 대여를 제일 많이한 고객 이름은?   (with 문 활용)	

문제2번) 영화 시간 유형 (length_type)에 대한 영화 수를 구하세요.
영화 상영 시간 유형의 정의는 다음과 같습니다.
영화 길이 (length) 은 60분 이하 short , 61분 이상 120분 이하 middle , 121 분이상 long 으로 한다. 풀이

WITH TB1 AS(
	SELECT 0 AS CHK1, 60 AS CHK2, 'SHORT' AS LENGTH_FLAG
	UNION ALL
	SELECT 61 AS CHK1, 120 AS CHK2, 'MIDDLE' AS LENGTH_FLAG
	UNION ALL
	SELECT 121 AS CHK1, 999 AS CHK2, 'LONG' AS LENGTH_FLAG
)
SELECT length_flag, count(film_id) as cnt
FROM (
SELECT f.film_id , f.length , tb1.length_flag
FROM film f 
LEFT OUTER JOIN TB1 ON f.length BETWEEN TB1.CHK1 AND TB1.CHK2 ) AS DB -- 조인할때 F.LENGTH가 CHK1 ~ CHK2 사이에 있는지 확인
GROUP BY length_flag ;


문제3번) 약어로 표현되어 있는 영화등급(rating) 을 영문명, 한글명과 같이 표현해 주세요. (with 문 활용) 풀이

G        ? General Audiences (모든 연령대 시청가능)
PG      ? Parental Guidance Suggested. (모든 연령대 시청가능하나, 부모의 지도가 필요)
PG-13 ? Parents Strongly Cautioned (13세 미만의 아동에게 부적절 할 수 있으며, 부모의 주의를 요함)
R         ? Restricted. (17세 또는 그이상의 성인)
NC-17 ? No One 17 and Under Admitted.  (17세 이하 시청 불가)	

WITH TB1 AS ( 
	SELECT 'G' AS RATING, 'General Audiences' AS ENG_TEXT, '(모든 연령대 시청가능)' AS KR_TEXT UNION ALL
	SELECT 'PG' AS RATING, 'Parental Guidance Suggested' AS ENG_TEXT, '(모든 연령대 시청가능하나, 부모의 지도가 필요)' AS KR_TEXT UNION ALL
	SELECT 'PG-13' AS RATING, 'Parents Strongly Cautioned' AS ENG_TEXT, '(13세 미만의 아동에게 부적절 할 수 있으며, 부모의 주의를 요함)' AS KR_TEXT UNION ALL
	SELECT 'R' AS RATING, 'Restricted' AS ENG_TEXT, '(17세 또는 그이상의 성인)' AS KR_TEXT UNION ALL
	SELECT 'NC-17' AS RATING, 'No One 17 and Under Admitted' AS ENG_TEXT, '(17세 이하 시청 불가)' AS KR_TEXT )
SELECT *
FROM film f 
LEFT OUTER JOIN TB1 ON CAST(f.rating as varchar) = TB1.rating ; -- CAST 함수로 f.rating 의 타입을 varchar로 변경


문제4번) 고객 등급별 고객 수를 구하세요. (대여 횟수에 따라 고객 등급을 나누고 조건은 아래와 같습니다.)

A 등급은 31회 이상
B 등급은 21회 이상 30회 이하 
C 등급은 11회 이상 20회 이하
D 등급은 10회 이하

문제5번) 고객 이름 별로 , flag  를 붙여서 보여주세요. 풀이
- 고객의 first_name 이름의 첫번째 글자가, A, B,C 에 해당 하는 사람은  각 A,B,C 로 flag 를 붙여주시고 
   A,B,C 에 해당하지 않는 인원에 대해서는 Others 라는 flag 로  붙여주세요.	
   
-- coalesce() ~= NVL() ==> NULL 값이 발생했을때 값을 치환하는 함수.
WITH TB1 AS ( 
	SELECT 'A' CHK1, 'A' flag union all
	SELECT 'B' CHK1, 'B' flag union all
    SELECT 'C' CHK1, 'C' flag )
SELECT customer_id , first_name , COALESCE (flag, 'others') as flag
FROM customer c 
LEFT OUTER JOIN TB1 ON substring(c.first_name, 1, 1) = TB1.CHK1 ;  -- SUBSTRING = 문자열에서 특정 문자를 뽑아내는 함수, 대문자 변환 UPPER(), 소문자변환 LOWER()


   
문제6번) payment 테이블을 기준으로,  2007년 1월~ 3월 까지의 결제일에 해당하며,  staff2번 인원에게 결제를 진행한  결제건에 대해서는, Y 로   
그 외에 대해서는 N 으로 표기해주세요. with 절을 이용해주세요.	


문제7번) Payement 테이블을 기준으로,  결제에 대한 Quarter 분기를 함께 표기해주세요.
with 절을 활용해서 풀이해주세요.
1~월의 경우 Q1
4~6월 의 경우 Q2
7~9월의 경우 Q3
10~12월의 경우 Q4


문제8번) Rental 테이블을 기준으로,  회수일자에 대한 Quater 분기를 함께 표기해주세요. 풀이
with 절을 활용해서 풀이해주세요.
1~3월의 경우 Q1
4~6월 의 경우 Q2
7~9월의 경우 Q3
10~12월의 경우 Q4 로 함께 보여주세요.

WITH TB1 AS (
	SELECT CAST('2005-01-01 00:00:00' AS TIMESTAMP) CHK1, CAST('2005-03-31 23:59:59' AS TIMESTAMP) CHK2, 'Q1' QUATERS UNION ALL
	SELECT CAST('2005-04-01 00:00:00' AS TIMESTAMP) CHK1, CAST('2005-06-30 23:59:59' AS TIMESTAMP) CHK2, 'Q2' QUATERS UNION ALL
	SELECT CAST('2005-07-01 00:00:00' AS TIMESTAMP) CHK1, CAST('2005-09-30 23:59:59' AS TIMESTAMP) CHK2, 'Q3' QUATERS UNION ALL
	SELECT CAST('2005-10-01 00:00:00' AS TIMESTAMP) CHK1, CAST('2005-12-31 23:59:59' AS TIMESTAMP) CHK2, 'Q4' QUATERS )
SELECT r.* , TB1.QUATERS
FROM rental r 
LEFT OUTER JOIN TB1 ON r.rental_date BETWEEN TB1.CHK1 AND TB1.CHK2 ;
	


문제9번) 직원이이  월별  대여를 진행 한  대여 갯수가 어떻게 되는 지 알려주세요. 
대여 수량이   아래에 해당 하는 경우에 대해서, 각 flag 를 알려주세요 .

0~ 500개 의 경우  under_500 
501~ 3000 개의 경우  under_3000
3001 ~ 99999 개의 경우  over_3001  


문제10번) 직원의 현재 패스워드에 대해서, 새로이  패스워드를 지정하려고 합니다. 풀이
직원1의 새로운 패스워드는 12345  ,  직원2의 새로운 패스워드는 54321입니다.
해당의 경우, 직원별로 과거 패스워드와 현재 새로이 업데이트할 패스워드를 
함께 보여주세요.
with 절을 활용하여  새로운 패스워드 정보를 저장 후 , 알려주세요.	

WITH NEW_PASSWORD AS (
	SELECT 1 AS staff_id , '12345' AS NEW_PWD UNION ALL
	SELECT 2 AS staff_id , '54321' AS NEW_PWD )
SELECT s.staff_id , s."password" , np.new_pwd
FROM staff s
JOIN NEW_PASSWORD AS NP ON s.staff_id = np.staff_id ;



