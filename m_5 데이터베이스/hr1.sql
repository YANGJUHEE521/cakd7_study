select * from employees;


select last_name, 'is a' job_id from employees;

-- 두개의 칼럼이 있을때, 연결해서 새로운 칼럼을 만들때 ! 
-- 연결연산자 ( || ) :칼럼을 연결해서 출력 
select last_name || 'is a' || job_id from employees;

select last_name || ' is a ' || job_id explain from employees;

select last_name || ' ' || first_name 이름 from employees;

--python unique랑 같음 중복제거하고 
select distinct job_id from employees;

select * from employees where commission_pct is null;

--Q. employees 테이블에서 commission_pct의 null 값 객수를 출력 
select count(*) from employees where commission_pct is null;

--Q. employees 테이블에서 employee_id가 홀수인것만 출력
select * from employees where mod(employee_id, 2) = 1;

--둘째자리까지 나타내고 올려라
select round(355.95555,2) from dual; --355.96
select round(355.95555,0) from dual; --1의 자리까지 남기고 올려라
select round(355.95555,-2) from dual; --백의 자리까지 남기고 올려라
select trunc(45.5551,1) from dual;


select last_name, trunc(salary/12,2) 월급 from employees;

--width_bucket(지정값, 최소값, 최대값, bucket갯수)
-- 지정값이 몇번째 bucket에 존재하냐? 이거임 
select width_bucket(92, 0, 100, 10) from dual;
select width_bucket(38, 0, 100, 50) from dual;

select upper('hello World') from dual;
select lower('hello WOrLd') from dual;

select last_name, salary from employees where lower(last_name)='king';

select job_id, length(job_id) from employees;

-- 3번째부터 3개 
select substr('Hello World',3,3) from dual;
--뒤에서 3번째부터 3개 
select substr('Hello World',-3,3) from dual;

-- 전체자리수가 20이 돼야하고, 비어있는곳은 #으로 채워 왼쪽부터(l)
select lpad('Hello World',20,'#') from dual;
select rpad('Hello World',20,'#') from dual;

--특정 값 , 혹은 공백 제거 
select last_name, trim('A' from last_name) A삭제 from employees;
select ltrim('aaaHello Worldaaa', 'a') from dual;
select rtrim('aaaHello Worldaaa', 'a') from dual;
select trim('  Hello World  ') from dual;
select ltrim('  Hello World  ') from dual;
select rtrim('  Hello World  ') from dual;

-- 날짜
select sysdate from dual;

--근속일수는 현재 날짜에서 - hire_date 빼고, 365로 나누면 일수가 나오겠지
select * from employees;
--trunc로 그냥자를게요 
select last_name, trunc((sysdate - hire_date)/365,0) 근속연수 from employees;

--창훈, 유한님 
--과제 1005_1. employees 테이블에서 채용일에 6개월을 추가한 날짜를 last_name과 같이 출력
-- 일수로다가 조지는거네 
select last_name, hire_date, (hire_date + 180) "채용일 + 6개월"
from employees;
select last_name, add_months(hire_date,6), hire_date from employees;
--과제 1005_2. 이번달의 말일을 반환하는 함수를 사용하여 말일을 출력
select last_day(sysdate) from dual;
--과제 1005_3. employees 테이블에서 채용일과 현재시점간의 근속월수를 출력
select hire_date, trunc((sysdate - hire_date)/365,0) "근속월수"
from employees;
select hire_date, trunc(months_between(sysdate,hire_date)) 근속월수 from employees;
--과제 1005_4. 입사일 6개월 후 첫번째 월요일을 last_name별로 출력
select last_name, next_day(hire_date+180, '월요일') from employees; 
--과제 1005_5. job_id별로 연봉합계 연봉평균 최고연봉 최저연봉 출력 단, 평균연봉이 5000 이상인 경우만 포함하여 내림차순으로 정렬
select job_id, sum(salary) 연봉합계, avg(salary) 연봉평균, max(salary) 최고연봉, min(salary) 최저연봉
from employees
where job_id=job_id
group by job_id
having avg(salary) >= 5000 
order by avg(salary) desc;
--과제 1005_6. 사원번호(employee_id)가 110인 사원의 부서명을 출력
select * from departments;
select * from employees;

select d.department_name
from departments d
where d.department_id = (select e.department_id from employees e where e.employee_id = 110);
--과제 1005_7. 사번이 120번인 직원의 사번, 이름, 업무(job_id), 업무명(job_title)을 출력
select * from jobs;

select e.employee_id 사번, e.first_name||'_'||e.last_name 이름, e.job_id 업무, j.job_title 업무명 
from employees e, jobs j 
where e.employee_id=120 and e.job_id=j.job_id;

--과제 1005_8. 사번, 이름, 직급, 출력하세요. 단, 직급은 아래 기준에 의함
        --salary > 20000 then '대표이사'
        --salary > 15000 then '이사' 
        --salary > 10000 then '부장' 
        --salary > 5000 then '과장' 
        --salary > 3000 then '대리'
        --나머지 '사원'
select employee_id 사번, first_name||'_'||last_name 이름, 
case when salary > 20000 then '대표이사'
when salary > 15000 then '이사'
when salary > 10000 then '부장'
when salary > 5000 then '과장'
when salary > 3000 then '대리'
else '사원'
end 직급 from employees;
--과제 1005_9. employees 테이블에서 employee_id와 salary만 추출해서 employee_salary 테이블을 생성하여 출력
create table employee_salary as
select employee_id, salary
from employees
order by employee_id;

desc employee_salary;
--과제 1005_10. employee_salary 테이블에 first_name, last_name 컬럼을 추가한 후, name으로 변경하여 출력
alter table employee_salary 
add first_name varchar2(20)
add last_name VARCHAR2(20);

update employee_salary es 
set first_name = 
(select first_name from employees e where es.employee_id = e.employee_id),
last_name = (select last_name from employees e where es.employee_id = e.employee_id);

select * from employee_salary;

select employee_id,salary,first_name||' '||last_name name from employee_salary;

--과제 1005_11. employee_salary 테이블의 employee_id에 기본키를 적용하고, constraint_name을 KS_PK로 지정 후 출력
alter table employee_salary add CONSTRAINT KS_PK PRIMARY key(employee_id);
desc employee_salary;
--과제 1005_12. employee_salary 테이블의 employee_id에서 contraint_name을 삭제 후 삭제 여부를 확인
alter table employee_salary drop CONSTRAINT KS_PK;
select * from all_constraints where table_name='employee_salary';

drop table employee_salary;
