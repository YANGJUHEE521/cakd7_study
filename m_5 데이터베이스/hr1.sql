select * from employees;


select last_name, 'is a' job_id from employees;

-- �ΰ��� Į���� ������, �����ؼ� ���ο� Į���� ���鶧 ! 
-- ���Ῥ���� ( || ) :Į���� �����ؼ� ��� 
select last_name || 'is a' || job_id from employees;

select last_name || ' is a ' || job_id explain from employees;

select last_name || ' ' || first_name �̸� from employees;

--python unique�� ���� �ߺ������ϰ� 
select distinct job_id from employees;

select * from employees where commission_pct is null;

--Q. employees ���̺��� commission_pct�� null �� ������ ��� 
select count(*) from employees where commission_pct is null;

--Q. employees ���̺��� employee_id�� Ȧ���ΰ͸� ���
select * from employees where mod(employee_id, 2) = 1;

--��°�ڸ����� ��Ÿ���� �÷���
select round(355.95555,2) from dual; --355.96
select round(355.95555,0) from dual; --1�� �ڸ����� ����� �÷���
select round(355.95555,-2) from dual; --���� �ڸ����� ����� �÷���
select trunc(45.5551,1) from dual;


select last_name, trunc(salary/12,2) ���� from employees;

--width_bucket(������, �ּҰ�, �ִ밪, bucket����)
-- �������� ���° bucket�� �����ϳ�? �̰��� 
select width_bucket(92, 0, 100, 10) from dual;
select width_bucket(38, 0, 100, 50) from dual;

select upper('hello World') from dual;
select lower('hello WOrLd') from dual;

select last_name, salary from employees where lower(last_name)='king';

select job_id, length(job_id) from employees;

-- 3��°���� 3�� 
select substr('Hello World',3,3) from dual;
--�ڿ��� 3��°���� 3�� 
select substr('Hello World',-3,3) from dual;

-- ��ü�ڸ����� 20�� �ž��ϰ�, ����ִ°��� #���� ä�� ���ʺ���(l)
select lpad('Hello World',20,'#') from dual;
select rpad('Hello World',20,'#') from dual;

--Ư�� �� , Ȥ�� ���� ���� 
select last_name, trim('A' from last_name) A���� from employees;
select ltrim('aaaHello Worldaaa', 'a') from dual;
select rtrim('aaaHello Worldaaa', 'a') from dual;
select trim('  Hello World  ') from dual;
select ltrim('  Hello World  ') from dual;
select rtrim('  Hello World  ') from dual;

-- ��¥
select sysdate from dual;

--�ټ��ϼ��� ���� ��¥���� - hire_date ����, 365�� ������ �ϼ��� ��������
select * from employees;
--trunc�� �׳��ڸ��Կ� 
select last_name, trunc((sysdate - hire_date)/365,0) �ټӿ��� from employees;

--â��, ���Ѵ� 
--���� 1005_1. employees ���̺��� ä���Ͽ� 6������ �߰��� ��¥�� last_name�� ���� ���
-- �ϼ��δٰ� �����°ų� 
select last_name, hire_date, (hire_date + 180) "ä���� + 6����"
from employees;
select last_name, add_months(hire_date,6), hire_date from employees;
--���� 1005_2. �̹����� ������ ��ȯ�ϴ� �Լ��� ����Ͽ� ������ ���
select last_day(sysdate) from dual;
--���� 1005_3. employees ���̺��� ä���ϰ� ����������� �ټӿ����� ���
select hire_date, trunc((sysdate - hire_date)/365,0) "�ټӿ���"
from employees;
select hire_date, trunc(months_between(sysdate,hire_date)) �ټӿ��� from employees;
--���� 1005_4. �Ի��� 6���� �� ù��° �������� last_name���� ���
select last_name, next_day(hire_date+180, '������') from employees; 
--���� 1005_5. job_id���� �����հ� ������� �ְ��� �������� ��� ��, ��տ����� 5000 �̻��� ��츸 �����Ͽ� ������������ ����
select job_id, sum(salary) �����հ�, avg(salary) �������, max(salary) �ְ���, min(salary) ��������
from employees
where job_id=job_id
group by job_id
having avg(salary) >= 5000 
order by avg(salary) desc;
--���� 1005_6. �����ȣ(employee_id)�� 110�� ����� �μ����� ���
select * from departments;
select * from employees;

select d.department_name
from departments d
where d.department_id = (select e.department_id from employees e where e.employee_id = 110);
--���� 1005_7. ����� 120���� ������ ���, �̸�, ����(job_id), ������(job_title)�� ���
select * from jobs;

select e.employee_id ���, e.first_name||'_'||e.last_name �̸�, e.job_id ����, j.job_title ������ 
from employees e, jobs j 
where e.employee_id=120 and e.job_id=j.job_id;

--���� 1005_8. ���, �̸�, ����, ����ϼ���. ��, ������ �Ʒ� ���ؿ� ����
        --salary > 20000 then '��ǥ�̻�'
        --salary > 15000 then '�̻�' 
        --salary > 10000 then '����' 
        --salary > 5000 then '����' 
        --salary > 3000 then '�븮'
        --������ '���'
select employee_id ���, first_name||'_'||last_name �̸�, 
case when salary > 20000 then '��ǥ�̻�'
when salary > 15000 then '�̻�'
when salary > 10000 then '����'
when salary > 5000 then '����'
when salary > 3000 then '�븮'
else '���'
end ���� from employees;
--���� 1005_9. employees ���̺��� employee_id�� salary�� �����ؼ� employee_salary ���̺��� �����Ͽ� ���
create table employee_salary as
select employee_id, salary
from employees
order by employee_id;

desc employee_salary;
--���� 1005_10. employee_salary ���̺� first_name, last_name �÷��� �߰��� ��, name���� �����Ͽ� ���
alter table employee_salary 
add first_name varchar2(20)
add last_name VARCHAR2(20);

update employee_salary es 
set first_name = 
(select first_name from employees e where es.employee_id = e.employee_id),
last_name = (select last_name from employees e where es.employee_id = e.employee_id);

select * from employee_salary;

select employee_id,salary,first_name||' '||last_name name from employee_salary;

--���� 1005_11. employee_salary ���̺��� employee_id�� �⺻Ű�� �����ϰ�, constraint_name�� KS_PK�� ���� �� ���
alter table employee_salary add CONSTRAINT KS_PK PRIMARY key(employee_id);
desc employee_salary;
--���� 1005_12. employee_salary ���̺��� employee_id���� contraint_name�� ���� �� ���� ���θ� Ȯ��
alter table employee_salary drop CONSTRAINT KS_PK;
select * from all_constraints where table_name='employee_salary';

drop table employee_salary;
