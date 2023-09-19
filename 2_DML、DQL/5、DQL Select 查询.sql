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
-- 1、查询所有字段
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