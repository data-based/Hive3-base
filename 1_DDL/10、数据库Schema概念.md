### Shcema数据库

create database 用于创建新的数据库

+ COMMENT：数据库注释说明
+ LOCATION：指定数据库在HDFS上存储位置，默认` /user/hive/warehouse/dbname.db
+ WITH DBPROPERTILES：指定数据库的配置信息

```sql
CREATE (DATABASE|SCHEMA) [IF NOT EXISTS] database_name
[COMMENT database_comment]
[LOCATION hdfs_path]
[WITH DBPROPERTIES (property_name=property_value, ...)]
```



删库

```sql
drop database hive cascade ;
```

删表

```sql
drop database hive cascade ;
```



