
--表创建并且加载数据
CREATE TABLE cookie_info(
   month STRING,
   day STRING,
   cookieid STRING
) ROW FORMAT DELIMITED
FIELDS TERMINATED BY ',';

load data local inpath '/home/xiang/hive/cookie_info.txt' into table cookie_info;

select * from cookie_info;

select month,count(month) from cookie_info group by month;

---group sets---------
SELECT
    month,
    day,
    COUNT(DISTINCT cookieid) AS nums,
    GROUPING__ID
FROM cookie_info
GROUP BY month,day
GROUPING SETS (month,day) --这里是关键
ORDER BY GROUPING__ID;

--grouping_id表示这一组结果属于哪个分组集合，
--根据grouping sets中的分组条件month，day，1是代表month，2是代表day

-- +----------+-------------+-------+---------------+
-- |  month   |     day     | nums  | grouping__id  |
-- +----------+-------------+-------+---------------+
-- | 2018-04  | NULL        | 5     | 1             |
-- | 2018-03  | NULL        | 4     | 1             |
-- | NULL     | 2018-04-16  | 2     | 2             |
-- | NULL     | 2018-04-15  | 1     | 2             |
-- | NULL     | 2018-04-13  | 3     | 2             |
-- | NULL     | 2018-04-12  | 2     | 2             |
-- | NULL     | 2018-03-12  | 1     | 2             |
-- | NULL     | 2018-03-10  | 3     | 2             |
-- +----------+-------------+-------+---------------+
-- 8 rows selected (141.667 seconds)

--等价于
SELECT month,NULL,COUNT(DISTINCT cookieid) AS nums,1 AS GROUPING__ID FROM cookie_info GROUP BY month
UNION ALL
SELECT NULL as month,day,COUNT(DISTINCT cookieid) AS nums,2 AS GROUPING__ID FROM cookie_info GROUP BY day;
-- +------------+-------------+-----------+-------------------+
-- | _u1.month  |   _u1._c1   | _u1.nums  | _u1.grouping__id  |
-- +------------+-------------+-----------+-------------------+
-- | NULL       | 2018-03-10  | 3         | 2                 |
-- | NULL       | 2018-03-12  | 1         | 2                 |
-- | NULL       | 2018-04-12  | 2         | 2                 |
-- | NULL       | 2018-04-13  | 3         | 2                 |
-- | NULL       | 2018-04-15  | 1         | 2                 |
-- | NULL       | 2018-04-16  | 2         | 2                 |
-- | 2018-03    | NULL        | 4         | 1                 |
-- | 2018-04    | NULL        | 5         | 1                 |
-- +------------+-------------+-----------+-------------------+
-- 8 rows selected (214.566 seconds)


--再比如
SELECT
    month,
    day,
    COUNT(DISTINCT cookieid) AS nums,
    GROUPING__ID
FROM cookie_info
GROUP BY month,day
GROUPING SETS (month,day,(month,day))   --1 month   2 day    3 (month,day)
ORDER BY GROUPING__ID;
-- +----------+-------------+-------+---------------+
-- |  month   |     day     | nums  | grouping__id  |
-- +----------+-------------+-------+---------------+
-- | 2018-03  | 2018-03-10  | 3     | 0             |
-- | 2018-04  | 2018-04-16  | 2     | 0             |
-- | 2018-04  | 2018-04-13  | 3     | 0             |
-- | 2018-04  | 2018-04-12  | 2     | 0             |
-- | 2018-04  | 2018-04-15  | 1     | 0             |
-- | 2018-03  | 2018-03-12  | 1     | 0             |
-- | 2018-03  | NULL        | 4     | 1             |
-- | 2018-04  | NULL        | 5     | 1             |
-- | NULL     | 2018-04-16  | 2     | 2             |
-- | NULL     | 2018-04-15  | 1     | 2             |
-- | NULL     | 2018-04-13  | 3     | 2             |
-- | NULL     | 2018-04-12  | 2     | 2             |
-- | NULL     | 2018-03-12  | 1     | 2             |
-- | NULL     | 2018-03-10  | 3     | 2             |
-- +----------+-------------+-------+---------------+
-- 14 rows selected (169.694 seconds)


--等价于
SELECT month,NULL,COUNT(DISTINCT cookieid) AS nums,1 AS GROUPING__ID FROM cookie_info GROUP BY month
UNION ALL
SELECT NULL,day,COUNT(DISTINCT cookieid) AS nums,2 AS GROUPING__ID FROM cookie_info GROUP BY day
UNION ALL
SELECT month,day,COUNT(DISTINCT cookieid) AS nums,3 AS GROUPING__ID FROM cookie_info GROUP BY month,day;

------cube---------------
SELECT
    month,
    day,
    COUNT(DISTINCT cookieid) AS nums,
    GROUPING__ID
FROM cookie_info
GROUP BY month,day
WITH CUBE
ORDER BY GROUPING__ID;

--等价于
SELECT NULL,NULL,COUNT(DISTINCT cookieid) AS nums,0 AS GROUPING__ID FROM cookie_info
UNION ALL
SELECT month,NULL,COUNT(DISTINCT cookieid) AS nums,1 AS GROUPING__ID FROM cookie_info GROUP BY month
UNION ALL
SELECT NULL,day,COUNT(DISTINCT cookieid) AS nums,2 AS GROUPING__ID FROM cookie_info GROUP BY day
UNION ALL
SELECT month,day,COUNT(DISTINCT cookieid) AS nums,3 AS GROUPING__ID FROM cookie_info GROUP BY month,day;



--rollup-------------
--比如，以month维度进行层级聚合：
SELECT
    month,
    day,
    COUNT(DISTINCT cookieid) AS nums,
    GROUPING__ID
FROM cookie_info
GROUP BY month,day
WITH ROLLUP
ORDER BY GROUPING__ID;
