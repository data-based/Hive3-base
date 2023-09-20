# Hive SQL-DQL-Select查询数据

### 1、语法

```sql
[WITH CommonTableExpression (, CommonTableExpression)*]
SELECT [ALL | DISTINCT] select_expr, select_expr, ...
  FROM table_reference
  [WHERE where_condition]
  [GROUP BY col_list]
  [ORDER BY col_list]
  [CLUSTER BY col_list
    | [DISTRIBUTE BY col_list] [SORT BY col_list]
  ]
 [LIMIT [offset,] rows];
```



### 2、ORDER BY

Hive SQL 中的 ORDER BY 语法类似于标准 SQL 语言中的 ORDER BY 语法，会对输出的结果进行全局排序

因此当底层使用 MapReduce 引擎执行的时候，只会有一个 reduceTask 执行，如果输出的行数太大，会导致需要很长时间才能完成全局排序

在 Hive2.1 之后，ORDER BY 支持Null 类型结果排序

+ ASC 默认 NULL FIRST
+ DESC 默认 NULL LAST



### 3、CLUSTER BY

根据指定字段将数据分组，每组在根据该字段正序排序（只能正序）

+ 分区规则 Hash 散列：Hash_Func（col_nam）% reducetask 个数
+ 分为几组取决于 reducetask 的个数

![image-20230920114723752](images/5%E3%80%81DQL%20Select%E6%9F%A5%E8%AF%A2/image-20230920114723752.png)
