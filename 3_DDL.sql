-- 查询指定表的元数据信息
describe formatted h_user;

-- 删除表
-- 外部表只删除元数据，内部表删除元数据和数据
drop table h_user;

-- hadoop 的 hdfs 有垃圾桶动作
-- [purge] 参数直接跳过垃圾桶 直接删除
drop table if exists h_user purge;

-- 清空表
truncate table h_user;

-- 修改表
alter table h_user rename to new_h_user;
-- 修改表属性
alter table h_user set tblproperties ('comment'='new comment for user table');
-- 更改 SerDe 属性
-- alter table h_user set serde serde_class_name [WITH SERDEPROPERTIES (property_name = property_value, ...)];
-- alter table h_user [partition partition_sepc] unset serdeproperties  (property_name = property_value, ...);
-- 修改文件格式
alter table h_user set fileformat file_format;
-- 修改文件位置
alter table h_user set location "new localtion";

-- 更改列明、类型、位置、注释
drop table test_change purge;
select * from test_change;
create table test_change(a int, b int ,c int);
-- a b c 变为 a1 b c   a 变为 a1
alter table test_change change a a1 int;
-- a1 变为 a2  a2 b c 然后  把 a2 放到 c 的后面
alter table test_change change a1 a2 string after c;
-- c 换成 c1
alter table test_change change c c1 int first;

-- 添加 新增列
alter table test_change add columns (d int , e int);
-- 替换列 会删除原先所有的列
alter table test_change replace columns (d int ,f string);


-- 分区 DDL 操作
drop table if exists t_user_province;
-- path:/user/hive/warehouse/xiang.db/t_user_province
create table t_user_province(
    num int,
    name string,
    sex string,
    age int,
    dept string
 )partitioned by (province string);

select * from t_user_province;

alter table test_change add partition (d='1') location '/user/hadoop/warehouse/test_change/d=1';


-- 删除分区
alter table test_change drop partition (d='2008-08-08',f='us');
-- purge 直接删除不进垃圾桶
alter table test_change drop partition (d='2008-08-08',f='us') purge;



-- MSCK Partition 背景
-- Hive 将每个表的分区列表信息存储在其 metastore 中。但是，如果将新分区直接添加到 HDFS 中直接删除分区文件。
-- MSCK 是 metastroe check 的缩写，表示 元数据检查，可用于元数据的修复
-- 修复分区
-- MSCK [REPAIR] TABLE table_name [ADD/DROP/SYNC PARTITIONS]

-- 格式上模仿 Hive，但是直接查询是无法查询到的
msck repair table test_change add partitions ;