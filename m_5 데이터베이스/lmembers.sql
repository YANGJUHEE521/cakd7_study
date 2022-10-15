--lmembers
SELECT * FROM purprd;
SELECT COUNT(*) FROM PURPRD;
SELECT SUM(PURAMT) FROM PURPRD;
SELECT AVG(PURAMT) FROM PURPRD;

-- 이런식으로 6개를 다 하라하심 
-- PURPRD 영문 

--Q. lmembers purprd 테이블로부터 총 구매액, 2014 구매액, 2015 구매액을 한번에 출력
select (select sum(p1.puramt) from purprd p1) as amt,
(select sum(p2.puramt) from purprd p2 where p2.purdate < 20150101) as amt_2014,
(select sum(p3.puramt) from purprd p3 where p3.purdate > 20141231) as amt_2015
from dual;

--또는 ! 
select sum(puramt) 총구매액, 
sum(case when purdate <= '20141231' then puramt end) "2014 구매액", 
sum(case when purdate > '20141231' and purdate <= '20151231' then puramt end) "2015 구매액"
from purprd;

--Q. lmembers 데이터에서 고객별 구매금액의 합계를 구한 cuspur 테이블을 생성한 후 demo 테이블과 
--고객번호(custno)를 기준으로 결합하여 출력
CREATE TABLE cuspur
AS select custno, sum(puramt) puramt_sum
FROM purprd 
GROUP BY custno
ORDER BY custno;

SELECT D.*, C.puramt_sum
FROM demo D, cuspur C
WHERE D.custno = c.custno
order by D.custno;

--[과제_1006_1]. purprd 데이터로부터 아래 사항을 수행하세요.
--2년간 구매 금액을 연간 단위로 분리하여 고객별, 제휴사별로 구매액을 표시하는 amt_14, amt_15 테이블을 2개 생성(출력내용: 고객번호, 제휴사, sum(구매금액))
create table amt_14 as
select * 
from purprd
where purdate < 20150101;

select custno "고객번호", asso "제휴사", sum(puramt) "구매 총액"
from amt_14
group by custno, asso
order by custno;

create table amt_15 as
select * 
from purprd
where purdate > 20141231;

select custno "고객번호", asso "제휴사", sum(puramt) "구매 총액"
from amt_15
group by custno, asso
order by custno;
--amt14와 amt15 2개 테이블을 고객번호와 제휴사를 기준으로 full outer join 적용하여 결합한 amt_year_foj 테이블 생성 
create table amt_year_foj as
select amt_14.custno "고객번호", amt_14.asso "제휴사", sum(amt_14.puramt) "14구매 총액",sum(amt_15.puramt) "15구매 총액"
from amt_14 full outer join amt_15 
                on amt_14.custno = amt_15.custno and amt_14.asso = amt_15.asso
where amt_14.custno = amt_15.custno and amt_14.asso = amt_15.asso
group by amt_14.custno, amt_14.asso;

select * from amt_year_foj;
--14년도와 15년의 구매금액 차이를 표시하는 증감 컬럼을 추가하여 출력(단, 고객번호, 제휴사별로 구매금액 및 증감이 구분되어야함)
alter table amt_year_foj alter column diff number;

insert into amt_year_foj(diff)
       select sum(amt_14.puramt) - sum(amt_15.puramt) "증감액", case when (sum(amt_14.puramt) - sum(amt_15.puramt)) < 0 then "증가" 


