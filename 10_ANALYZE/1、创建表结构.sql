-- 创建 xiang 数据库
create database if not exists xiang
comment "this is my hive db"
with dbproperties ('createBy'='xiang');

show databases ;


drop table x_money purge ;
-- 创建金融表
create table x_money(
    up_time string comment "时间",
    type string comment "类型",
    title string comment "标题",
    des string comment "备注",
    money int comment "金额"
) comment "金融表"
row format delimited fields terminated by ",";



-- 加载数据
load data local inpath '/home/xiang/hive/money.csv' overwrite into table xiang.x_money;
select * from xiang.x_money;