SELECT ABS(-78), ABS(+78)
FROM dual; 
-- 단순 계산 할때는 dual을 써준다 


SELECT ROUND(4.875, 1)
FROM dual;

--Q. 고객별 평균 주문 금액을 구하세요. 
SELECT * FROM orders;
SELECT ROUND(avg(O.saleprice))
FROM orders O,customer C
WHERE C.custid=O.custid
GROUP BY c.custid;

--Q. 고객 이름별 평균 주문 금액을 구하세요.
SELECT C.name ,ROUND(avg(O.saleprice))
FROM orders O,customer C
WHERE C.custid=O.custid
GROUP BY c.name;

--Q. 도서 제목에 '야구'가 포함된 도서를 '농구'로 변경한 후 도서목록, 가격을 출력
SELECT bookid, replace(bookname, '야구','농구') bookname, publisher, price
from book;

-- 글자수, 바이트수 구하는 법
select bookname 제목, length(bookname) 글자수, lengthb(bookname) AS 바이트수
FROM book;

--데이터 집어 넣는 법 (칼럼순서대로 넣어야함)
select * from customer;
insert into customer values(6, '박세리', '대한민국 대전', NULL);

--과제_1024_4. CUSTOMER 테이블에서 같은 성을 가진 사람이 몇 명이나 되는지 성별 인원수를 구하세요. 
select * from customer;

select substr(name,1,1), count(*)
from customer
group by substr(name, 1,1);

select * from orders;
--Q. 주문일로부터 10일 후 매출을 확정한다. 각 주문의 확정일자를 구하세요. 
-- as 안해줘도 돼 ! 
select orderid 주문번호, orderdate 주문일, orderdate + 10 확정
from orders;


--과제_1004_5. 2020년 7월 7일에 주문받은 도서의 주문번호, 주문일, 고객번호, 도서번호를 모두 출력
--단, 주문일은 '2020-07-07 화요일' 포멧
SELECT orderid 주문번호, to_char(orderdate,'yyyy-mm-dd day') 주문일, custid 고객번호, bookid 도서번호
from orders
where orderdate = '20/07/07';


--현재 날짜
select sysdate from dual;

select sysdate, to_char(sysdate, 'yyyy/mm/dd dy hh24:mi/ss') SYSDATE1
from dual;

select * from customer;
--Q. 이름, 전화번호가 포함된 고객 목록을 보이세요. 단, 전화번호가 없는 고객은 '연락처 없음'으로 표현하여 출력
SELECT name 이름, nvl(phone, '연락처 없음') 전화번호
from customer;

--Q. SELECT COALESCE(NULL, NULL, 'third value', 'forth value'); 세번째 값이 null이 아닌 첫번째 값이기 때문에, 세번째 값을 반환
select name 이름, phone, coalesce(phone, '연락처 없음') 전화번호
from customer;

--출력된 행을 조절해줌 
select ROWNUM 순번, custid 고객번호, name 이름, phone 전화번호
from customer
where rownum <= 3;

--Q. 평균 주문금액 이하의 주문에 대해서 주문번호와 금액을 출력
SELECT orderid 주문번호 , saleprice 금액
FROM orders
where saleprice <= (select avg(saleprice) from orders);

--Q. 각 고객의 평균 주문금액보다 큰 금액의 주문 내역에 대해서 주문번호, 고객번호, 금액을 출력
SELECT orderid 주문번호, custid 고객번호, saleprice 금액
FROM orders o1
WHERE saleprice > (SELECT AVG(saleprice) FROM orders o2 
                    WHERE o1.custid = o2.custid );
                

--과제_1004_6. 대한민국에 거주하는 고객에게 판매한 도서의 총 판매액을 출력
select * from customer;
select * from orders;

select sum(saleprice) 총판매액 from orders
where custid in (select custid
                 from customer
                 where address like '%대한민국%');
                 
--과제_1004_7. 3번 고객이 주문한 도서의 최고 금액보다 더비싼 도서를 구입한 주문의 주문번호와 금액을 출력 
select orderid, saleprice
from orders
where saleprice > all(select saleprice
                      from orders
                      where custid='3');
                      
--이렇게 해도 됨 
select orderid 주문번호, saleprice 금액
from orders 
where saleprice > (select max(saleprice) from orders where custid='3');

--나혼자; 마당서점의 고객별 판매액을 보이시오(고객이름과 고객별 판매액 출력)
select (select name from orders o2 where o1.custid = o2.custid), sum(saleprice) 
from orders o1
group by o1.custid;

--과제_1004_8. 고객번호가 2 이하인 고객의 판매액을 출력(단, 고객 이름과 고객별 판매액 포함)
--p.234 문제 
select cs.name, sum(od.saleprice)
from (select custid, name from customer where custid <=2) cs, orders od
where cs.custid = od.custid
group by cs.name;

--과제_1004_9. lmembers 데이터를 고객별로 속성(성별, 나이, 거주지역) 구매합계(반기별), 평균구매(반기별), 구매빈도(반기별)를 출력



select * from customer;
select * from orders;

-- (+)로 외부조인해서 고객별 판매액이랑 고객 이름 출력하셈 
select c.name, sum(o.saleprice)
from customer c, orders o
where o.custid = c.custid(+)
group by c.name;


--Q. null을 0으로, 칼럼명을 고객별 판매액으로 수정 
--customer table 기준 join이니까 saleprice가 null값 있을 수 있잖아 구입 안한 사람들 
SELECT C.name, NVL(SUM(O.saleprice),0) "고객별 판매액"
FROM orders O, customer C
WHERE C.custid = O.custid(+)
GROUP BY C.name;

--View는 가상의 테이블이라고 하며, 데이터는 없고, sql만 저장되어있는 object
--view는 기본 테이블이나 뷰를 삭제하게 되면, 해당 데이터를 기초로한 다른 뷰들이 자동으로 삭제되고, alter 명령을 사용할 수 없다.
-- 내용을 수정하기 위해서는 drop & create를 반복하여야 하며, 원본이름도 생성할 수 없다.
-- 실무세어는 'vw_' 접미사나 접두사 붙여 사용

--주소에 대한민국을 포함하는 고객들로 구성된 뷰를 만들고 조회 
create view vw_customer
as select *
from customer
where address like '%대한민국%';

select * from vw_customer;

--위에 view에서 '영국'을 주소로 가진 고객의 id, 이름, 주소 출력하는 view로 수정해라
CREATE OR REPLACE VIEW vw_customer(custid, name, address)
as select custid, name, address
from customer
where address like '%영국%';

select * from vw_customer;
--Q. orders 테이블에서 고객이름과 도서 이름을 바로 확인할 수 있는 뷰를 생성한 후,
-- 김연아 고객이 구입한 도서의 주문번호, 도서이름, 출판사 출력  
create view vw_orders
as select c.name, o.orderid, b.bookname, b.publisher
from orders o, book b, customer c
where c.custid = o.custid and b.bookid = o.bookid;

SELECT
    *
FROM vw_orders
where name = '김연아';


-- 삭제하기
drop view vw_orders;
drop view vw_customer;

