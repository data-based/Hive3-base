use test;
-- 数据准备
--table1: 员工表
CREATE TABLE employee(
   id int,
   name string,
   deg string,
   salary int,
   dept string
 )
 row format delimited
fields terminated by ',';

--table2:员工住址信息表
CREATE TABLE employee_address (
    id int,
    hno string,
    street string,
    city string
)
row format delimited
fields terminated by ',';

--table3:员工联系方式表
CREATE TABLE employee_connection (
    id int,
    phno string,
    email string
)
row format delimited
fields terminated by ',';

load data local inpath '/home/xiang/txt/join/employee.txt' into table employee;
load data local inpath '/home/xiang/txt/join/employee_address.txt' into table employee_address;
load data local inpath '/home/xiang/txt/join/employee_connection.txt' into table employee_connection;

select * from employee;
-- 1201,gopal,manager,50000,TP
-- 1202,manisha,cto,50000,TP
-- 1203,khalil,dev,30000,AC
-- 1204,prasanth,dev,30000,AC
-- 1206,kranthi,admin,20000,TP

select * from employee_address;
-- 1201,288A,vgiri,jublee
-- 1202,108I,aoc,ny
-- 1204,144Z,pgutta,hyd
-- 1206,78B,oldcity,la
-- 1207,720X,hitec,ny

select * from employee_connection;
-- 1201,2356742,gopal@tp.com
-- 1203,1661663,manisha@tp.com
-- 1204,8887776,khalil@ac.com
-- 1205,9988774,prasanth@ac.com
-- 1206,1231231,kranthi@tp.com

-- 内关联 交集
select * from employee e inner join employee_connection c on e.id = c.id;

-- 左关联
select * from employee e left join employee_connection c on e.id = c.id;
-- 又关联
select * from employee e right join employee_connection c on e.id = c.id;

-- 左关联 但只显示 左表的全部数据
select * from employee e left semi join employee_connection c on e.id = c.id;

-- cross join 交叉 笛卡尔积
-- 性能会非常低，先交叉数据，然后再排除 where 条件
select a.*,b.* from employee a ,employee_address b where a.id = b.id;


-- 多个 join
select * from employee a join employee_address b on(a.id = b.id) join employee_connection c on (a.id = c.id) ;
-- 先将 a、b 相同数据放入缓冲，来一条c对比一下
