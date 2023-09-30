--创建拉链表
create table dw_zipper(
    userid string,
    phone string,
    nick string,
    gender int,
    addr string,
    starttime string,
    endtime string
)
row format delimited fields terminated by ',';

load data local inpath '/home/xiang/hive/dw_zipper.txt' into table dw_zipper;
select userid, phone, nick, gender, addr, starttime, endtime  from dw_zipper;
-- +---------+--------------+---------+---------+-------+-------------+-------------+
-- | userid  |    phone     |  nick   | gender  | addr  |  starttime  |   endtime   |
-- +---------+--------------+---------+---------+-------+-------------+-------------+
-- | 001     | 186xxxx1234  | laoda   | 0       | sh    | 2021-01-01  | 9999-12-31  |
-- | 002     | 186xxxx1235  | laoer   | 1       | bj    | 2021-01-01  | 9999-12-31  |
-- | 003     | 186xxxx1236  | laosan  | 0       | sz    | 2021-01-01  | 9999-12-31  |
-- | 004     | 186xxxx1237  | laosi   | 1       | gz    | 2021-01-01  | 9999-12-31  |
-- | 005     | 186xxxx1238  | laowu   | 0       | sh    | 2021-01-01  | 9999-12-31  |
-- | 006     | 186xxxx1239  | laoliu  | 1       | bj    | 2021-01-01  | 9999-12-31  |
-- | 007     | 186xxxx1240  | laoqi   | 0       | sz    | 2021-01-01  | 9999-12-31  |
-- | 008     | 186xxxx1241  | laoba   | 1       | gz    | 2021-01-01  | 9999-12-31  |
-- | 009     | 186xxxx1242  | laojiu  | 0       | sh    | 2021-01-01  | 9999-12-31  |
-- | 010     | 186xxxx1243  | laoshi  | 1       | bj    | 2021-01-01  | 9999-12-31  |
-- +---------+--------------+---------+---------+-------+-------------+-------------+


--创建ods层增量表 加载数据
create table ods_zipper_update(
    userid string,
    phone string,
    nick string,
    gender int,
    addr string,
    starttime string,
    endtime string
)
row format delimited fields terminated by ',';

load data local inpath '/home/xiang/hive/ods_zipper_update.txt' into table ods_zipper_update;
select userid, phone, nick, gender, addr, starttime, endtime from ods_zipper_update;
-- +---------+--------------+---------+---------+-------+-------------+-------------+
-- | userid  |    phone     |  nick   | gender  | addr  |  starttime  |   endtime   |
-- +---------+--------------+---------+---------+-------+-------------+-------------+
-- | 008     | 186xxxx1241  | laoba   | 1       | sh    | 2021-01-02  | 9999-12-31  |
-- | 011     | 186xxxx1244  | laoshi  | 1       | jx    | 2021-01-02  | 9999-12-31  |
-- | 012     | 186xxxx1245  | laoshi  | 0       | zj    | 2021-01-02  | 9999-12-31  |
-- +---------+--------------+---------+---------+-------+-------------+-------------+


--创建临时表
create table tmp_zipper(
    userid string,
    phone string,
    nick string,
    gender int,
    addr string,
    starttime string,
    endtime string
)
row format delimited fields terminated by ',';
select * from tmp_zipper;

------------------------------------------
--合并拉链表与增量表
insert overwrite table tmp_zipper
select
    userid,
    phone,
    nick,
    gender,
    addr,
    starttime,
    endtime
from ods_zipper_update
union all
--查询原来拉链表的所有数据，并将这次需要更新的数据的endTime更改为更新值的startTime
select
    a.userid,
    a.phone,
    a.nick,
    a.gender,
    a.addr,
    a.starttime,
    --如果这条数据没有更新或者这条数据不是要更改的数据，就保留原来的值，否则就改为新数据的开始时间-1
    if(b.userid is null or a.endtime < '9999-12-31', a.endtime , date_sub(b.starttime,1)) as endtime
from dw_zipper a
left join ods_zipper_update b on a.userid = b.userid ;

select userid, phone, nick, gender, addr, starttime, endtime from tmp_zipper order by userid;
-- +---------+--------------+---------+---------+-------+-------------+-------------+
-- | userid  |    phone     |  nick   | gender  | addr  |  starttime  |   endtime   |
-- +---------+--------------+---------+---------+-------+-------------+-------------+
-- | 001     | 186xxxx1234  | laoda   | 0       | sh    | 2021-01-01  | 9999-12-31  |
-- | 002     | 186xxxx1235  | laoer   | 1       | bj    | 2021-01-01  | 9999-12-31  |
-- | 003     | 186xxxx1236  | laosan  | 0       | sz    | 2021-01-01  | 9999-12-31  |
-- | 004     | 186xxxx1237  | laosi   | 1       | gz    | 2021-01-01  | 9999-12-31  |
-- | 005     | 186xxxx1238  | laowu   | 0       | sh    | 2021-01-01  | 9999-12-31  |
-- | 006     | 186xxxx1239  | laoliu  | 1       | bj    | 2021-01-01  | 9999-12-31  |
-- | 007     | 186xxxx1240  | laoqi   | 0       | sz    | 2021-01-01  | 9999-12-31  |
-- | 008     | 186xxxx1241  | laoba   | 1       | gz    | 2021-01-01  | 2021-01-01  |       <<<<< 注意这里
-- | 008     | 186xxxx1241  | laoba   | 1       | sh    | 2021-01-02  | 9999-12-31  |       <<<<< 注意这里
-- | 009     | 186xxxx1242  | laojiu  | 0       | sh    | 2021-01-01  | 9999-12-31  |
-- | 010     | 186xxxx1243  | laoshi  | 1       | bj    | 2021-01-01  | 9999-12-31  |
-- | 011     | 186xxxx1244  | laoshi  | 1       | jx    | 2021-01-02  | 9999-12-31  |
-- | 012     | 186xxxx1245  | laoshi  | 0       | zj    | 2021-01-02  | 9999-12-31  |
-- +---------+--------------+---------+---------+-------+-------------+-------------+


