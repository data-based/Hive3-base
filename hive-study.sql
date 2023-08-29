-- DDL 建表语法
-- 1、Hive SQL 中大小写不敏感
-- SerDe 是 Serializer、Deserializer 的简称，目的是用于序列化和反序列化
-- 序列化是对象转换为字节码过程,而反序列化的是字节码转换为对象的过程
-- Hive 使用 SerDe 包括 FileFormat 读取和写入表,需要注意的是,"key" 部分在读取时会被忽略,而在写入"key"始终是常量

desc formatted t_user;

-- SerDe Library:      ,org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe
-- InputFormat:        ,org.apache.hadoop.mapred.TextInputFormat
-- OutputFormat:       ,org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat


-- 分隔符
-- ROW FORMATE delimited | serde
/*
    delimited
        [fields terminated by char]  字段之间分隔符 (默认 /001)
        [collection items terminated by char] 集合元素之间分隔符
        [map keys terminated by char] map映射k,v 之间分隔符
        [lines terminated by char]  行数据之间分隔符

    serde
 */


-- 指定建表位置
-- LOCATION hdfs_path
/*

 */