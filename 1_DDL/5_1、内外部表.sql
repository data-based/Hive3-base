-- 来获取表的描述信息，从中可以看出表的类型
describe formatted t_team_ace_player_location;


-- 创建外部表
create external table student_ext(
  id int,
  name String
);

drop table student_ext;