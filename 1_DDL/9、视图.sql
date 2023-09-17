-- 创建视图
-- 基于表创建视图
create view t_archer_view as select id,name,hp_max from t_archer;
-- 基于视图创建视图
create view t_archer_view_view as select *,'view' from t_archer_view;

-- 显示当前已有视图, 只会显示视图
show views;

-- 查看视图的定义
show create table t_archer_view_view;


--------------------------------------------
-- 物化视图
-- 1、开启事务操作
-- 2、新建事务表
drop table if exists student_trans;
create table student_trans(
    sno int,
    sname string,
    sdept string
)clustered by (sno) into 2 buckets
stored as orc
TBLPROPERTIES ('transactional'='true');

-- 3、导入数据到 student_trans 中
insert into table student_trans
select * from student;




-- 4、对原始表 student_trans 查询， 24s
select sdept,count(0) as sdept_cnt from student_trans group by sdept;

-- 5、对 student_trans 建立聚合物化视图
CREATE MATERIALIZED VIEW  student_tans_sdept_cnt
as select sdept,count(0) as sdept_cnt from student_trans group by sdept;

-- 重新查询物化视图
select * from student_tans_sdept_cnt;
-- 查看数据库中的物化视图
show materialized views ;

-- 6、我们重新操作步骤4，对 student_trans group by sdept操作，秒级反应
explain select sdept,count(0) as sdept_cnt from student_trans group by sdept;

-- 7、禁用物化视图
alter materialized view student_tans_sdept_cnt disable rewrite ;