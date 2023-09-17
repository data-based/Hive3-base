-- 1、显示所有数据库
show databases ;
show schemas ;

-- 2、显示当前数据所有表、视图、物化视图、分区、索引
show tables;
show tables in hive;

-- 3、显示当前数据库下所有视图
show views ;
show views 'test_*';
show views from test;
show views in test;

-- 4、显示当前数据库下所有物化视图
show materialized views ;
show materialized views from hive;

-- 5、查看表分区信息
show partitions t_china_region_part_dynamic;
-- 查询非分区表查询报错

-- 6、显示表、分区扩展信息
show table extended from test like t_china_region_part_dynamic;
show table extended like t_china_region_part_dynamic;
describe formatted t_china_region_part_dynamic;
desc formatted  t_china_region_part_dynamic;

-- 7、查看表属性信息
show tblproperties trans_student;

-- 8、显示表、视图的创建语句
show create table test.trans_student;

-- 9、显示表中所有列，包括分区列
show columns from t_china_region_part_dynamic from test;
show columns in t_china_region_part_dynamic;

-- 10、查看当前 Hive 支持的自定义内置函数
show functions ;

-- 11、扩展
desc extended t_china_region_part_dynamic;
describe formatted t_china_region_part_dynamic;
describe database hive;