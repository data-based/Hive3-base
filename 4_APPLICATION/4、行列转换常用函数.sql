select * from bookmarks_url;
-------------------- Hive 行列转换 --------------------
-- CASE WHEN 语法
select id, case
    when id < 2 then 'a'
    when id = 2 then 'b'
        else 'c'
        end as caseName
from bookmarks_url;

--  创建表，传入数据
create table row_col(
    col1 string,
    col2 string,
    col3 int
)
row format delimited fields terminated by ',';

load data local inpath '/home/xiang/hive/row_col.txt' into table row_col;
select * from row_col;
-- +---------------+---------------+---------------+
-- | row_col.col1  | row_col.col2  | row_col.col3  |
-- +---------------+---------------+---------------+
-- | a             | c             | 1             |
-- | a             | d             | 2             |
-- | a             | e             | 3             |
-- | b             | c             | 4             |
-- | b             | d             | 5             |
-- | b             | e             | 6             |
-- +---------------+---------------+---------------+

-- sql 最终实现
select
    col1 as col1,
    max(case col2 when 'c' then col3 else 0 end) as c,
    max(case col2 when 'd' then col3 else 0 end) as d,
    max(case col2 when 'e' then col3 else 0 end) as e
from row_col
group by col1;
-- +-------+----+----+----+
-- | col1  | c  | d  | e  |
-- +-------+----+----+----+
-- | a     | 1  | 2  | 3  |
-- | b     | 4  | 5  | 6  |
-- +-------+----+----+----+

-- concat_ws 函数
-- 语法 concat_ws(SplitChar，element1，element2……)
select concat_ws("-","I","want","to",null);



-- collect_list 函数
select collect_list(col1) from row_col;
-- collect_set 函数
select collect_set(col1) from row_col;


-- 最终实现
select
    col1,
     concat_ws(',', collect_list(cast(col2 as string))) as col2,
     concat_ws(',', collect_list(cast(col3 as string))) as col3
from row_col
group by col1;


--------------- 多行转多列 -----------------
-- union 去重
-- union all 不去重
select 'b','a','c'
union
select 'a','b','c'
union
select 'a','b','c';



-- 最终实现
-- select col1, 'c' as col2, col2 as col3 from row_col
-- UNION ALL
-- select col1, 'd' as col2, col3 as col3 from row_col;


---------------- 单列转多行----------------
--语法：explode( Map | Array)
select explode(split("a,b,c,d",","));

--创建表
create table col2row2(
     col1 string,
     col2 string,
     col3 string
)
row format delimited fields terminated by ',';

-- 加载数据
insert overwrite table  col2row2 select
    col1,
     concat_ws('-', collect_list(cast(col2 as string))) as col2,
     concat_ws('-', collect_list(cast(col3 as string))) as col3
from row_col
group by col1;

select * from col2row2;
-- +-------+--------+--------+
-- | col1  |  col2  |  col3  |
-- +-------+--------+--------+
-- | a     | c,d,e  | 1,2,3  |
-- | b     | c,d,e  | 4,5,6  |
-- +-------+--------+--------+


select
    col1,
    lv.col2 as col2,
    lv.col3 as col3
from col2row2
lateral view explode(split(col2, '-')) lv as col2
lateral view explode(split(col3, '-')) lv as col3;

-- 反推回去
create table col2row2_tmp(
     col1 string,
     col2 string,
     col3 string
)
row format delimited fields terminated by ',';

insert into col2row2_tmp select
    col1,
    lv.col2 as col2,
    lv.col3 as col3
from col2row2
lateral view explode(split(col2, '-')) lv as col2
lateral view explode(split(col3, '-')) lv as col3;

-- 验证反推
select
    col1,
    col2,
     concat_ws('-', collect_list(cast(col3 as string))) as col3
from col2row2_tmp
group by col1,col2