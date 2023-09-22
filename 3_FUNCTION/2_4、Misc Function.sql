--如果你要调用的java方法所在的jar包不是hive自带的 可以使用add jar添加进来
--hive调用java方法: java_method(class, method[, arg1[, arg2..]])
select java_method("java.lang.Math","max",11,22);

--反射函数: reflect(class, method[, arg1[, arg2..]])
select reflect("java.lang.Math","max",11,22);

--取哈希值函数:hash
select hash("alan");

--current_user()、logged_in_user()、current_database()、version()

--SHA-1加密: sha1(string/binary)
select sha1("alan");

--SHA-2家族算法加密：sha2(string/binary, int)  (SHA-224, SHA-256, SHA-384, SHA-512)
select sha2("alan",224);
select sha2("alan",512);

--crc32加密:
select crc32("alan");

--MD5加密: md5(string/binary)
select md5("alan");
