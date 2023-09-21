---
hive shell客户端与属性配置、内置运算符、函数（内置运算符与自定义UDF运算符）
https://blog.csdn.net/chenwewi520feng/article/details/131080242
---

## Hive Cli

### 1、Batch Mode  批处理模式

使用 -e 或 -f 选项运行 bin/hive 时，他将于批处理模式执行 SQL命令，所谓的批处理可以理解为 **一次性执行，执行完退出**

```sh
/usr/local/hive/bin/hive -e 'show databases'
```

也可以执行脚本 `/home/xiang/hive/hive.sql`

```sh
/usr/local/hive/bin/hive -f /home/xiang/hive/hive.sql
```

```sh
/usr/local/hive/bin/hive -f hdfs://hadoop01:9200/hive.sql
```

交互形式执行初始化脚本 `-i`

```sh
/usr/local/hive/bin/hive -i /home/xiang/hive/hive-init.sh
```

静默模式 `-S` , 将文件直接写入目标文件中。可以用于数据导出

```sh
/usr/local/hive/bin/hive -S -e 'select * from test.t_archer' > /home/xiang/hive/t_archer.txt
```



### 2、Interactive Shell 交互模式

执行 `/usr/local/hive/bin/hive`

### 3 、启动 Hive 服务

推荐第二代客户端。

```sh
/usr/local/hive/bin/beeline

!connect jdbc:hive2://hadoop01:10000
# 输入用户名和密码
```

beeline客户端介绍

[https://cwiki.apache.org/confluence/display/Hive/HiveServer2+Clients#HiveServer2Clients-Beeline%E2%80%93NewCommandLineShell](https://cwiki.apache.org/confluence/display/Hive/HiveServer2+Clients#HiveServer2Clients-Beeline–NewCommandLineShell)



直接连接 Hive

```sh
/usr/local/hive/bin/beeline  --color=true -u jdbc:hive2://hadoop01:10000/test -n xiang -p xiang
```

