-- 201722000120,万翱,共青团,B1,B11-40,九江,浔阳区
create TABLE trans_student
(
    id      String,
    name    String,
    age     int
) row format delimited fields terminated by ","
    stored as orc TBLPROPERTIES ('transactional' = 'true');

select *
from trans_student;
describe formatted trans_student;

insert into trans_student values ('1','Nene',19);

select * from trans_student;