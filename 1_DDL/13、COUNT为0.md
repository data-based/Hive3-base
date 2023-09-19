表里明明有数据，但是count就是为0

查询前设置

```
set hive.compute.query.using.stats=false
```

这是个窗口级的设置，如果下次还是为0，还这样执行一下