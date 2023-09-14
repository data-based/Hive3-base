-- 创建分区表
use test;

create table t_china_region(
   code String,
	parent_code String,
	name String,
	province_code String,
	province_name String,
	city_code String,
	city_name String,
	district_code String,
	district_name String
)row format delimited fields terminated by ",";

select * from t_china_region;

select province_code from t_china_region group by province_code;
-- 上海市
-- 北京市
-- 吉林省
-- 广东省
-- 江西省


-- SQL 执行了 MapReduce 程序
select count(0) from t_china_region where province_name = '江西省';



--------------------------------
-- 创建分区表
create table t_china_region_partition_tmp(
   code String,
	parent_code String,
	name String,
	province_code String,
	province_name String,
	city_code String,
	city_name String,
	district_code String,
	district_name String
)partitioned by (province string)
    row format delimited fields terminated by ",";

describe formatted t_china_region_partition_tmp;

select * from t_china_region_partition_tmp
         where province = 'jiangxi';

-- 分区表加载方式
-- Linux 文件，使用local关键字，hdfs文件 不使用 local 关键字
load data local inpath '/home/xiang/txt/partition/jiangxi.txt' into table t_china_region_partition_tmp partition (province='jiangxi');
load data local inpath '/home/xiang/txt/partition/beijing.txt' into table t_china_region_partition_tmp partition(province='beijing');
load data local inpath '/home/xiang/txt/partition/jilin.txt' into table t_china_region_partition_tmp partition(province='jilin');
load data local inpath '/home/xiang/txt/partition/guangdong.txt' into table t_china_region_partition_tmp partition(province='guangdong');
load data local inpath '/home/xiang/txt/partition/shanghai.txt' into table t_china_region_partition_tmp partition(province='shanghai');


-- 分区裁剪
select city_name from t_china_region_partition_tmp
         where province = 'jiangxi' group by city_name;
-- 上饶市
-- 九江市
-- 南昌市
-- 吉安市


select city_name from t_china_region_partition_tmp  group by city_name;

-- 单分区，按省份分区
create table t_china_region_province(
    code String,
	parent_code String,
	name String,
	province_code String,
	province_name String,
	city_code String,
	city_name String,
	district_code String,
	district_name String
) partitioned by (province string)
    row format delimited fields terminated by ",";

-- 二分区，按省份、市区分区
create table t_china_region_city(
    code String,
	parent_code String,
	name String,
	province_code String,
	province_name String,
	city_code String,
	city_name String,
	district_code String,
	district_name String
) partitioned by (province string,city String)
    row format delimited fields terminated by ",";

-- 三分区，按省份、市区,区县分区
create table t_china_region_district(
    code String,
	parent_code String,
	name String,
	province_code String,
	province_name String,
	city_code String,
	city_name String,
	district_code String,
	district_name String
) partitioned by (province string,city String,district String)
    row format delimited fields terminated by ",";


-- 双分区的数据加载，静态分区加载数据
load data local inpath '/home/xiang/txt/partition/guangdong-shenzhen.txt'
    into table t_china_region_city partition (province='guangdong',city='shenzhen');

load data local inpath '/home/xiang/txt/partition/guangdong-guangzhou.txt'
    into table t_china_region_city partition (province='guangdong',city='guangzhou');




------------------------------------------------------------
-- 动态分区

-- 是否开启动态分区功能
set hive.exec.dynamic.partition=true;
-- 指定动态分区模式，分为 nonstick 非严格模式和 strict 严格模式
-- strict 严格模式要求至少一个分区为静态分区
set hive.exec.dynamic.partition.mode=nonstick;

-- 全量数据
select * from t_china_region;


create table t_china_region_part_dynamic(
    code String,
	parent_code String,
	name String,
	province_code String,
	province_name String,
	city_code String,
	city_name String,
	district_code String,
	district_name String
) partitioned by (province string)
    -- row format delimited fields terminated by ","
;

-- 执行动态分区插入
-- 发现了！ 动态分区不支持中文
insert into table t_china_region_part_dynamic partition(province)
select tmp.*,tmp.province_code from t_china_region tmp
--                                where tmp.city_code != ""
-- and tmp.city_name  != ""
-- and tmp.district_name  != ""
-- and tmp.district_code  != ""
;

select * from t_china_region_part_dynamic;

-- 基础查询不使用元数据中的统计信息，而是执行Job
set hive.compute.query.using.stats=false;

select count(0) from t_china_region;
select count(0) from t_china_region tmp where tmp.city_code is not null ;

-- 316
select tmp.*,tmp.province_code from t_china_region tmp where tmp.city_code != ""
and tmp.city_name  != ""
and tmp.district_name  != ""
and tmp.district_code  != "";


select * from t_china_region tmp where tmp.city_code = "";

show create table t_china_region;

select * from t_china_region_part_dynamic;

drop table t_china_region_part_dynamic;