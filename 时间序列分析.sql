-- 统计日期-小时的行为
select dates,hours
,count(if(behavior_type='pv',behavior_type,null)) 'pv'
,count(if(behavior_type='cart',behavior_type,null)) 'cart'
,count(if(behavior_type='fav',behavior_type,null)) 'fav'
,count(if(behavior_type='buy',behavior_type,null)) 'buy'

from temp_behavior
group by dates,hours
order by dates,hours

-- 存储 
create table date_hour_behavior(
dates char(10),
hours char(2),
pv int,
cart int,
fav int,
buy int);

-- 结果插入 
insert into date_hour_behavior
select dates,hours
,count(if(behavior_type='pv',behavior_type,null)) 'pv'
,count(if(behavior_type='cart',behavior_type,null)) 'cart'
,count(if(behavior_type='fav',behavior_type,null)) 'fav'
,count(if(behavior_type='buy',behavior_type,null)) 'buy'

from user_behavior
group by dates,hours
order by dates,hours

select * from date_hour_behavior;
