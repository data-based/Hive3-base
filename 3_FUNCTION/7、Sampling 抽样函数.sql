-- Sampling抽样函数
-- 1、Random 随机抽样
    -- 随机抽样使用rand()函数来确保随机获取数据，LIMIT来限制抽取的数据个数。
    -- 优点是随机，缺点是速度不快，尤其表数据多的时候。
        -- 推荐DISTRIBUTE+SORT，可以确保数据也随机分布在mapper和reducer之间，使得底层执行有效率
        -- ORDER BY语句也可以达到相同的目的，但是表现不好，因为ORDER BY是全局排序，只会启动运行一个reducer

select * from t_student_hdfs
distribute by rand() sort by rand() limit 2;

-- 2、Block 基于数据块抽样
    -- Block块采样允许随机获取n行数据、百分比数据或指定大小的数据。
    -- 采样粒度是HDFS块大小。
    -- 优点是速度快，缺点是不随机。

--根据数据大小百分比抽样
SELECT * FROM t_student_hdfs_partition TABLESAMPLE ( 10 PERCENT );
--根据行数抽样
SELECT * FROM t_student_hdfs_partition TABLESAMPLE ( 5 ROWS  );
--根据数据大小抽样
--支持数据单位 b/B, k/K, m/M, g/G
SELECT * FROM t_student_hdfs_partition TABLESAMPLE ( 2m );


-- 3、Bucket table 基于分桶表抽样
    -- 这是一种特殊的采样方法，针对分桶表进行了优化。
    -- 优点是既随机速度也很快。


--根据整行数据进行抽样
SELECT * FROM big_user TABLESAMPLE(BUCKET 1 OUT OF 500000 ON rand());

CREATE TABLE big_user (
    user_id INT,
    username STRING,
    email STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

-- 创建数据
-- #!/bin/bash
-- # Loop to generate and insert data
-- for ((i=1; i<=10000000; i++))
-- do
--     user_id=$((i))
--     username="user_$i"
--     email="user_$i@example.com"
--
--     # Insert data into the user_data table
--     echo ${user_id},${username},${email} >> big_user.txt
-- done

load data local inpath '/home/xiang/hive/big_user.txt' into table big_user;

-- 创建分桶表
CREATE TABLE big_user_bucket (
    user_id INT,
    username STRING,
    email STRING
)
    clustered by (user_id) into 5 BUCKETS
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

insert into big_user_bucket select * from big_user;

select * from big_user;
select count(0) from big_user;

--TABLESAMPLE (BUCKET x OUT OF y [ON colname])

--1、y必须是table总bucket数的倍数或者因子。hive根据y的大小，决定抽样的比例。
    --例如，table总共分了4份（4个bucket），当y=2时，抽取(4/2=)2个bucket的数据，当y=8时，抽取(4/8=)1/2个bucket的数据。
--2、x表示从哪个bucket开始抽取。
    --例如，table总bucket数为4，tablesample(bucket 4 out of 4)，表示总共抽取（4/4=）1个bucket的数据，抽取第4个bucket的数据。
    --注意：x的值必须小于等于y的值，否则FAILED:Numerator should not be bigger than denominator in sample clause for table stu_buck
--3、ON colname表示基于什么抽
    --ON rand()表示随机抽
    --ON 分桶字段 表示基于分桶字段抽样 效率更高 推荐

select * from big_user_bucket;
--根据整行数据进行抽样
SELECT * FROM big_user_bucket TABLESAMPLE(BUCKET 4 OUT OF 100000 ON rand());