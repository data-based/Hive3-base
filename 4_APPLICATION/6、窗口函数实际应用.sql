-- 二、窗口函数的实际应用场景
-- 1、示例-连续登录用户
-- 基于以上的需求根据数据寻找规律，要想得到连续登录用户，找到两个相同用户ID的行之间登录日期之间的关系。
-- 例如：统计连续登录两天的用户，只要用户ID相等，并且登录日期之间相差1天即可。

create table tb_login(
     userid string,
     logintime string
)
row format delimited fields terminated by ',';
load data local inpath "/home/xiang/hive/tb_login.txt" into table tb_login;

select * from tb_login;
-- +------------------+---------------------+
-- | tb_login.userid  | tb_login.logintime  |
-- +------------------+---------------------+
-- | A                | 2021-03-22          |
-- | B                | 2021-03-22          |
-- | C                | 2021-03-22          |
-- | A                | 2021-03-23          |
-- | C                | 2021-03-23          |
-- | A                | 2021-03-24          |
-- | B                | 2021-03-24          |
-- +------------------+---------------------+

-- 方案一：Sept.1、表中的数据自连接，构建笛卡尔积，条件是用户相同
drop table if exists tb_login_tmp;
create table tb_login_tmp as
select
    a.userid as a_userid,
    a.logintime as a_logintime,
    b.userid as b_userid,
    b.logintime as b_logintime
from tb_login a,tb_login b
where a.userid = b.userid;


select * from tb_login_tmp;

-- Sept.2、过滤数据，用户id相同，并且登录日期差一天
select
    distinct a_userid
from tb_login_tmp
where a_userid = b_userid
  and cast(substr(a_logintime,9,2) as int) - 1 = cast(substr(b_logintime,9,2) as int);
-- 这里不用考虑 + 、 - 问题，因为笛卡儿积会两种结果都纳入进去



-- 方案二：Sept.1、使用窗口函数来实现
-- 1、窗口函数lead
-- 用于从当前数据中基于当前行的数据向后偏移取值
--语法
-- lead(colName，N，defautValue)
--colName：取哪一列的值
--N：向后偏移N行
--defaultValue：如果取不到返回的默认值


--实现连续登录2天
with t1 as (
    select
        userid,
        logintime,
        --本次登录日期的第二天
        date_add(logintime,1) as nextday,
        --按照用户id分区，按照登录日期排序，取下一次登录时间，取不到就为0
        lead(logintime,1,0) over (partition by userid order by logintime) as nextlogin
    from tb_login )
select distinct userid from t1 where nextday = nextlogin;

--实现连续3天登录
with t1 as (
    select
        userid,
        logintime,
        --本次登录日期的第三天
        date_add(logintime,2) as nextday,
        --按照用户id分区，按照登录日期排序，取下下一次登录时间，取不到就为0
        lead(logintime,2,0) over (partition by userid order by logintime) as nextlogin
    from tb_login )
select * from t1 where nextday = nextlogin;


with t1 as (
    select
        userid,
        logintime,
        --本次登录日期的第三天
        date_add(logintime,10) as nextday,
        --按照用户id分区，按照登录日期排序，取下下一次登录时间，取不到就为0
        lead(logintime,10,0) over (partition by userid order by logintime) as nextlogin
    from tb_login )
select * from t1;



-----------------------------------------
--  示例-级联累加求和
--1、建表加载数据
create table tb_money(
     userid string,
     mth string,
     money int
)
row format delimited fields terminated by ',';

load data local inpath '/home/xiang/hive/tb_money.txt' into table tb_money;
select * from tb_money;

--2、统计得到每个用户每个月的消费总金额
create table tb_money_mtn as
select
    userid,
    mth,
    sum(money) as m_money
from tb_money
group by userid,mth;
select * from tb_money_mtn;

-- 需求3、统计每个用户每个月的消费总金额及当前累计消费总金额
--方案一：自连接分组聚合
--1、基于每个用户每个月的消费总金额进行自连接
select a.*,b.*
from tb_money_mtn a
join tb_money_mtn b on a.userid = b.userid;

--2、将每个月之前月份的数据过滤出来
select a.*,b.*
from tb_money_mtn a
join tb_money_mtn b on a.userid = b.userid
where  b.mth <= a.mth;

--3、同一个用户 同一个月的数据分到同一组  再根据用户、月份排序
select
    a.userid,
    a.mth,
       max(a.m_money) as current_mth_money,  --当月花费
       sum(b.m_money) as accumulate_money    --累积花费
from tb_money_mtn a join tb_money_mtn b on a.userid = b.userid
where b.mth <= a.mth
group by a.userid,a.mth
order by a.userid,a.mth;

--方案二：窗口函数实现
--统计每个用户每个月消费金额及累计总金额
select
    userid,
    mth,
    m_money,
    sum(m_money) over (partition by userid order by mth) as t_money
from tb_money_mtn;

--实现近几个月的累计消费金额
select
    userid,
    mth,
    m_money,
    sum(m_money) over (partition by userid order by mth rows between 1 preceding and 2 following) as t_money
from tb_money_mtn;


-- set hive.exec.parallel=true;              //打开任务并行执行
-- set hive.exec.parallel.thread.number=16;  //同一个sql允许最大并行度，默认为8。



---------------------------
-- 3、示例-topN
-- TopN函数：row_number、rank、dense_rank
-- row_number：对每个分区的数据进行编号，如果值相同，继续编号
-- rank：对每个分区的数据进行编号，如果值相同，编号相同，但留下空位
-- dense_rank：对每个分区的数据进行编号，如果值相同，编号相同，不留下空位
-- 基于row_number实现，按照部门分区，每个部门内部按照薪水降序排序


create table tb_emp(
    empno string,
    ename string,
    job string,
    managerid string,
    hiredate string,
    salary double,
    bonus double,
    deptno string
)
row format delimited fields terminated by ',';
load data local inpath '/home/xiang/hive/tb_emp.txt' into table tb_emp;
select * from tb_emp;

--基于row_number实现，按照部门分区，每个部门内部按照薪水降序排序
select
    empno,
    ename,
    salary,
    deptno,
    row_number() over (partition by deptno order by salary desc) as rn
from tb_emp;

--过滤每个部门的薪资最高的前两名
with t1 as (
    select
        empno,
        ename,
        salary,
        deptno,
        row_number() over (partition by deptno order by salary desc) as rn
    from tb_emp )
select * from t1 where rn < 3;
