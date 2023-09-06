--Hive中事务表的创建使用
--1、开启事务配置（可以使用set设置当前session生效 也可以配置在hive-site.xml中）
set hive.support.concurrency = true; --Hive是否支持并发
set hive.enforce.bucketing = true; --从Hive2.0开始不再需要  是否开启分桶功能
set hive.exec.dynamic.partition.mode = nonstrict; --动态分区模式  非严格
set hive.txn.manager = org.apache.hadoop.hive.ql.lockmgr.DbTxnManager; --
set hive.compactor.initiator.on = true; --是否在Metastore实例上运行启动压缩合并
set hive.compactor.worker.threads = 1; --在此metastore实例上运行多少个压缩程序工作线程。

create table trans_student(
    id int,
    name String,
    age int
)clustered by (id) into 2 buckets stored as orc
TBLPROPERTIES ('transactional'='true');

insert into trans_student values (2,"Coco",18);
select * from trans_student;
update trans_student set age=20 where name="allen";

explain select * from trans_student;

-- 使用了 mapreduce
select name,count(0) from trans_student group by name;

explain select name,count(0) from trans_student group by name;

-- 创建物化视图
create materialized view trans_name_student
as  select name,count(0) from trans_student group by name;

show materialized views ;

-- 禁用物化视图
alter materialized view trans_name_student disable rewrite ;