--DML - 데이터 조작어
-- 검색(select), 삽입(insert), 삭제(delete), 수정(update)
-- 데이터를 검색하는 질의문 (SELECT - FROM - WHERE 의 구조)


select * from book;
select bookname, price from book;
select publisher from book;

--distinct:중복 빼고
select distinct publisher from book;

-- price가 만원 미만인 것 뽑기

select * from book
where price < 10000;

-- price가 만원 이상 이만원 이하인 도서 검색
select * from book
where 10000 <= price and price <= 20000;

-- 출판사가 굿스포츠 혹은 대한미디어인 도서 검색
select * from book
where publisher = '굿스포츠' or publisher = '대한미디어';

select * from book
where publisher in ('굿스포츠', '대한미디어');

-- 출판사가 굿스포츠 혹은 대한미디어가 아닌 도서 검색
select * from book
where publisher not in ('굿스포츠', '대한미디어');

-- 책이름에 축구가 들어있는 것
select * from book
where bookname like '%축구%';

-- 도서이름의 왼쪽 두 번째 위치에 '구'라는 문자열을 갖는 도서 검색
select * from book
where bookname like '_구%';

-- 축구에 관한 도서 중 가격이 이만원 이상인 도서 검색
select * from book
where bookname like '%축구%' and price >= 20000;

-- 오름차순 정렬
select * from book
order by bookname;

-- 내림차순 정렬
select * from book
order by bookname desc;

-- 도서를 가격순으로 검색하고 가격이 같으면 이름 순으로 검색
select * from book
order by price, bookname;

--도서를 가격의 내림차순으로 검색하고 가격이 같으면 출판사를 오름차순으로 출력
select * from book
order by price desc, publisher asc;

--
select * from orders;

select sum(saleprice)
from orders;

-- 2번 김연아 고객이 주문한 도서의 총 판매액 구하기
select * from orders;
select sum(saleprice) as "총 판매액" from orders
where custid = 2;

-- saleprice의 합계, 평균, 최소값
-- 합계:
select * from orders;

select avg(saleprice) as "평균", 
min(saleprice) as "최소값", 
max(saleprice) as "최댓값"
from orders;

select count(*)
from orders;

select custid, count(*) as 도서수량, sum(saleprice) as "총 판매액"
from orders
group by custid;

--[과제 0930_1] 가격이 8000원 이상인 도서를 구매한 고객에 대하여 고객별 주문 도서의 총 수량을 구하세요.
-- 단, 두 권 이상 구매한 고객만 구하세요.
select custid, count(*) as "주문도서 총 수량"
from orders
where saleprice >= 8000
group by custid
having count(*) >= 2;
-- having이 제일 마지막 ! , group by 결과에 대해 나타나는 그룹을 제한 



-- 둘다 custid가 있으니까 결합할 수 있겠지 
SELECT * FROM customer;
SELECT * FROM orders;

select * 
from customer, orders
where customer.custid = orders.custid;

-- 결합한 두 테이블 정렬
-- Q. 고객과 고객의 주문에 관한 데이터를 고객별로 정렬하여 출력
select * 
from customer, orders
where customer.custid = orders.custid;

-- Q. 고객의 이름과 고객이 주문한 도서의 판매가격을 검색
SELECT customer.name, orders.saleprice
FROM customer, orders
WHERE customer.custid=orders.custid;

-- Q. 고객별로 주문한 모든 도서의 총 판매액을 구하고, 고객별로 정렬
SELECT customer.name, SUM(orders.saleprice) 
FROM  customer, orders 
WHERE customer.custid = orders.custid 
GROUP BY customer.name ORDER BY customer.name;

-- Q. 고객의 이름과 고객이 주문한 도서의 이름을 구하세요.
select customer.name, book.bookname
from customer, orders, book
where customer.custid = orders.custid and orders.bookid = book.bookid;

-- 이렇게 해도 됨 
select C.name, B.bookname
from customer C, order O, book B
where C.custid = O.custid and O.bookid = B.bookid;

-- Q. 가격이 20000원인 도서를 주문한 고객의 이름과 도서의 이름을 구하세요. 
select customer.name, book.bookname
from customer, orders, book
where customer.custid = orders.custid and orders.bookid = book.bookid and book.price = 20000;

-- Q. 도서를 구매하지 않은 고객을 포함하여 고객의 이름과 고객이 주문한 도서의 판매가격을 구하세요.
select customer.name, orders.saleprice as "판매가격"
from customer left outer join orders on customer.custid = orders.custid;

-- 이렇게도 가능 
select C.name, O.saleprice
from customer C, orders O
where C.custid = O.custid(+);

select * from book;
-- Q. 가장 비싼 도서의 이름을 출력(서브쿼리) 
select bookname 
from book
where price = (select max(price) from book);

-- [과제 0930_2] 도서를 구매한 적이 있는 고객의 이름을 검색
select name
from customer
where custid in (select custid from orders);
-- [과제 0930_3] 대한 미디어에서 출판한 도서를 구매한 고객의 이름을 출력
select name
from customer
where custid in (select custid from orders where bookid in (select bookid from book where publisher='대한미디어'));
-- [과제 0930_4] 출판사별로 출판사의 평균 도서 가격보다 비싼 도서를 출력
select b1.bookname
from book b1
where b1.price > (select avg(b2.price) from book b2 where b2.publisher = b1.publisher);

-- [과제 0930_5] 도서를 주문하지 않은 고객의 이름을 출력
SELECT C.name, O.orderid FROM customer C,orders O WHERE C.custid = O.custid(+) and O.custid IS NULL;

SELECT DISTINCT C.name FROM orders O, customer C WHERE C.custid NOT IN (SELECT custid FROM orders);

-- MINUS를 사용하여 왼쪽 또는 상위 테이블에서 오른쪽 또는 하위 테이블을 뺀 결과만 출력하는 방법
SELECT name FROM customer
MINUS SELECT name FROM customer WHERE custid IN(SELECT custid FROM orders);

-- [과제 0930_6] 주문이 있는 고객의 이름과 주소를 출력 
SELECT name, address FROM customer WHERE custid IN (SELECT custid FROM orders);

SELECT DISTINCT C.name, C.address FROM customer C,orders O WHERE O.custid = C.custid;
--DDL - 데이터 정의어 
-- DBMS에 저장된 테이블 구조를 정의
-- CREATE, ALTER, DROP
CREATE TABLE newbook(
bookid       NUMBER, 
bookname     VARCHAR2(20) NOT NULL,
publisher    VARCHAR2(20) UNIQUE,
price        NUMBER DEFAULT 10000 CHECK(price > 10000),
PRIMARY KEY  (bookid));

DESC newbook;

DROP TABLE newbook;

create table newbook(
bookid number primary key,
bookname varchar(20) not null,
publisher varchar(20) unique,
price number default 10000 check(price > 10000));

desc newbook;
alter table newbook add isbn varchar2(15);

-- 과제_1004_1. newbook 테이블의 isbn 속성을 삭제하세요. 
ALTER TABLE newbook DROP column isbn;
-- 과제_1004_2. newbook 테이블의 기본키를 삭제한 후 다시 bookid 속성을 기본키로 변경하세요.
alter table newbook drop primary key;
alter table newbook add constraint "creat pk" primary key(bookid);
-- 과제_1004_3. newbook 테이블을 삭제하세요. 
drop table newbook;

select * from customer;
--Q. customer 테이블에서 고객번호가 5인 고객의 주소를 "대한민국 부산"으로 변경.
update customer
set address = '대한민국 부산'
where custid = 5;

--Q. CUSTOMER 테이블에서 박세리 고객의 주소를 김연아 고객의 주소로 변경

update customer
set address = (select address from customer where name = '김연아')
where custid = 5;

--Q. CUSTOMER 테이블에서 고객번호가 5인 고객을 삭제한 후 결과를 확인
DELETE customer
WHERE custid = 5;

