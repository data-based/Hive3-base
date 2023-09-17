-- HDFS 创建文件夹 /user/hive/warehouse/good.db/t_partition/city=guangdong
-- 上传文件到目录中
select * from t_partition;
-- 发现并没有数据

MSCK repair table t_partition add partitions ;
--  这样 数据就恢复上去了

-- 我们在直接删除调 city=guangdong 文件夹
--  hdfs dfs -rm -r  -skipTrash /user/hive/warehouse/good.db/t_partition/city=guangdong
show partitions t_partition ;
-- Hive 傻傻的发现还有分区

MSCK repair table t_partition drop partitions ;
