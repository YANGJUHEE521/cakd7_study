--DML - ������ ���۾�
-- �˻�(select), ����(insert), ����(delete), ����(update)
-- �����͸� �˻��ϴ� ���ǹ� (SELECT - FROM - WHERE �� ����)


select * from book;
select bookname, price from book;
select publisher from book;

--distinct:�ߺ� ����
select distinct publisher from book;

-- price�� ���� �̸��� �� �̱�

select * from book
where price < 10000;

-- price�� ���� �̻� �̸��� ������ ���� �˻�
select * from book
where 10000 <= price and price <= 20000;

-- ���ǻ簡 �½����� Ȥ�� ���ѹ̵���� ���� �˻�
select * from book
where publisher = '�½�����' or publisher = '���ѹ̵��';

select * from book
where publisher in ('�½�����', '���ѹ̵��');

-- ���ǻ簡 �½����� Ȥ�� ���ѹ̵� �ƴ� ���� �˻�
select * from book
where publisher not in ('�½�����', '���ѹ̵��');

-- å�̸��� �౸�� ����ִ� ��
select * from book
where bookname like '%�౸%';

-- �����̸��� ���� �� ��° ��ġ�� '��'��� ���ڿ��� ���� ���� �˻�
select * from book
where bookname like '_��%';

-- �౸�� ���� ���� �� ������ �̸��� �̻��� ���� �˻�
select * from book
where bookname like '%�౸%' and price >= 20000;

-- �������� ����
select * from book
order by bookname;

-- �������� ����
select * from book
order by bookname desc;

-- ������ ���ݼ����� �˻��ϰ� ������ ������ �̸� ������ �˻�
select * from book
order by price, bookname;

--������ ������ ������������ �˻��ϰ� ������ ������ ���ǻ縦 ������������ ���
select * from book
order by price desc, publisher asc;

--
select * from orders;

select sum(saleprice)
from orders;

-- 2�� �迬�� ���� �ֹ��� ������ �� �Ǹž� ���ϱ�
select * from orders;
select sum(saleprice) as "�� �Ǹž�" from orders
where custid = 2;

-- saleprice�� �հ�, ���, �ּҰ�
-- �հ�:
select * from orders;

select avg(saleprice) as "���", 
min(saleprice) as "�ּҰ�", 
max(saleprice) as "�ִ�"
from orders;

select count(*)
from orders;

select custid, count(*) as ��������, sum(saleprice) as "�� �Ǹž�"
from orders
group by custid;

--[���� 0930_1] ������ 8000�� �̻��� ������ ������ ���� ���Ͽ� ���� �ֹ� ������ �� ������ ���ϼ���.
-- ��, �� �� �̻� ������ ���� ���ϼ���.
select custid, count(*) as "�ֹ����� �� ����"
from orders
where saleprice >= 8000
group by custid
having count(*) >= 2;
-- having�� ���� ������ ! , group by ����� ���� ��Ÿ���� �׷��� ���� 



-- �Ѵ� custid�� �����ϱ� ������ �� �ְ��� 
SELECT * FROM customer;
SELECT * FROM orders;

select * 
from customer, orders
where customer.custid = orders.custid;

-- ������ �� ���̺� ����
-- Q. ���� ���� �ֹ��� ���� �����͸� ������ �����Ͽ� ���
select * 
from customer, orders
where customer.custid = orders.custid;

-- Q. ���� �̸��� ���� �ֹ��� ������ �ǸŰ����� �˻�
SELECT customer.name, orders.saleprice
FROM customer, orders
WHERE customer.custid=orders.custid;

-- Q. ������ �ֹ��� ��� ������ �� �Ǹž��� ���ϰ�, ������ ����
SELECT customer.name, SUM(orders.saleprice) 
FROM  customer, orders 
WHERE customer.custid = orders.custid 
GROUP BY customer.name ORDER BY customer.name;

-- Q. ���� �̸��� ���� �ֹ��� ������ �̸��� ���ϼ���.
select customer.name, book.bookname
from customer, orders, book
where customer.custid = orders.custid and orders.bookid = book.bookid;

-- �̷��� �ص� �� 
select C.name, B.bookname
from customer C, order O, book B
where C.custid = O.custid and O.bookid = B.bookid;

-- Q. ������ 20000���� ������ �ֹ��� ���� �̸��� ������ �̸��� ���ϼ���. 
select customer.name, book.bookname
from customer, orders, book
where customer.custid = orders.custid and orders.bookid = book.bookid and book.price = 20000;

-- Q. ������ �������� ���� ���� �����Ͽ� ���� �̸��� ���� �ֹ��� ������ �ǸŰ����� ���ϼ���.
select customer.name, orders.saleprice as "�ǸŰ���"
from customer left outer join orders on customer.custid = orders.custid;

-- �̷��Ե� ���� 
select C.name, O.saleprice
from customer C, orders O
where C.custid = O.custid(+);

select * from book;
-- Q. ���� ��� ������ �̸��� ���(��������) 
select bookname 
from book
where price = (select max(price) from book);

-- [���� 0930_2] ������ ������ ���� �ִ� ���� �̸��� �˻�
select name
from customer
where custid in (select custid from orders);
-- [���� 0930_3] ���� �̵��� ������ ������ ������ ���� �̸��� ���
select name
from customer
where custid in (select custid from orders where bookid in (select bookid from book where publisher='���ѹ̵��'));
-- [���� 0930_4] ���ǻ纰�� ���ǻ��� ��� ���� ���ݺ��� ��� ������ ���
select b1.bookname
from book b1
where b1.price > (select avg(b2.price) from book b2 where b2.publisher = b1.publisher);

-- [���� 0930_5] ������ �ֹ����� ���� ���� �̸��� ���
SELECT C.name, O.orderid FROM customer C,orders O WHERE C.custid = O.custid(+) and O.custid IS NULL;

SELECT DISTINCT C.name FROM orders O, customer C WHERE C.custid NOT IN (SELECT custid FROM orders);

-- MINUS�� ����Ͽ� ���� �Ǵ� ���� ���̺��� ������ �Ǵ� ���� ���̺��� �� ����� ����ϴ� ���
SELECT name FROM customer
MINUS SELECT name FROM customer WHERE custid IN(SELECT custid FROM orders);

-- [���� 0930_6] �ֹ��� �ִ� ���� �̸��� �ּҸ� ��� 
SELECT name, address FROM customer WHERE custid IN (SELECT custid FROM orders);

SELECT DISTINCT C.name, C.address FROM customer C,orders O WHERE O.custid = C.custid;
--DDL - ������ ���Ǿ� 
-- DBMS�� ����� ���̺� ������ ����
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

-- ����_1004_1. newbook ���̺��� isbn �Ӽ��� �����ϼ���. 
ALTER TABLE newbook DROP column isbn;
-- ����_1004_2. newbook ���̺��� �⺻Ű�� ������ �� �ٽ� bookid �Ӽ��� �⺻Ű�� �����ϼ���.
alter table newbook drop primary key;
alter table newbook add constraint "creat pk" primary key(bookid);
-- ����_1004_3. newbook ���̺��� �����ϼ���. 
drop table newbook;

select * from customer;
--Q. customer ���̺��� ����ȣ�� 5�� ���� �ּҸ� "���ѹα� �λ�"���� ����.
update customer
set address = '���ѹα� �λ�'
where custid = 5;

--Q. CUSTOMER ���̺��� �ڼ��� ���� �ּҸ� �迬�� ���� �ּҷ� ����

update customer
set address = (select address from customer where name = '�迬��')
where custid = 5;

--Q. CUSTOMER ���̺��� ����ȣ�� 5�� ���� ������ �� ����� Ȯ��
DELETE customer
WHERE custid = 5;

