create table t_money(
    id int comment "ID",
    datetime string comment "日期",
    pay_type string comment "类型",
    type String comment "分类",
    money double comment "金额",
    desc string comment "备注"
) comment "账单"
row format delimited
fields terminated by "\t";

select * from t_money;
-- hadoop fs -put book.txt /user/hive/warehouse/xiang.db/t_money


-- map 类型复杂表结构
create table t_hot_price(
    id int,
    name string,
    win_rate int,
    skin_price map<string,int>
) row format delimited
fields terminated by ',' -- 指定字段之间分隔符
collection items terminated by '-' -- 指定集合元素之间的分隔符
map keys terminated by  ':'; -- 指定 map 元素kv之间的分隔符

select * from t_hot_price;


-- 建表时候，指定表数据在 hdfs 上的任意位置
create table t_team_location(
    id int,
    name string
) location '/data';

select * from t_team_location;
-- 但是还是建议不去更改目录，方便集中管理


-- 内外部表
/*
                内部表         外部表
创建方式        默认创建        使用External
Hive管理范围    元数据，表数据     元数据
删除表结果      元数据、hdfs文件数据都删除      只删除元数据，保留文件数据
操作          支持 archive、unarchive、truncate、merge、concatenate         不支持
事务          支持ACID、事务性          不支持
缓存          支持结果缓存              不支持
 */
create external table student(
    id int,
    name string
);
-- 查看元数据
desc formatted student;
-- Table Type:         ,EXTERNAL_TABLE      表示为外部表
-- Hive 完整的控制生命周期，使用内部表
-- 数据非常珍贵,使用外部表



-- 优化分区表
create table t_partition(
    datetime string comment "日期",
    pay_type string comment "类型",
    type String comment "分类",
    money double comment "金额",
    desc string comment "备注"
) comment "账单"
row format delimited
fields terminated by "\t";

-- /data/partition_1.txt
select * from t_partition where type='交通' and money > 50;

select count(*) from t_partition where type='交通' and money > 50;