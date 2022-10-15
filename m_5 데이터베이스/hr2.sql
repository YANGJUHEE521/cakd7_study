SELECT
    *
FROM employees;

select min(salary), max(salary) from employees;

--���ʽ��� �޴� ������ %����� �̷��� �߿��� 

--�μ��� ��� �޿� 
SELECT job_id, ROUND(avg(salary))
FROM employees
GROUP BY job_id
order by ROUND(avg(salary)) DESC;

--�μ��� �ο� ���� � �μ��� �� ���������� �ϰ��ִ���
select job_id, count(*)
from employees
group by job_id
order by count(*) DESC;

--�ټ� ����
-- ��¥
select sysdate from dual;

--�ټ��ϼ��� ���� ��¥���� - hire_date ����, 365�� ������ �ϼ��� ��������
--trunc�� �׳��ڸ��Կ� 
select job_id, trunc((sysdate - hire_date)/365,0) �ټӿ��� 
from employees;

--�Ի� ������ ���� �� ȸ���� ������� �� �� ���� 

--Q. HR employees ���̺��� �̸�, ���� ,10% �λ�� ������ ���
select concat(last_name, first_name), salary "����", (salary * 1.1) "10% ���� �λ�"
from employees;
-- �̷��� �ص���
SELECT first_name ||' '|| last_name name, salary, salary*1.1 FROM employees;

--salary �����̶� ġ�� 
select concat(last_name, first_name), salary * 12 "����", (salary * 12 * 1.1) "10% ���� �λ�"
from employees;

--Q. HR employees ���̺��� COMMISSION_PCT�� UNLL�� ������ ���
SELECT COUNT(*)
FROM employees
where commission_pct is null;

--[����_1006_2] hr ���̺���� �м��ؼ� ��ü ��Ȳ�� ������ �� �ִ� ��� ���̺��� 2�� �̻� �ۼ��ϼ���(��:�μ��� ��� salary ����)
--1 �μ��� ��� ����
create table department_avg_salary as
SELECT d.department_name "�μ� �̸�", ROUND(avg(e.salary)) "��� ����"
FROM employees e, departments d
where e.department_id = d.department_id
group by d.department_name
order by ROUND(avg(e.salary)) DESC;

select * from department_avg_salary; 

--2 �Ի�⵵�� ���� ����� �ľ� 
create table grow_year as
select substr(to_char(e.hire_date, 'yyyy-mm-dd'),1,4) "�Ի�⵵", count(*) "�����"
from employees e, dual
where e.EMPLOYEE_ID = e.EMPLOYEE_ID
GROUP BY substr(to_char(e.hire_date, 'yyyy-mm-dd'),1,4) 
order by substr(to_char(e.hire_date, 'yyyy-mm-dd'),1,4);

select * from grow_year; 


--DCL 

--���� ����, --��й�ȣ���� --å 513�� ���� 
-- ����Ŭ �н��� �������� ���� ����� (��� ���� �ű��) 
CREATE USER c##user01
IDENTIFIED BY userpass;
--���� ���� ���� (������� Ȯ���غ�)
select * from all_users;

--���� ����
drop user c##user01;

--���� grant, revoke å 516�� ����
-- �ϴ� �ٽ� ����� 
CREATE USER c##user01
IDENTIFIED BY userpass; 
--���� �㰡
grant create session, create table to c##user01;
--���� ȸ��
revoke create session, create table from c##user01;

--����� ��ȣ �ٲٱ� 
alter user c##user01 
identified by passuser;
-- passuser�� ��ȣ �ٲ����

--���� 
--cascade�ϸ� ��� ���õ� ���� ������ 
drop user c##user01 cascade;

-- 
create table users(
id number,
name varchar2(20),
age number);

insert into users values(0, 'hong gildong', 30);
insert into users values(1, 'hong gildsun', 30);

select * from users;
commit;
delete from users where id=1;

--�ý��ۻ󿡼� �ڷΰ�����
-- �۾� �� ������ �߻����� ��, Ʈ�������� ó�� �������� �߻��� ���� ������ ���, 
--���� commit�� �������� ����
-- �߰��� ���� rollback���� ���ư��� ������ commit �ϼ� 
rollback; 

drop table users;

-- ��� �۾��� ���������� ó���ϰڴٰ� Ȯ���ϴ� ��ɾ�
commit;

--autocommit Ȯ�� �� ����
show autocommit
set autocommit on;
set autocommit off;
