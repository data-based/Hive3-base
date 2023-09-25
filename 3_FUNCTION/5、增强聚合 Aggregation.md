### 增强聚合

增强聚合指的是 grouping_sets、cube、rollup 这几个函数，适用于 OLAP 多维数据分析模型中，多维分析。



#### grouping sets

`grouping sets` 是一种将多个 group by 逻辑写在一个 sql 语句中的便利写法，等价于将不同维度的 GROUP BY 结果集进行 UNION ALL。 `GROUPING__ID` 表示结果属于哪一个分组集合