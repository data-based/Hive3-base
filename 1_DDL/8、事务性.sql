use test;
--1、开启事务配置（可以使用set设置当前session生效 也可以配置在hive-site.xml中）
set hive.support.concurrency = true; --Hive是否支持并发
set hive.enforce.bucketing = true; --从Hive2.0开始不再需要  是否开启分桶功能
set hive.exec.dynamic.partition.mode = nonstrict; --动态分区模式  非严格
set hive.txn.manager = org.apache.hadoop.hive.ql.lockmgr.DbTxnManager; --
set hive.compactor.initiator.on = true; --是否在Metastore实例上运行启动压缩合并
set hive.compactor.worker.threads = 1; --在此metastore实例上运行多少个压缩程序工作线程。

-- 非事务会话，是无法修改数据的
insert into xiang.student(id, name) VALUES (1,'Hello');
update xiang.student set name ='good' where id = 1;
--  [Error 10294]:
--  Attempt to do update or delete using transaction manager that does not support these operations.


-- 创建事务表
-- 只有在当前会话开启了 事务配置的时候，才可以创建
create table trans_student(
    id int,
    name String,
    age int
)clustered by (id) into 2 buckets
stored as orc TBLPROPERTIES ('transactional'='true');


insert into trans_student(id, name, age) values (1, 'xiaoxiao', 20);
select * from trans_student;
-- 支持事务
update trans_student set age = 18 where id = 1;

select * from trans_student;