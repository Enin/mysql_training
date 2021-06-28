문제1번) 고객의 기본 정보인, 고객 id, 이름, 성, 이메일과 함께 고객의 주소 address, district, postal_code, phone 번호를 함께 보여주세요. 	풀이

SELECT * FROM customer c ;
SELECT * FROM address a ;
-- ADDRESS 속성으로 JOIN
SELECT C.CUSTOMER_ID, C.FIRST_NAME, C.LAST_NAME, C.EMAIL ,
A.ADDRESS, A.DISTRICT, A.POSTAL_CODE, A.PHONE
FROM CUSTOMER C 
JOIN ADDRESS A 
ON C.ADDRESS_ID = A.ADDRESS_ID ;

문제2번) 고객의  기본 정보인, 고객 id, 이름, 성, 이메일과 함께 고객의 주소 address, district, postal_code, phone , city 를 함께 알려주세요. 	풀이

SELECT C.CUSTOMER_ID, C.FIRST_NAME, C.LAST_NAME, C.EMAIL ,
A.ADDRESS, A.DISTRICT, A.POSTAL_CODE, A.PHONE ,
C2.CITY
FROM CUSTOMER C 
JOIN ADDRESS A ON C.ADDRESS_ID = A.ADDRESS_ID
JOIN CITY C2 ON A.CITY_ID = C2.CITY_ID ; -- 추가 조인을 수행.

문제3번) Lima City에 사는 고객의 이름과, 성, 이메일, phonenumber에 대해서 알려주세요.	풀이

SELECT c.first_name , c.last_name , c.email
	, A.phone
	, C2.city 
FROM customer c 
JOIN ADDRESS A ON C.ADDRESS_ID = A.ADDRESS_ID
JOIN CITY C2 ON A.CITY_ID = C2.CITY_ID
WHERE C2.CITY IN ('Lima') ;

문제4번) rental 정보에 추가로, 고객의 이름과, 직원의 이름을 함께 보여주세요.
- 고객의 이름, 직원 이름은 이름과 성을  fullname 컬럼으로만들어서 직원이름/고객이름 2개의 컬럼으로 확인해주세요.	 풀이

SELECT * FROM RENTAL ;
SELECT r.* ,
	   c.first_name ||' '|| c.last_name AS C_FULLNAME,
	   s.first_name ||' '|| s.last_name AS S_FULLNAME
FROM rental r 
JOIN staff s ON r.staff_id = s.staff_id 
JOIN customer c ON r.customer_id = c.customer_id ;

문제5번) seth.hannon@sakilacustomer.org 이메일 주소를 가진 고객의  주소 address, address2, postal_code, phone, city 주소를 알려주세요.	

SELECT * FROM customer c ;
SELECT * FROM address a ;
SELECT * FROM city c ;

SELECT a.address, a.address2, a.postal_code, a.phone, 
	   c2.city
FROM address a 
JOIN customer c ON a.address_id = c.address_id 
JOIN city c2 ON a.city_id = c2.city_id 
WHERE c.email = 'seth.hannon@sakilacustomer.org' ;

문제6번) Jon Stephens 직원을 통해 dvd대여를 한 payment 기록 정보를  확인하려고 합니다. 
      - payment_id,  고객 이름 과 성,  rental_id, amount, staff 이름과 성을 알려주세요. 	
      
SELECT * FROM payment p ;

SELECT p.payment_id , 
	   c.first_name ||' '|| c.last_name AS C_FULLNAME , p.rental_id , p.amount ,
	   s.first_name ||' '|| s.last_name AS S_FULLNAME 
FROM payment p 
JOIN staff s ON p.staff_id = s.staff_id 
JOIN customer c ON p.customer_id = c.customer_id 
WHERE s.first_name ||' '|| s.last_name = 'Jon Stephens' ;


문제7번) 배우가 출연하지 않는 영화의 film_id, title, release_year, rental_rate, length 를 알려주세요. 	

SELECT * FROM film f;
SELECT * FROM film_actor fa ;

-- 배우가 출연하지 않는 영화: film_actoer에서 각 actor_id가 한번도 나오지 않는 film_id.
SELECT *
FROM film f 
WHERE 

SELECT f.film_id, f.title, f.release_year , f.rental_rate , f.length
FROM film f 
LEFT OUTER JOIN film_actor fa ON f.film_id = fa.film_id 
WHERE fa.actor_id IS NULL
ORDER BY film_id ;

문제8번) store 상점 id별 주소 (address, address2, distict) 와 해당 상점이 위치한 city 주소를 알려주세요. 	

SELECT * FROM STORE ;
SELECT * FROM address a ;
SELECT * FROM city c ;

SELECT a.address , a.address2 , a.district , c.city 
FROM address a 
LEFT OUTER JOIN store s ON a.address_id = s.address_id 
JOIN city c ON a.city_id = c.city_id 
WHERE s.address_id IS NOT NULL;

문제9번) 고객의 id 별로 고객의 이름 (first_name, last_name), 이메일, 고객의 주소 (address, district), phone번호, city, country 를 알려주세요. 	

SELECT * FROM customer c ;

SELECT c.first_name ||', '|| c.last_name AS CUSTOMER_NAME ,
	   c.email,
	   a.address ||', '|| a.district AS CUSTOMER_ADDRESS ,
	   a.phone ,
	   ct.city ,
	   cn.country 
FROM customer c 
JOIN address a ON c.address_id = a.address_id 
JOIN city ct ON a.city_id = ct.city_id 
JOIN country cn ON ct.country_id = cn.country_id ;

문제10번) country 가 china 가 아닌 지역에 사는, 고객의 이름(first_name, last_name)과 , email, phonenumber, country, city 를 알려주세요	풀이

--아닌지역: 이너조인사용
SELECT * FROM customer c ;

SELECT c.first_name , c.last_name, c.email , a.phone , cn.country , ct.city 
FROM customer c 
JOIN address a ON c.address_id = a.address_id 
JOIN city ct ON a.city_id = ct.city_id
JOIN country cn ON ct.country_id = cn.country_id
WHERE cn.country NOT IN ('China') ;

문제11번) Horror 카테고리 장르에 해당하는 영화의 이름과 description 에 대해서 알려주세요 	

SELECT * FROM film f ;
SELECT * FROM film_category fc ;
SELECT * FROM category c ;

SELECT f.title, f.description
FROM film f 
JOIN film_category fc ON f.film_id = fc.film_id 
JOIN category c ON fc.category_id = c.category_id 
WHERE c.name = 'Horror' ;

문제12번) Music 장르이면서, 영화길이가 60~180분 사이에 해당하는 영화의 title, description, length 를 알려주세요. 풀이
   -  영화 길이가 짧은 순으로 정렬해서 알려주세요. 	
   
SELECT * FROM film f ;
SELECT * FROM film_category fc ;
SELECT * FROM category c ;

SELECT F.TITLE , F.DESCRIPTION , F.LENGTH 
FROM FILM F 
JOIN FILM_CATEGORY FC ON F.FILM_ID = FC.FILM_ID
JOIN CATEGORY C ON FC.CATEGORY_ID = C.CATEGORY_ID 
WHERE C.NAME = 'MUSIC'
AND F.LENGTH BETWEEN 60 AND 180
ORDER BY F.LENGTH ;
 
문제13번) actor 테이블을 이용하여,  배우의 ID, 이름, 성 컬럼에 추가로    
'Angels Life' 영화에 나온 영화 배우 여부를 Y , N 으로 컬럼을 추가 표기해주세요.  해당 컬럼은 angelslife_flag로 만들어주세요.	         풀이

SELECT * FROM actor a ;
SELECT * FROM film f ;
SELECT * FROM film_actor fa ;

-- Angels Life 라는 이름을 갖는 영화를 확인.
SELECT *
FROM film f 
WHERE title = 'Angels Life' ;

-- film과 film_actor 테이블을 조인하여 Angels Life를 찍은 영화배우들을 확인.
SELECT f.film_id , f.title , fa.actor_id 
FROM film f 
JOIN film_actor fa ON f.film_id = fa.film_id
WHERE title = 'Angels Life' ;
/* 1,4,7,47,91,136,166,167,187 */

SELECT a.actor_id , a.first_name , a.last_name ,
	   CASE WHEN angels_actor.actor_id IS NOT NULL THEN 'Y'
	   ELSE 'N'
	   END AS angelslife_flag
FROM actor a -- actor 테이블도 중복이 발생하지 않는다.
LEFT OUTER JOIN ( --영화를 찍은 영화배우들의 정보를 서브쿼리로 만들고 actor와 outer join. 한 필름에 출연하는 배우는 중복 발생안함.
				  -- left outer join을 사용하여 NULL 정보까지 모두 가져와야 한다.
					SELECT f.film_id , f.title , fa.actor_id 
					FROM film f 
					JOIN film_actor fa ON f.film_id = fa.film_id
					WHERE title = 'Angels Life' 
) AS angels_actor -- 해당 서브쿼리의 이름을 angels_actor 로 정해줌
ON a.actor_id = angels_actor.actor_id ; -- LEFT OUTER JOIN의 기준을 actor_id로 수행.

film_actor fa ON a.actor_id = fa.actor_id -- NULL 값까지 가져오려면 OUTER JOIN을 수행
JOIN film f ON fa.film_id = f.film_id ;

문제14번) 대여일자가 2005-06-01~ 14일에 해당하는 주문 중에서 , 
직원의 이름(이름 성) = 'Mike Hillyer' 이거나  고객의 이름이 (이름 성) ='Gloria Cook'  에 해당 하는 rental 의 모든 정보를 알려주세요. 풀이
 - 추가로  직원이름과, 고객이름에 대해서도  fullname 으로 구성해서 알려주세요.	
 
SELECT * FROM rental r ;

SELECT r.* , 
	   c.first_name ||' '|| c.last_name AS c_fullname , 
	   s.first_name ||' '|| s.last_name AS s_fullname 
FROM rental r 
JOIN customer c ON r.customer_id = c.customer_id 
JOIN staff s ON r.staff_id = s.staff_id 
WHERE date(rental_date) BETWEEN '2005-06-01' AND '2005-06-14'
AND (s.first_name ||' '|| s.last_name = 'Mike Hillyer'
	OR c.first_name ||' '|| c.last_name = 'Gloria Cook') ;

문제15번) 대여일자가 2005-06-01~ 14일에 해당하는 주문 중에서 , 직원의 이름(이름 성) = 'Mike Hillyer' 에 해당 하는 직원에게  구매하지 않은  rental 의 모든 정보를 알려주세요.
 - 추가로  직원이름과, 고객이름에 대해서도  fullname 으로 구성해서 알려주세요.	
 
SELECT *
FROM rental r
WHERE date(r.rental_date) BETWEEN '2005-06-01' AND '2005-06-14' ;

SELECT r.*
FROM rental r 
JOIN (SELECT *
		FROM staff s2
		WHERE s2.first_name||' '|| s2.last_name = 'Mike Hillyer' 
) AS s ON r.staff_id = s.staff_id
WHERE date(r.rental_date) BETWEEN '2005-06-01' AND '2005-06-14' ;