原始暴力的方式，使用 `Hadoop fs -put | -mv` 等方式直接将数据移动到表文件夹下

## Load

+ 含义为 加载、装载
+ 将数据文件移动到Hive表对应位置，移动时存复制、移动操作
+ 纯复制、移动在数据 load 加载到表中，Hive 不会对表中的数据内容进行任何替换，任何操作

语法规则

```sql
LAOD DATA [LOCAL] INPATH 'filepath' [OVERWRITE] INTO TABLE tablename
[PARTITION(partocl1=val1,...)]

-- 3.0 以后
LAOD DATA [LOCAL] INPATH 'filepath' [OVERWRITE] INTO TABLE tablename
[PARTITION(partocl1=val1,...)]
[INPUTFORMAT 'inputforma' SERDE 'serde']
```

### 语法 filepath

+ 待移动数据路径，可以指向文件（加载单独文件），也可以指向目录（加载整个目录）
+ 支持三种方式，结合 `LOCAL` 关键字考虑
	+ 相对路径  `project/data1`
	+ 绝对路径  `/user/hive/test.db/project/data1`
	+ 具有 shcema 的完整 url，例如 `hdfs://hadoop01:9000/user/hive/test.db/project/data1`

### 语法 local

指定Local，将在本地文件系统中查找文件，若指定相对路径，将相对用户的工作目录进行解释，用户也可以为本地文件指定完整URL：`file:///usr/hive/project/data1`

没有指定Local，如果filepath 指向的是一个完整 URI，会使用这个 URI，如果没有指定 schema，Hive 会使用在 Hadoop 配置文件中参数  fs.default.name 指定的（不出意外，都是 HDFS）

##### 本地

本地指定的是 Hiveserver2 服务所在的本地 Linux 文件系统。

### 语法 overwite

目标表里的数据会先情况再写入，覆盖操作





### 3.x 新特性

1. load 加载数据时除移动、复制外，在某些场合还会重写为 INSERT AS SELECT
2. 支持使用 inputformat，SerDe 指定输入格式， Text、Orc 等

如果表具有分区，load 命令没有指定分区，转化为 INSERT AS SELECT 时，默认将最后一列指定为分区列，如果文件不符合规则，报错。

