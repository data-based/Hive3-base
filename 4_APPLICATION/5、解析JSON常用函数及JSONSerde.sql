-- 创建表
create table lawyer_json(
    json String
);
load data local inpath "/home/xiang/hive/lawyer_json.txt" overwrite into table lawyer_json;
select * from lawyer_json;

-- 两种数据处理方式
    -- 1、get_json_object、json_tuple
    -- 这两个函数都可以将json数据中的每个字段独立解析出来
        -- get_json_object 每次只能返回 JSON 对象中的一列的值
describe function extended get_json_object;
select
    get_json_object(json,"$.subTitle") as subTitle,
    get_json_object(json,"$.imgPath") as imgPath,
    get_json_object(json,"$.title") as title,
    get_json_object(json,"$.desc") as desc
from lawyer_json;

describe function extended json_tuple;
-- njson_tuple(jsonStr, p1, p2, ..., pn)   like get_json_object, but it takes multiple names and return a tuple
-- 第一个参数：指定要解析的JSON字符串
-- 第二个参数：指定要返回的第1个字段
-- ……
-- 第N+1个参数：指定要返回的第N个字段
-- 功能类似于get_json_object，但是可以调用一次返回多列的值，属于UDTF类型函数，一般搭配lateral view使用
-- 返回的每一列都是字符串类型

--单独使用
select
    --解析所有字段
    json_tuple(json,"subTitle","imgPath","title","desc") as (subTitle,imgPath,title,desc)
from lawyer_json;

--搭配侧视图使用
select json,
  subTitle,imgPath,title,desc
from lawyer_json
lateral view json_tuple(json,"subTitle","imgPath","title","desc") b as subTitle,imgPath,title,desc;

    -- 2、JSON serde
    -- 建表时指定 Serde，加载 JSON 文件到表中，回自动解析为对应的表格

create table lawyer_json2(
    subTitle String,
    imgPath String,
    title String,
    desc String
)row format serde 'org.apache.hive.hcatalog.data.JsonSerDe'
stored as textfile ;

load data local inpath "/home/xiang/hive/lawyer_json.txt" into table lawyer_json2;
select * from lawyer_json2;