-- 分桶表创建
create table  t_china_region_bucket(
    code          string,
    parent_code   string,
    name          string,
    province_code string,
    province_name string,
    city_code     string,
    city_name     string,
    district_code string,
    district_name string
)clustered by (province_code) into 5 buckets ;
-- 分桶字段一定是表中也叫存在的字段

create table  t_china_region_bucket_sort(
    code          string,
    parent_code   string,
    name          string,
    province_code string,
    province_name string,
    city_code     string,
    city_name     string,
    district_code string,
    district_name string
)clustered by (province_code)
    sorted by (code) -- 指定每个分桶内部根据 code 排序
    into 5 buckets ;


-- 映射数据
-- 开启分桶功能，从 Hive2.0开始就不再需要设置了
set hive.enfor.bucketing=true;

-- 把数据加载到普通 hive 表中
-- 使用 insert + select 语法将数据加载到分桶表中
insert into t_china_region_bucket select * from t_china_region;

select * from t_china_region_bucket;

