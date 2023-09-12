-- 显示所有数据， SCHEMAS 和 DATABASES 的用户功能一样
show databases;
show schemas;

-- 显示当前数据表、视图、物化视图、分区、索引
show tables;
show tables in xiang;

-- 显示当前数据库下的所有视图
show views;
show views 'test_*';
-- show views from test1;
-- show views [in/from database_name];

-- 显示当前数据库下所有物化视图
-- show materialized views [IN/FROM database_name]
show materialized views IN default;

-- 查看表的分区信息，非分区表会报错
show partitions t_user_province;

-- 显示表、分区的扩展信息
-- show table extended [IN/FROM database_name] like h_user;
show table extended like h_user;
describe formatted h_user;

-- 显示表的属性信息
show tblproperties h_user;
show create table h_user;

-- 显示所有列，包括分区列
-- show columns (FROM/IN) table_name [(FROM/IN) da_name];
show columns in student;

-- 显示当前支持的所有自定义内置函数
show functions ;

-- 查看表信息
desc extended h_user;
-- 格式美化的查看表信息
desc formatted h_user;
-- 查看数据库信息
describe database xiang;