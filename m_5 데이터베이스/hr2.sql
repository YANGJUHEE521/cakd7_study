SELECT
    *
FROM employees;

select min(salary), max(salary) from employees;

--보너스를 받는 직원의 %라던가 이런게 중요함 

--부서별 평균 급여 
SELECT job_id, ROUND(avg(salary))
FROM employees
GROUP BY job_id
order by ROUND(avg(salary)) DESC;

--부서의 인원 수로 어떤 부서가 좀 집중적으로 하고있는지
select job_id, count(*)
from employees
group by job_id
order by count(*) DESC;

--근속 연수
-- 날짜
select sysdate from dual;

--근속일수는 현재 날짜에서 - hire_date 빼고, 365로 나누면 일수가 나오겠지
--trunc로 그냥자를게요 
select job_id, trunc((sysdate - hire_date)/365,0) 근속연수 
from employees;

--입사 연도를 봐서 이 회사의 성장률을 알 수 있음 

--Q. HR employees 테이블에서 이름, 연봉 ,10% 인상된 연봉을 출력
select concat(last_name, first_name), salary "연봉", (salary * 1.1) "10% 연봉 인상"
from employees;
-- 이렇게 해도됨
SELECT first_name ||' '|| last_name name, salary, salary*1.1 FROM employees;

--salary 월급이라 치면 
select concat(last_name, first_name), salary * 12 "연봉", (salary * 12 * 1.1) "10% 연봉 인상"
from employees;

--Q. HR employees 테이블에서 COMMISSION_PCT의 UNLL값 갯수를 출력
SELECT COUNT(*)
FROM employees
where commission_pct is null;

--[과제_1006_2] hr 테이블들을 분석해서 전체 현황을 설명할 수 있는 요약 테이블을 2개 이상 작성하세요(예:부서별 평균 salary 순위)
--1 부서별 평균 연봉
create table department_avg_salary as
SELECT d.department_name "부서 이름", ROUND(avg(e.salary)) "평균 연봉"
FROM employees e, departments d
where e.department_id = d.department_id
group by d.department_name
order by ROUND(avg(e.salary)) DESC;

select * from department_avg_salary; 

--2 입사년도를 통한 성장률 파악 
create table grow_year as
select substr(to_char(e.hire_date, 'yyyy-mm-dd'),1,4) "입사년도", count(*) "사원수"
from employees e, dual
where e.EMPLOYEE_ID = e.EMPLOYEE_ID
GROUP BY substr(to_char(e.hire_date, 'yyyy-mm-dd'),1,4) 
order by substr(to_char(e.hire_date, 'yyyy-mm-dd'),1,4);

select * from grow_year; 


--DCL 

--유저 생성, --비밀번호까지 --책 513에 있음 
-- 오라클 학습용 서버에서 권한 줘야함 (잠시 서버 옮기셈) 
CREATE USER c##user01
IDENTIFIED BY userpass;
--기존 유저 나옴 (생겼는지 확인해봐)
select * from all_users;

--유저 삭제
drop user c##user01;

--권한 grant, revoke 책 516에 있음
-- 일단 다시 만들어 
CREATE USER c##user01
IDENTIFIED BY userpass; 
--권한 허가
grant create session, create table to c##user01;
--권한 회수
revoke create session, create table from c##user01;

--사용자 암호 바꾸기 
alter user c##user01 
identified by passuser;
-- passuser로 암호 바뀐거임

--삭제 
--cascade하면 얘랑 관련된 모든게 삭제됨 
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

--시스템상에서 뒤로가기임
-- 작업 중 문제가 발생했을 때, 트랜젝셕의 처리 과정에서 발생한 변경 사항을 취소, 
--이전 commit한 곳까지만 복구
-- 중간에 내가 rollback으로 돌아가고 싶으면 commit 하셈 
rollback; 

drop table users;

-- 모든 작업을 정상적으로 처리하겠다고 확정하는 명령어
commit;

--autocommit 확인 및 설정
show autocommit
set autocommit on;
set autocommit off;
