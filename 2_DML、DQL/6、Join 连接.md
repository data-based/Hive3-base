### Join语法

```sql
join_table:
    table_reference [INNER] JOIN table_factor [join_condition]
  | table_reference {LEFT|RIGHT|FULL} [OUTER] JOIN table_reference join_condition
  | table_reference LEFT SEMI JOIN table_reference join_condition
  | table_reference CROSS JOIN table_reference [join_condition] (as of Hive 0.10)
join_condition:
    ON expression  
    
 
-- 1、table_reference：是join查询中使用的表名，也可以是子查询别名（查询结果当成表参与join）。
-- 2、table_factor：与table_reference相同,是联接查询中使用的表名,也可以是子查询别名。
-- 3、join_condition：join查询关联的条件，如果在两个以上的表上需要连接，则使用AND关键字。
```

Join 语法丰富

+ Hive 中 join 语法从面世开始并不丰富，也不像 RDBMS 中灵活
+ 从 Hive3.0 开始 支持隐式连接表示法，允许 FROM 之间都好分割的表列表，而省略 join 关键字
+ 从 Hive2.2.0开始 支持 ON 字句中的复杂表达式，支持不等式连接，在此之前不支持 不相等条件

笔友文档：https://blog.csdn.net/chenwewi520feng/article/details/131069617

