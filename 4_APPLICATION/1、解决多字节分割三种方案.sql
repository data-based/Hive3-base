-- Hive默认序列化类是LazySimpleSerDe，其只支持使用 单字节 分隔符（char）

-- 1）、替换分隔符
-- 使用程序提前将数据中的多字节分隔符替换为单字节分隔符。此种解决办法就是替换原始文件的分隔符。

-- 2）、RegexSerDe正则加载
-- 除了使用最多的LazySimpleSerDe，Hive该内置了很多SerDe类；
-- 官网地址：https://cwiki.apache.org/confluence/display/Hive/SerDe
-- 多种SerDe用于解析和加载不同类型的数据文件，常用的有ORCSerDe 、RegexSerDe、JsonSerDe等。
-- RegexSerDe用来加载特殊数据的问题，使用正则匹配来加载数据。
-- 根据正则表达式匹配每一列数据。
-- https://cwiki.apache.org/confluence/display/Hive/GettingStarted#GettingStarted-ApacheWeblogData
create table singer(id string,--歌手id
                    name string,--歌手名称
                    country string,--国家
                    province string,--省份
                    gender string,--性别
                    works string)--作品
--指定使用RegexSerde加载数据
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.RegexSerDe'
WITH SERDEPROPERTIES ("input.regex" = "([0-9]*)\\|\\|(.*)\\|\\|(.*)\\|\\|(.*)\\|\\|(.*)\\|\\|(.*)");


-- 3）、自定义InputFormat
-- Hive中也允许使用自定义InputFormat来解决以上问题，通过在自定义InputFormat，来自定义解析逻辑实现读取每一行的数据。
-- 案例文档： https://blog.csdn.net/chenwewi520feng/article/details/131087017

SELECT parse_url('http://facebook.com/path/p1.php?id=10086', 'HOST');
SELECT parse_url('http://facebook.com/path/p1.php?id=10086&name=allen', 'QUERY') ;
SELECT parse_url('http://facebook.com/path/p1.php?id=10086&name=allen', 'QUERY', 'name') ;
SELECT parse_url('http://192.168.10.41:9870/explorer.html#/user/hive/warehouse/testhive.db/singer2', 'QUERY', 'name') ;

create table bookmarks_url(
    id int,
    name String,
    url String
)row format delimited fields terminated by ",";

load data local inpath '/home/xiang/hive/bookmarks_url.txt' overwrite into table bookmarks_url;
select * from bookmarks_url;