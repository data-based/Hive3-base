--创建数据库并切换使用
create database test;
use test;

-- 创建表
create table t_archer(
    id int comment "ID",
    name string comment "英雄名称",
    hp_max int comment "最大生命",
    mp_max int comment "最大法力",
    attack_max int comment "最高物攻",
    defense_max int comment "最大物防",
    attack_range string comment "攻击范围",
    role_main string comment "主要定位",
    role_assist string comment "次要定位"
) comment "王者荣耀射手信息"
row format delimited fields terminated by "\t";

show tables;
select * from t_archer;

-- 上传文件
-- hdfs dfs -ls /user/hive/warehouse/test.db/t_archer
-- hdfs dfs -put t_archer.txt /user/hive/warehouse/test.db/t_archer

truncate table t_archer;
-- INSERT INTO t_archer(ID,NAME,hp_max,mp_max,attack_max,defense_max,attack_range,role_main,role_assist)VALUES (1,'后羿',5986,1784,396,336,'remotely','archer','');
select * from t_archer;

-----------------------------------------------------------------
-- 复杂数据类型映射

-- 指定元素之间的分隔符

-- 数据：4,铠,52,龙域领主:288-曙光守护者:1776
-- 字段：id、name（英雄名称）、win_rate（胜率）、skin_price（皮肤及价格）
-- 前3个字段原生数据类型、最后一个字段复杂类型map。需要指定字段之间分隔符、集合元素之间分隔符、map kv之间分隔符
-- 格式：id,name,win_rate,<k:v>-<k:v>-。。。。


create table t_hot_hero_skin_price(
    id int,
    name string,
    win_rate int,
    skin_price map<string,int>
)
row format delimited
fields terminated by ','
collection items terminated by '-'
map keys terminated by ':' ;

select * from t_hot_hero_skin_price;
-- 4,铠,52,"{""龙域领主"":288,""曙光守护者"":1776}"



-----------------------------------------------------------------
-- 默认分隔符案例
-- 字段：id、team_name（战队名称）、ace_player_name（王牌选手名字）
-- 数据都是原生数据类型，且字段之间分隔符是\001，因此在建表的时候可以省去row format语句，因为hive默认的分隔符就是\001。

create table t_team_ace_player(
    id int,
    team_name string,
    ace_player_name string
);

-- hdfs dfs -put t_team_ace_player.txt /user/hive/warehouse/test.db/t_team_ace_player/
-- insert into t_team_ace_player(id,team_name,ace_player_name) values (1,'成都AG超玩会','一诺');

select * from t_team_ace_player;

