use test;

describe function extended explode;
-- "explode(a) - separates the elements of array a into multiple rows, or the elements of a map into multiple rows and columns "
-- Function class:org.apache.hadoop.hive.ql.udf.generic.GenericUDTFExplode
-- Function type:BUILTIN

select explode(`array`(11,22,33,44,55));

select explode(`map`("id",123,"name","hello"));



-- Chiacao Builds,1999|1992|1993|1996|1997|1998
-- San Antonio Supors,1999|2003|2005|2007|2014
-- Golden State Warriors,1947|1956|1975|2015
-- Boston Geltics,1957|1059|1960|1975|2015
-- L.A. Lakers,1949|1950|1952|1961|1962|1963
-- Miami Heat,2006|2012|2013

create table the_nba_championship(
    team_name String,
    champion_year array<int>
)row format delimited
fields terminated by ","
collection items terminated by "|";

load data local inpath "/home/xiang/hive/The_NBA_Championship.txt" overwrite into table the_nba_championship;

select * from the_nba_championship;

-- 使用 explode 函数进行炸开
select explode(champion_year) as  year from the_nba_championship order by year ;

-- 根据年份倒序排
select a.team_name,year from the_nba_championship a lateral view explode(champion_year) b as year order by  year;

-- 统计每个球队获取总冠军次数，并根据倒叙排
select a.team_name,count(*) as nums from the_nba_championship a lateral view explode(champion_year) b as year
group by a.team_name
order by nums desc ;