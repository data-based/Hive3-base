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

INSERT INTO t_hot_price (id,name,win_rate,skin_price) VALUES (3,'矿泉水',56,{"康师傅":10,"统一":20});