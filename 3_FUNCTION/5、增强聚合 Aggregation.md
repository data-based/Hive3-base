### 增强聚合

增强聚合指的是 grouping_sets、cube、rollup 这几个函数，适用于 OLAP 多维数据分析模型中，多维分析。



#### grouping sets

`grouping sets` 是一种将多个 group by 逻辑写在一个 sql 语句中的便利写法，等价于将不同维度的 GROUP BY 结果集进行 UNION ALL。 `GROUPING__ID` 表示结果属于哪一个分组集合



#### cube

`cube` 表示根据 GROUP BY 的维度的所有组合进行聚合

对于 cube 来说，如果有n个维度，则所有组合的总数是  2^n 个维度



#### rollup

`cube` 的语法功能指的是 GroupBy 的所有维度

而 rollup 是 cube 的子集，以最左侧的维度为主，从该维度进行层级聚合。



