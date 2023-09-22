------------String Functions 字符串函数------------
select concat("angela","baby");
--带分隔符字符串连接函数：concat_ws(separator, [string | array(string)]+)
select concat_ws('.', 'www', array('win', 'com'));
--字符串截取函数：substr(str, pos[, len]) 或者  substring(str, pos[, len])
select substr("angelababy",-4); --pos是从1开始的索引，如果为负数则倒着数
-- +-------+
-- |  _c0  |
-- +-------+
-- | baby  |
-- +-------+
select substr("angelababy",7,4);
-- +-------+
-- |  _c0  |
-- +-------+
-- | baby  |
-- +-------+

--正则表达式替换函数：regexp_replace(str, regexp, rep)
select regexp_replace('100-200', '(\\d+)', 'num');
--正则表达式解析函数：regexp_extract(str, regexp[, idx]) 提取正则匹配到的指定组内容
select regexp_extract('100-200', '(\\d+)-(\\d+)', 2);
--URL解析函数：parse_url 注意要想一次解析出多个 可以使用parse_url_tuple这个UDTF函数
select parse_url('http://www.win.com/path/p1.php?query=1', 'QUERY');
describe function extended parse_url;

--分割字符串函数: split(str, regex)
select split('apache hive', '\\s+');
--json解析函数：get_json_object(json_txt, path)
--$表示json对象
select get_json_object('[{"website":"www.win.com","name":"allenwoon"}, {"website":"cloud.win.com","name":"carbondata 中文文档"}]', '$.[1].website');
-- +----------------+
-- |      _c0       |
-- +----------------+
-- | cloud.win.com  |
-- +----------------+

--字符串长度函数：length(str | binary)
select length("angelababy");
--字符串反转函数：reverse
select reverse("angelababy");
--字符串连接函数：concat(str1, str2, ... strN)
--字符串转大写函数：upper,ucase
select upper("angelababy");
select ucase("angelababy");
--字符串转小写函数：lower,lcase
select lower("ANGELABABY");
select lcase("ANGELABABY");
--去空格函数：trim 去除左右两边的空格
select trim(" angelababy ");
--左边去空格函数：ltrim
select ltrim(" angelababy ");
--右边去空格函数：rtrim
select rtrim(" angelababy ");
--空格字符串函数：space(n) 返回指定个数空格
select space(4);
--重复字符串函数：repeat(str, n) 重复str字符串n次
select repeat("angela",2);
--首字符ascii函数：ascii
select ascii("angela");  --a对应ASCII 97
--左补足函数：lpad
select lpad('hi', 5, '??');  --???hi
select lpad('hi', 1, '??');  --h
--右补足函数：rpad
select rpad('hi', 5, '??');
--集合查找函数: find_in_set(str,str_array)
select find_in_set('a','abc,b,ab,c,def');

