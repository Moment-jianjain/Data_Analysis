select '难度增加'


-- -对用户id和商品id进行分组,统计两者之间发生各类行为的数量---------------------------------------------------------------------

-- ----------------------以下操作是在小样本表上操作
create view user_behavior_view as
select user_id,item_id
,count(if(behavior_type='pv',behavior_type,null)) 'pv'
,count(if(behavior_type='fav',behavior_type,null)) 'fav'
,count(if(behavior_type='cart',behavior_type,null)) 'cart'
,count(if(behavior_type='buy',behavior_type,null)) 'buy'
from temp_behavior
group by user_id,item_id

-- 用户行为标准化,当用户行为(pv,fav,cart,buy)大于1时记为true值"1",否者为"0"
create view user_behavior_standard as
select user_id
,item_id
,(case when pv>0 then 1 else 0 end) 浏览了
,(case when fav>0 then 1 else 0 end) 收藏了
,(case when cart>0 then 1 else 0 end) 加购了
,(case when buy>0 then 1 else 0 end) 购买了
from user_behavior_view

-- 路径类型 

create view user_behavior_path as
select *,
concat(浏览了,收藏了,加购了,购买了) 购买路径类型
from user_behavior_standard as a
where a.购买了>0


-- 统计各类购买行为数量 
create view path_count as
select 购买路径类型
,count(*) 数量
from user_behavior_path
group by 购买路径类型
order by 数量 desc

-- 人话表
create table renhua(
path_type char(4),
description varchar(40));

insert into renhua 
values('0001','直接购买了'),
('1001','浏览后购买了'),
('0011','加购后购买了'),
('1011','浏览加购后购买了'),
('0101','收藏后购买了'),
('1101','浏览收藏后购买了'),
('0111','收藏加购后购买了'),
('1111','浏览收藏加购后购买了')

select * from renhua

select * from path_count p 
join renhua r 
on p.购买路径类型=r.path_type 
order by 数量 desc

-- ----存储 
create table path_result(
path_type char(4),
description varchar(40),
num int);

-- -----------------------------------------------------------------------------------------------------
-- -以下开始在正式表上操作
-- 先删除小样本的视图
drop view user_behavior_view
drop view user_behavior_standard
drop view user_behavior_path
drop view path_count 

-- -对用户id和商品id进行分组,统计两者之间发生各类行为的数量
create view user_behavior_view as
select user_id,item_id
,count(if(behavior_type='pv',behavior_type,null)) 'pv'
,count(if(behavior_type='fav',behavior_type,null)) 'fav'
,count(if(behavior_type='cart',behavior_type,null)) 'cart'
,count(if(behavior_type='buy',behavior_type,null)) 'buy'
from user_behavior
group by user_id,item_id

-- ---用户行为标准化  
create view user_behavior_standard as
select user_id
,item_id
,(case when pv>0 then 1 else 0 end) 浏览了
,(case when fav>0 then 1 else 0 end) 收藏了
,(case when cart>0 then 1 else 0 end) 加购了
,(case when buy>0 then 1 else 0 end) 购买了
from user_behavior_view

-- -----路径类型 

create view user_behavior_path as
select *,
concat(浏览了,收藏了,加购了,购买了) 购买路径类型
from user_behavior_standard as a
where a.购买了>0


-- ----统计各类购买行为数量 
create view path_count as
select 购买路径类型
,count(*) 数量
from user_behavior_path
group by 购买路径类型
order by 数量 desc

-- -----------------------------------------------------------------------------------------------------------------
-- 将大数据集处理好的插入到表中
insert into path_result
select path_type,description,数量 from
path_count p 
join renhua r 
on p.购买路径类型=r.path_type 
order by 数量 desc

-- 查看数据表
select * from path_result

-- 单独购买量,没有加购和收藏情况下的购买总数
select sum(buy)
from user_behavior_view
where buy>0 and fav=0 and cart=0

 -- 1528016
 
 select 2015807-1528016 AS 浏览后收藏和加购后购买量,487791/(2888258+5530445) AS 收藏和加购行为的转化率
 
 -- 总购买量 减去 浏览后的购买量 = 收藏加购后购买的数量487791
 
 -- 487791为为收藏加购后购买的数量  2888258+5530445为总的收藏加购数量
