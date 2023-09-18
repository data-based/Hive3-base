------- load 语法规则

show databases ;

-- 创建表 用于演示从本地加载数据
create table t_student(id String,name String,politicStatus String,buildNo String,buildRoom String,city String,Country String) comment "2018级170102班信息" row format delimited fields terminated by ",";
-- 演示 HDFS 加载数据
create table t_student_hdfs(id String,name String,politicStatus String,buildNo String,buildRoom String,city String,Country String) row format delimited fields terminated by ",";
-- 演示 分区加载数据
create table t_student_hdfs_partition(id String,name String,politicStatus String,buildNo String,buildRoom String,city String,Country String) partitioned by (build String) row format delimited fields terminated by ",";

-- 将 student.txt 上传到 Hadoop01 节点（Hive所在服务器） /home/xiang/hive/students.txt
-- 引用本地文件，需要加上 LOCAL 关键字
load data local inpath '/home/xiang/hive/students.txt' overwrite into table t_student;

-- 当不指定 local 时候，使用了移动操作，将原先 studnet 表下的数据，移动到 t_student_hdfs 表下
load data inpath '/user/hive/warehouse/test.db/t_student/students.txt' into table t_student_hdfs;



select * from t_student_hdfs;
select * from t_student;
select * from t_student_hdfs_partition;

-- 创建物化视图，对 student 进行分区
create table t_student_build_c1 row format delimited fields terminated by ","
as select * from t_student_hdfs where buildNo = 'C1';

create table t_student_build_B11 row format delimited fields terminated by ","
as select * from t_student_hdfs where buildNo = 'B11';

create table t_student_build_A14 row format delimited fields terminated by ","
as select * from t_student_hdfs where buildNo = 'A14';

drop table t_student_hdfs_partition purge ;
-- drop table t_student_build_c1 purge ;
-- drop table t_student_build_B11 purge ;
-- drop table t_student_build_A14 purge ;

-- [xiang@hadoop01 hive]$ hdfs dfs -cp /user/hive/warehouse/test.db/t_student_build_c1/000000_0 /data/hive/student_partition/c1.txt
-- [xiang@hadoop01 hive]$ hdfs dfs -cp /user/hive/warehouse/test.db/t_student_build_b11/000000_0 /data/hive/student_partition/b11.txt
-- [xiang@hadoop01 hive]$ hdfs dfs -cp /user/hive/warehouse/test.db/t_student_build_a14/000000_0 /data/hive/student_partition/a14.txt

-- 分区加载数据 为啥分区表不会移动文件？
load data inpath '/data/hive/student_partition/c1.txt' into table t_student_hdfs_partition partition (build='C1');
load data inpath '/data/hive/student_partition/b11.txt' into table t_student_hdfs_partition partition (build='B11');
load data inpath '/data/hive/student_partition/a14.txt' into table t_student_hdfs_partition partition (build='A14');

select * from t_student_hdfs_partition sort by id;





------- load 3.x 新特性
create table t_student_new3(id String,name String,politicStatus String,buildNo String,buildRoom String,city String,Country String)
    partitioned by (build String) row format delimited fields terminated by ",";

-- 自动将文件最后一列作为分区列
load data inpath '/data/hive/student_partition/student_all.txt' into table t_student_new3;
select * from t_student_new3 where name = '刘云岑';
select build,count(0) as cnt from t_student_new3 group by build

set hive.exec.dynamic.partition.mode;