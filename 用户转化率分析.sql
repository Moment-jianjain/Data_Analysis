-- 统计各类行为用户数 
select behavior_type
,count(DISTINCT user_id) user_num
from temp_behavior
group by behavior_type
order by behavior_type desc;

-- 存储 各类行为用户数
create table behavior_user_num(
behavior_type varchar(5),
user_num int);

insert into behavior_user_num
select behavior_type
,count(DISTINCT user_id) user_num
from user_behavior
group by behavior_type
order by behavior_type desc;
-- 查询储存结果
select * from behavior_user_num
-- <<<<<<<<<<<>>>>>>>>>>>>>

select 672404/984105 -- 这段时间购买过商品的用户的比例

-- <<<<<<<<<<>>>>>>>>>>>>>>
-- 统计各类行为的数量 
select behavior_type
,count(*) user_num
from temp_behavior
group by behavior_type
order by behavior_type desc;

-- 存储 各类行为的数量 
create table behavior_num(
behavior_type varchar(5),
behavior_count_num int);

insert into behavior_num
select behavior_type
,count(*) behavior_count_num
from user_behavior
group by behavior_type
order by behavior_type desc;
-- 查询储存结果
select * from behavior_num
-- <<<<<<<<<<>>>>>>>>>>

select 2015807/89660667 AS 购买率,(2888258+5530445)/89660667 AS 收藏加购率            -- 购买率&收藏加购率


