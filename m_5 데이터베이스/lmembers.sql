--lmembers
SELECT * FROM purprd;
SELECT COUNT(*) FROM PURPRD;
SELECT SUM(PURAMT) FROM PURPRD;
SELECT AVG(PURAMT) FROM PURPRD;

-- �̷������� 6���� �� �϶��Ͻ� 
-- PURPRD ���� 

--Q. lmembers purprd ���̺�κ��� �� ���ž�, 2014 ���ž�, 2015 ���ž��� �ѹ��� ���
select (select sum(p1.puramt) from purprd p1) as amt,
(select sum(p2.puramt) from purprd p2 where p2.purdate < 20150101) as amt_2014,
(select sum(p3.puramt) from purprd p3 where p3.purdate > 20141231) as amt_2015
from dual;

--�Ǵ� ! 
select sum(puramt) �ѱ��ž�, 
sum(case when purdate <= '20141231' then puramt end) "2014 ���ž�", 
sum(case when purdate > '20141231' and purdate <= '20151231' then puramt end) "2015 ���ž�"
from purprd;

--Q. lmembers �����Ϳ��� ���� ���űݾ��� �հ踦 ���� cuspur ���̺��� ������ �� demo ���̺�� 
--����ȣ(custno)�� �������� �����Ͽ� ���
CREATE TABLE cuspur
AS select custno, sum(puramt) puramt_sum
FROM purprd 
GROUP BY custno
ORDER BY custno;

SELECT D.*, C.puramt_sum
FROM demo D, cuspur C
WHERE D.custno = c.custno
order by D.custno;

--[����_1006_1]. purprd �����ͷκ��� �Ʒ� ������ �����ϼ���.
--2�Ⱓ ���� �ݾ��� ���� ������ �и��Ͽ� ����, ���޻纰�� ���ž��� ǥ���ϴ� amt_14, amt_15 ���̺��� 2�� ����(��³���: ����ȣ, ���޻�, sum(���űݾ�))
create table amt_14 as
select * 
from purprd
where purdate < 20150101;

select custno "����ȣ", asso "���޻�", sum(puramt) "���� �Ѿ�"
from amt_14
group by custno, asso
order by custno;

create table amt_15 as
select * 
from purprd
where purdate > 20141231;

select custno "����ȣ", asso "���޻�", sum(puramt) "���� �Ѿ�"
from amt_15
group by custno, asso
order by custno;
--amt14�� amt15 2�� ���̺��� ����ȣ�� ���޻縦 �������� full outer join �����Ͽ� ������ amt_year_foj ���̺� ���� 
create table amt_year_foj as
select amt_14.custno "����ȣ", amt_14.asso "���޻�", sum(amt_14.puramt) "14���� �Ѿ�",sum(amt_15.puramt) "15���� �Ѿ�"
from amt_14 full outer join amt_15 
                on amt_14.custno = amt_15.custno and amt_14.asso = amt_15.asso
where amt_14.custno = amt_15.custno and amt_14.asso = amt_15.asso
group by amt_14.custno, amt_14.asso;

select * from amt_year_foj;
--14�⵵�� 15���� ���űݾ� ���̸� ǥ���ϴ� ���� �÷��� �߰��Ͽ� ���(��, ����ȣ, ���޻纰�� ���űݾ� �� ������ ���еǾ����)
alter table amt_year_foj alter column diff number;

insert into amt_year_foj(diff)
       select sum(amt_14.puramt) - sum(amt_15.puramt) "������", case when (sum(amt_14.puramt) - sum(amt_15.puramt)) < 0 then "����" 


