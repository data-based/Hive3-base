---------------------------------------------------------------
-- 数据准备


set hive.compute.query.using.stats=false;
select * from t_china_region;

drop table t_china_region_p_c purge ;
-- 创建分区，先根据province分区，再根据city分区
create table if not exists  t_china_region_p_c(
    code String,
    parent_code String,
    name String,
    province_name String,
    city_name String,
    district_code String,
    district_name String
)partitioned by (province_code String,city_code String)
row format delimited fields terminated by ",";

-- 使用动态分区将数数据插入到 t_china_region_p_c 分区表中
set hive.exec.dynamic.partition.mode = nonstrict;

insert into table t_china_region_p_c partition (province_code,city_code)
select code,parent_code,name,province_name,city_name,district_code,district_name,parent_code,city_code from t_china_region;


---------------------------------------------------------------
-- 聚合查询
select * from t_china_region_p_c;
-- 查询匹配正则表达式所有字段
set hive.support.quoted.identifiers = none; -- 反引号不再解释为其他含义
-- 查询所有 c为开头的字段
select `^c.*` from t_china_region_p_c;

-- 查询当前数据库
select current_database();
select count(city_code) from t_china_region_p_c;

-- 2、 ALL DISTINCT
select distinct city_name from t_china_region_p_c;
select city_name, count(city_name) as cnt from t_china_region_p_c group by city_name having cnt>11;

select * from t_china_region_p_c where length(district_name) > 6;

select city_name, count(city_name) as cnt from t_china_region_p_c where city_name = '上海市' group by city_name having cnt>11;

select * from t_china_region_p_c where province_code = '3601' order by code limit 5,3;

-- 执行顺序
-- from > where > group > hiving > order > select

use test;
select * from t_class;

create table if not exists  t_class_p_b(
    id String,
    name String,
    province String,
    highSchool String,
    city String,
    country String,
    address String
)partitioned by (buildNo String,buildRoom String)
row format delimited fields terminated by ",";

-- 使用动态分区将数数据插入到 t_china_region_p_c 分区表中
set hive.exec.dynamic.partition.mode = nonstrict;

insert into table t_class_p_b partition (buildNo,buildRoom)
select id,name,province,highSchool,city,country,address,buildno,buildRoom from t_class;

select * from t_class_p_b where name = '李名真';


---------------------------------------------------------------
-- ORDER BY
-- 查看 reduce 分区情况
set mapreduce.job.reduces;
set mapreduce.job.reduces = 2;
select * from t_class_p_b cluster by id;

-- 1、order by 全局排序，因此只有一个 reduce，结果输出再一个文件中，当输入规模大时，需要较长的计算时间
-- 2、distribute by 根据指定字段将数据分组，算法是 hash 散列，sort by 是在分组后，每个组内排序
-- 3、cluster by 既有分组，又有排序，但是两个字段只能为同一个字段
-- 如果 distribute 和 sort 的字段是同一个 此时，cluster = distribute + cluster

---------------------------------------------------------------
-- UNION 联合查询
-- 要保证查询结果一致
show tables;
select * from t_student_hdfs_partition;

-- 会删除重复行
select id,name from t_student_hdfs
union
select id,name from  t_student_hdfs_partition;

-- 和上面保持一致
select id,name from t_student_hdfs
union distinct
select id,name from  t_student_hdfs_partition;

-- 不删除重复行
select id,name from t_student_hdfs
union all
select id,name from  t_student_hdfs_partition;


select id,name from (select id,name from t_student_hdfs limit 2) tmp1
union
select id,name from (select id,name from t_student_hdfs_partition limit 3) tmp2




---------------------------------------------------------------
-- CTE 表达式
-- 公共表达式（CTE）是一个临时结果集，改结果集从 WITH 字句中指定的简单查询派生而来的，紧接着在 SELECT 或 INSERT 关键字之前
-- CTE 仅支在单个语句的执行范围内定义
-- CTE 可以在 SELECT、INSERT、 CREATE TABLE AS SELECT 或  CREATE VIEW AS SELECT 语句中使用
with q1 as (select name,buildRoom from t_student_hdfs)
select name from q1;

-- chaining CETs 模式
with q1 as (select name,buildRoom from t_student_hdfs),
     q2 as (select name from q1)
select * from (select * from q2) a;

-- union
with q1 as ( select * from t_student_hdfs where id = '201700001127'),
     q2 as ( select * from t_student_hdfs where id = '201700001138' )
select *
from q1 union all select * from q2;

-- 试图，CTAS 和插入语句中的 CTE
create table s1 like t_student;

with q1 as ( select * from t_student_hdfs where id = '201700001127' )
insert overwrite table s1 select * from q1;

create table s2 as
    with q1 as ( select * from t_student_hdfs where id = '201700001127' )
    select *
    from q1;

create view v1 as
    with q1 as ( select * from t_student_hdfs where id = '201700001127' )
select * from q1;

select * from v1;
show create table v1;

select * from s2;
select * from s1;
show create table s1;