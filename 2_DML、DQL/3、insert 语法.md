## insert 用法

### insert + select

语法规则

```sql
-- 增加
INSERT INTO tablename(col...) SELECT col... FROM table2

-- 覆盖
INSERT OVERWRITE TABLE tablename(col...) SELECT col... FROM table2
```



### 多重导入

减少多次扫描

语法规则

```sql
FROM from_statement
INSERT OVERWRITE [LOCAL] DIRECTORY directory1 select_statement1
[INSERT OVERWRITE [LOCAL] DIRECTORY directory2 select_statement2] ...
```

案例

```sql
from t_student_hdfs
insert overwrite table t_student_insert1
select id
insert overwrite table t_student_insert2
select name;
```



### 数据导出

标准导出

```sql
INSERT OVERWRITE [LOCAL] DIRECTORY directory1
[ROW FORMAT row_format] [STORED AS file_format]
SELECT ... FROM...
```

```sql
: DELIMITED [FIELDS TERMINATED BY char [ESCAPED BY char]] 
            [COLLECTION ITEMS TERMINATED BY char]
            [MAP KEYS TERMINATED BY char] 
            [LINES TERMINATED BY char]
```

1、目录可以是完整的URI。如果未指定scheme，则Hive将使用hadoop配置变量fs.default.name来决定导出位置；

2、如果使用LOCAL关键字，则Hive会将数据写入本地文件系统上的目录；

3、写入文件系统的数据被序列化为文本，列之间用\001隔开，行之间用换行符隔开。如果列都不是原始数据类型，那么这些列将序列化为JSON格式。也可以在导出的时候指定分隔符换行符和文件格式。