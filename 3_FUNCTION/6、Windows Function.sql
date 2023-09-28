
select * from employee;

----sum+group by普通常规聚合操作------------
select dept,sum(salary) as total from employee group by dept;

----sum+窗口函数聚合操作------------
-- 可以看到具体数据
select id,name,deg,salary,dept,sum(salary) over(partition by dept) as total from employee;

-------窗口函数语法树
-- Function(arg1,..., argn) OVER ([PARTITION BY <...>] [ORDER BY <....>] [<window_expression>])

--其中Function(arg1,..., argn) 可以是下面分类中的任意一个
    --聚合函数：比如sum max avg等
    --排序函数：比如rank row_number等
    --分析函数：比如lead lag first_value等

--OVER [PARTITION BY <...>] 类似于group by 用于指定分组  每个分组你可以把它叫做窗口
--如果没有PARTITION BY 那么整张表的所有行就是一组
--[ORDER BY <....>]  用于指定每个分组内的数据排序规则 支持ASC、DESC
--[<window_expression>] 用于指定每个窗口中 操作的数据范围 默认是窗口中所有行


--2、sum+窗口函数 总共有四种用法 注意是整体聚合 还是累积聚合
--sum(...) over( )对表所有行求和
--sum(...) over( order by ... ) 连续累积求和
--sum(...) over( partition by... ) 同组内所行求和
--sum(...) over( partition by... order by ... ) 在每个分组内，连续累积求和


----------------------建表并且加载数据
create table website_pv_info(
   cookieid string,
   createtime string,   --day
   pv int
) row format delimited
fields terminated by ',';

create table website_url_info (
    cookieid string,
    createtime string,  --访问时间
    url string       --访问页面
) row format delimited
fields terminated by ',';


load data local inpath '/home/xiang/hive/website_pv_info.txt' into table website_pv_info;
load data local inpath '/home/xiang/hive/website_url_info.txt' into table website_url_info;


-- 语法
-- preceding：往前
-- following：往后
-- current row：当前行
-- unbounded：边界
-- unbounded preceding：表示从前面的起点
-- unbounded following：表示到后面的终点


---------------------------------------------------------
---窗口表达式
select cookieid,createtime,pv,
       sum(pv) over(partition by cookieid order by createtime) as pv1  --默认从第一行到当前行
from website_pv_info;
--第一行到当前行（第一行+第二行+...+当前行）
select cookieid,createtime,pv,
       sum(pv) over(partition by cookieid order by createtime rows between unbounded preceding and current row) as pv2
from website_pv_info;



-----窗口排序函数
SELECT
    cookieid,
    createtime,
    pv,
    RANK() OVER(PARTITION BY cookieid ORDER BY pv desc) AS rn1,
    DENSE_RANK() OVER(PARTITION BY cookieid ORDER BY pv desc) AS rn2,
    ROW_NUMBER() OVER(PARTITION BY cookieid ORDER BY pv DESC) AS rn3
FROM website_pv_info
WHERE cookieid = 'cookie1';

-- 注意窗口排序函数不支持窗口表达式
-- 适合 TopN 业务分析

-- row_number：在每个分组中，为每行分配一个从1开始的唯一序列号，递增，不考虑重复；
-- rank: 在每个分组中，为每行分配一个从1开始的序列号，考虑重复，挤占后续位置；
-- dense_rank: 在每个分组中，为每行分配一个从1开始的序列号，考虑重复，不挤占后续位置；
-- +-----------+-------------+-----+------+------+------+
-- | cookieid  | createtime  | pv  | rn1  | rn2  | rn3  |
-- +-----------+-------------+-----+------+------+------+
-- | cookie1   | 2018-04-12  | 7   | 1    | 1    | 1    |
-- | cookie1   | 2018-04-11  | 5   | 2    | 2    | 2    |
-- | cookie1   | 2018-04-16  | 4   | 3    | 3    | 3    |
-- | cookie1   | 2018-04-15  | 4   | 3    | 3    | 4    |
-- | cookie1   | 2018-04-13  | 3   | 5    | 4    | 5    |
-- | cookie1   | 2018-04-14  | 2   | 6    | 5    | 6    |
-- | cookie1   | 2018-04-10  | 1   | 7    | 6    | 7    |
-- +-----------+-------------+-----+------+------+------+



--需求：找出每个用户访问pv最多的Top3 重复并列的不考虑
SELECT * from
    (SELECT
        cookieid,
        createtime,
        pv,
        ROW_NUMBER() OVER(PARTITION BY cookieid ORDER BY pv DESC) AS seq
    FROM website_pv_info) tmp
where tmp.seq <4;


---------------------------------------------------------
-- 窗口排序函数–ntile
--把每个分组内的数据分为3桶
SELECT
    cookieid,
    createtime,
    pv,
    NTILE(3) OVER(PARTITION BY cookieid ORDER BY createtime) AS rn2
FROM website_pv_info
ORDER BY cookieid,createtime;


-----------窗口分析函数----------
--LAG
SELECT cookieid,
       createtime,
       url,
       ROW_NUMBER() OVER(PARTITION BY cookieid ORDER BY createtime) AS rn,
       LAG(createtime,1,'1970-01-01 00:00:00') OVER(PARTITION BY cookieid ORDER BY createtime) AS last_1_time,
       LAG(createtime,2) OVER(PARTITION BY cookieid ORDER BY createtime) AS last_2_time
FROM website_url_info;

--LEAD
SELECT cookieid,
       createtime,
       url,
       ROW_NUMBER() OVER(PARTITION BY cookieid ORDER BY createtime) AS rn,
       LEAD(createtime,1,'1970-01-01 00:00:00') OVER(PARTITION BY cookieid ORDER BY createtime) AS next_1_time,
       LEAD(createtime,2) OVER(PARTITION BY cookieid ORDER BY createtime) AS next_2_time
FROM website_url_info;


--FIRST_VALUE
SELECT cookieid,
       createtime,
       url,
       ROW_NUMBER() OVER(PARTITION BY cookieid ORDER BY createtime) AS rn,
       FIRST_VALUE(url) OVER(PARTITION BY cookieid ORDER BY createtime) AS first1
FROM website_url_info;

--LAST_VALUE
SELECT cookieid,
       createtime,
       url,
       ROW_NUMBER() OVER(PARTITION BY cookieid ORDER BY createtime) AS rn,
       LAST_VALUE(url) OVER(PARTITION BY cookieid ORDER BY createtime) AS last1
FROM website_url_info;
