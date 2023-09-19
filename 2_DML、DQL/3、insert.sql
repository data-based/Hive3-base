use test;

-- 创建一张表
create table t_test_insert(
    id String,
    name String
) partitioned by (buildNo String);
select * from t_test_insert;

select * from t_student_hdfs_partition;
insert into t_test_insert(id, name, buildNo)  select id,name,buildno from t_student_hdfs_partition;

insert into t_test_insert select id,name,buildno from t_student_hdfs_partition;
insert overwrite table t_test_insert select id,name,buildno from t_student_hdfs_partition;

select * from t_test_insert;
show partitions t_test_insert;

----------------------------------------
-- multiple inserts  多重插入，一次扫描，多次插入（减少扫描次数）
-- 创建新表
create table t_student_insert1(id String);
create table t_student_insert2(name String);

-- 将 t_student_hdfs 的 id 放到 t_student_insert1.id中，name 放到 t_student_insert2.name
insert into t_student_insert1 select id from t_student_hdfs;
insert into t_student_insert2 select name from t_student_hdfs;

-- 从性能角度，效率较低
-- 语法顺序颠倒了
from t_student_hdfs
insert overwrite table t_student_insert1
select id
insert overwrite table t_student_insert2
select name;



----------------------------------------
-- dynamic partition insert 动态分区插入

-- 配置参数
-- hive.exec.dynamic.partition = true
-- hive.exec.dynamic.partition.mode = nonstrict
-- static、nonstrict 两种模式，static为严格模式，要求表至少要1个静态分区。

set hive.exec.dynamic.partition;
set hive.exec.dynamic.partition.mode;
set hive.exec.dynamic.partition.mode = nonstrict;




----------------------------------------
-- Directory 导出数据
select * from t_student_hdfs;
-- 导出数据到 HDFS：/data/hive/t_student_hdfs/e1
-- 没有指定分隔符，默认 '/001'
insert overwrite directory '/data/hive/t_student_hdfs/e1' select * from t_student_hdfs where city = '赣州';

insert overwrite directory '/data/hive/t_student_hdfs/e2' row format delimited fields terminated by "," select * from t_class where city = '南昌';


use test;
