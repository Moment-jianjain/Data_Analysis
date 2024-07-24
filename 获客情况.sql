-- 创建临时表temp_behavior 
create table temp_behavior like user_behavior;

-- 截取数据
insert into temp_behavior
select * from user_behavior limit 100000;

select * from temp_behavior;

-- 临时表上的页面浏览量 pv 
select dates
,count(*) 'pv'
from temp_behavior
where behavior_type='pv'
GROUP BY dates;
-- 临时表上的独立访客数 uv 
select dates
,count(distinct user_id) 'uv'
from temp_behavior
where behavior_type='pv'
GROUP BY dates;

-- 临时表上的 pv,uv以及浏览深度pv/uv
select dates
,count(*) 'pv'
,count(distinct user_id) 'uv'
,round(count(*)/count(distinct user_id),1) 'pv/uv'
from temp_behavior
where behavior_type='pv'
GROUP BY dates;

-- 处理真实数据user_behavior
-- 创建pv_uv_puv来存储页面浏览量,独立访客数以及浏览深度pv/uv
create table pv_uv_puv (
dates char(10),
pv int(9),
uv int(9),
puv decimal(10,1)
);

insert into pv_uv_puv
select dates
,count(*) 'pv'
,count(distinct user_id) 'uv'
,round(count(*)/count(distinct user_id),1) 'pv/uv'
from user_behavior
where behavior_type='pv'
GROUP BY dates;

select * from pv_uv_puv

delete from pv_uv_puv where dates is null;
