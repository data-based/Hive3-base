-- 创建数据库
create database if not exists hive
comment "this is my hive db"
with dbproperties ('createBy'='xiang');

-- 查看 hive 数据库
describe database hive ;
desc schema hive;

-- 删除数据库
-- 默认行为是 RESTRICT，意味着数据库为空时，才可以删除。
-- 强制删除可以添加关键字  CASCADE
drop database hive;
create table hive.hive_table(
    id int,
    name String
);


drop database hive cascade ;

-- 修改 数据库关联元数据
-- 更改数据库属性
ALTER database hive set dbproperties ("createBy"="default");
alter database hive set owner user root;
create table hive.test_tb(
    id int
);
-- 修改数据库 HDFS 位置
alter database hive set location 'hdfs://hadoop01:9820/user/hive/warehouse/good.db';

use hive;
select * from hive_table;
insert into hive_table(id, name) VALUES (1,'Hello World');



--------------------------------------------
-- 表操作 PURGE 直接删除，跳过垃圾桶
DROP table hive_table purge ;

-- 修改表相关信息
-- 1、修改表明
alter table hive_table rename to new_hive_table;
alter table new_hive_table rename to hive_table;
-- 2、修改表属性
alter table hive_table set tblproperties ('comment'= 'this is good hive' );

-- 3、更改 serde属性
-- alter table hive_table set serde serde_class_name [WITH SERDEPROPERTIES (property_name=property_valye,...)];
-- alter table hive_table [PARTITION partition_sepc] SET SERDEPROPERTIES serde_class_name;
alter table hive_table SET SERDEPROPERTIES ('filed.delim' = ',');

show create table hive_table;
create table test2(
    id int
);

show create table test2;
alter table test2 SET SERDEPROPERTIES ('filed.delim' = ',');



-- 修改表字段相关信息
-- 添加、替换列
-- 使用 ADD COLUMNS，可以将新列添加到现有列的末尾，但是分区列之前
alter table test2 add columns (name string);
-- replace 修改所有字段
alter table test2 replace columns (id int,name string,age int);
select * from test2;
-- REPLACE COLUMNS 将删从所有现有列，并添加新的列

--------------------------------------------
-- 分区操作
-- 1、新增分区
-- 创建分区表
create table t_partition(
   code String,
	parent_code String,
	name String,
	province_code String,
	province_name String,
	city_code String,
	city_name String,
	district_code String,
	district_name String
)partitioned by (city string)
    row format delimited fields terminated by ",";

-- 加载分区数据
load data local inpath '/home/xiang/txt/partition/beijing.txt' into table t_partition partition (city='beijing');

-- 添加一个分区, 只会在HDFS上，创建于一个这样的文件，但是并没有shu'ju
alter table t_partition add partition (city= 'guangdong')
    location '/user/hive/warehouse/good.db/t_partition/city=guangdong';

-- 重命名分区，
alter table t_partition partition(city='guangdong') rename to partition (city='gd');

-- 删除分区表 会删除分区和数据
alter table t_partition drop if exists partition (city='gd') purge ;

-- 修改分区
-- alter table t_partition partition (city ='beijing') set fileformat ',';
-- alter table t_partition partition (city ='beijing') set location "new location";
