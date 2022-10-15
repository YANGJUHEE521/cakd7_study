SELECT ABS(-78), ABS(+78)
FROM dual; 
-- �ܼ� ��� �Ҷ��� dual�� ���ش� 


SELECT ROUND(4.875, 1)
FROM dual;

--Q. ���� ��� �ֹ� �ݾ��� ���ϼ���. 
SELECT * FROM orders;
SELECT ROUND(avg(O.saleprice))
FROM orders O,customer C
WHERE C.custid=O.custid
GROUP BY c.custid;

--Q. �� �̸��� ��� �ֹ� �ݾ��� ���ϼ���.
SELECT C.name ,ROUND(avg(O.saleprice))
FROM orders O,customer C
WHERE C.custid=O.custid
GROUP BY c.name;

--Q. ���� ���� '�߱�'�� ���Ե� ������ '��'�� ������ �� �������, ������ ���
SELECT bookid, replace(bookname, '�߱�','��') bookname, publisher, price
from book;

-- ���ڼ�, ����Ʈ�� ���ϴ� ��
select bookname ����, length(bookname) ���ڼ�, lengthb(bookname) AS ����Ʈ��
FROM book;

--������ ���� �ִ� �� (Į��������� �־����)
select * from customer;
insert into customer values(6, '�ڼ���', '���ѹα� ����', NULL);

--����_1024_4. CUSTOMER ���̺��� ���� ���� ���� ����� �� ���̳� �Ǵ��� ���� �ο����� ���ϼ���. 
select * from customer;

select substr(name,1,1), count(*)
from customer
group by substr(name, 1,1);

select * from orders;
--Q. �ֹ��Ϸκ��� 10�� �� ������ Ȯ���Ѵ�. �� �ֹ��� Ȯ�����ڸ� ���ϼ���. 
-- as �����൵ �� ! 
select orderid �ֹ���ȣ, orderdate �ֹ���, orderdate + 10 Ȯ��
from orders;


--����_1004_5. 2020�� 7�� 7�Ͽ� �ֹ����� ������ �ֹ���ȣ, �ֹ���, ����ȣ, ������ȣ�� ��� ���
--��, �ֹ����� '2020-07-07 ȭ����' ����
SELECT orderid �ֹ���ȣ, to_char(orderdate,'yyyy-mm-dd day') �ֹ���, custid ����ȣ, bookid ������ȣ
from orders
where orderdate = '20/07/07';


--���� ��¥
select sysdate from dual;

select sysdate, to_char(sysdate, 'yyyy/mm/dd dy hh24:mi/ss') SYSDATE1
from dual;

select * from customer;
--Q. �̸�, ��ȭ��ȣ�� ���Ե� �� ����� ���̼���. ��, ��ȭ��ȣ�� ���� ���� '����ó ����'���� ǥ���Ͽ� ���
SELECT name �̸�, nvl(phone, '����ó ����') ��ȭ��ȣ
from customer;

--Q. SELECT COALESCE(NULL, NULL, 'third value', 'forth value'); ����° ���� null�� �ƴ� ù��° ���̱� ������, ����° ���� ��ȯ
select name �̸�, phone, coalesce(phone, '����ó ����') ��ȭ��ȣ
from customer;

--��µ� ���� �������� 
select ROWNUM ����, custid ����ȣ, name �̸�, phone ��ȭ��ȣ
from customer
where rownum <= 3;

--Q. ��� �ֹ��ݾ� ������ �ֹ��� ���ؼ� �ֹ���ȣ�� �ݾ��� ���
SELECT orderid �ֹ���ȣ , saleprice �ݾ�
FROM orders
where saleprice <= (select avg(saleprice) from orders);

--Q. �� ���� ��� �ֹ��ݾ׺��� ū �ݾ��� �ֹ� ������ ���ؼ� �ֹ���ȣ, ����ȣ, �ݾ��� ���
SELECT orderid �ֹ���ȣ, custid ����ȣ, saleprice �ݾ�
FROM orders o1
WHERE saleprice > (SELECT AVG(saleprice) FROM orders o2 
                    WHERE o1.custid = o2.custid );
                

--����_1004_6. ���ѹα��� �����ϴ� ������ �Ǹ��� ������ �� �Ǹž��� ���
select * from customer;
select * from orders;

select sum(saleprice) ���Ǹž� from orders
where custid in (select custid
                 from customer
                 where address like '%���ѹα�%');
                 
--����_1004_7. 3�� ���� �ֹ��� ������ �ְ� �ݾ׺��� ����� ������ ������ �ֹ��� �ֹ���ȣ�� �ݾ��� ��� 
select orderid, saleprice
from orders
where saleprice > all(select saleprice
                      from orders
                      where custid='3');
                      
--�̷��� �ص� �� 
select orderid �ֹ���ȣ, saleprice �ݾ�
from orders 
where saleprice > (select max(saleprice) from orders where custid='3');

--��ȥ��; ���缭���� ���� �Ǹž��� ���̽ÿ�(���̸��� ���� �Ǹž� ���)
select (select name from orders o2 where o1.custid = o2.custid), sum(saleprice) 
from orders o1
group by o1.custid;

--����_1004_8. ����ȣ�� 2 ������ ���� �Ǹž��� ���(��, �� �̸��� ���� �Ǹž� ����)
--p.234 ���� 
select cs.name, sum(od.saleprice)
from (select custid, name from customer where custid <=2) cs, orders od
where cs.custid = od.custid
group by cs.name;

--����_1004_9. lmembers �����͸� ������ �Ӽ�(����, ����, ��������) �����հ�(�ݱ⺰), ��ձ���(�ݱ⺰), ���ź�(�ݱ⺰)�� ���



select * from customer;
select * from orders;

-- (+)�� �ܺ������ؼ� ���� �Ǹž��̶� �� �̸� ����ϼ� 
select c.name, sum(o.saleprice)
from customer c, orders o
where o.custid = c.custid(+)
group by c.name;


--Q. null�� 0����, Į������ ���� �Ǹž����� ���� 
--customer table ���� join�̴ϱ� saleprice�� null�� ���� �� ���ݾ� ���� ���� ����� 
SELECT C.name, NVL(SUM(O.saleprice),0) "���� �Ǹž�"
FROM orders O, customer C
WHERE C.custid = O.custid(+)
GROUP BY C.name;

--View�� ������ ���̺��̶�� �ϸ�, �����ʹ� ����, sql�� ����Ǿ��ִ� object
--view�� �⺻ ���̺��̳� �並 �����ϰ� �Ǹ�, �ش� �����͸� ���ʷ��� �ٸ� ����� �ڵ����� �����ǰ�, alter ����� ����� �� ����.
-- ������ �����ϱ� ���ؼ��� drop & create�� �ݺ��Ͽ��� �ϸ�, �����̸��� ������ �� ����.
-- �ǹ������ 'vw_' ���̻糪 ���λ� �ٿ� ���

--�ּҿ� ���ѹα��� �����ϴ� ����� ������ �並 ����� ��ȸ 
create view vw_customer
as select *
from customer
where address like '%���ѹα�%';

select * from vw_customer;

--���� view���� '����'�� �ּҷ� ���� ���� id, �̸�, �ּ� ����ϴ� view�� �����ض�
CREATE OR REPLACE VIEW vw_customer(custid, name, address)
as select custid, name, address
from customer
where address like '%����%';

select * from vw_customer;
--Q. orders ���̺��� ���̸��� ���� �̸��� �ٷ� Ȯ���� �� �ִ� �並 ������ ��,
-- �迬�� ���� ������ ������ �ֹ���ȣ, �����̸�, ���ǻ� ���  
create view vw_orders
as select c.name, o.orderid, b.bookname, b.publisher
from orders o, book b, customer c
where c.custid = o.custid and b.bookid = o.bookid;

SELECT
    *
FROM vw_orders
where name = '�迬��';


-- �����ϱ�
drop view vw_orders;
drop view vw_customer;

