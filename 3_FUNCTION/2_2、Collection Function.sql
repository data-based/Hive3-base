--集合元素size函数:
-- size(Map<K.V>)
-- size(Array<T>)
select size(`array`(11,22,33));
select size(`map`("id",10086,"name","zhangsan","age",18));

--取map集合keys函数:
-- map_keys(Map<K.V>)
select map_keys(`map`("id",10086,"name","zhangsan","age",18));
-- +----------------------+
-- |         _c0          |
-- +----------------------+
-- | ["id","name","age"]  |
-- +----------------------+

--取map集合values函数:
-- map_values(Map<K.V>)
select map_values(`map`("id",10086,"name","zhangsan","age",18));

--判断数组是否包含指定元素:
-- array_contains(Array<T>, value)
select array_contains(`array`(11, 22, 33), 11);

select array_contains(`array`(11,22,33),66);

--数组排序函数:sort_array(Array<T>)
select sort_array(`array`(12,2,32));
