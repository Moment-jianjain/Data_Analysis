select * from user_behavior where dates is null;
delete from user_behavior where dates is null;

-- 获取每个用户分别活跃的日期
select user_id,dates 
from temp_behavior
group by user_id,dates;

-- 自关联 来求取同一用户活跃的天数和其他天数对应
select * from 
(select user_id,dates 
from temp_behavior
group by user_id,dates
) a
,(select user_id,dates 
from temp_behavior
group by user_id,dates
) b
where a.user_id=b.user_id;

-- 初步筛选使B的date>A的Date,
select * from 
(select user_id,dates 
from temp_behavior
group by user_id,dates
) a
,(select user_id,dates 
from temp_behavior
group by user_id,dates
) b
where a.user_id=b.user_id and a.dates<b.dates;

-- 留存数 通过减法来获取前后两天差值为0,1,,3及其它,来作为次日,两日,三日及七日留存率
select a.dates
,count(if(datediff(b.dates,a.dates)=0,b.user_id,null)) retention_0
,count(if(datediff(b.dates,a.dates)=1,b.user_id,null)) retention_1
,count(if(datediff(b.dates,a.dates)=3,b.user_id,null)) retention_3 from

(select user_id,dates 
from temp_behavior
group by user_id,dates
) a
,(select user_id,dates 
from temp_behavior
group by user_id,dates
) b
where a.user_id=b.user_id and a.dates<=b.dates
group by a.dates

-- 留存率 通过对次日,两日以及三日的留存数除以最开始的活跃用户
select a.dates
,count(if(datediff(b.dates,a.dates)=1,b.user_id,null))/count(if(datediff(b.dates,a.dates)=0,b.user_id,null)) retention_1
from
(select user_id,dates 
from temp_behavior
group by user_id,dates
) a
,(select user_id,dates 
from temp_behavior
group by user_id,dates
) b
where a.user_id=b.user_id and a.dates<=b.dates
group by a.dates

-- 保存结果 
create table retention_rate (
dates char(10),
retention_1 float 
);

insert into retention_rate 
select a.dates
,count(if(datediff(b.dates,a.dates)=1,b.user_id,null))/count(if(datediff(b.dates,a.dates)=0,b.user_id,null)) retention_1
from
(select user_id,dates 
-- from temp_behavior
from user_behavior
group by user_id,dates
) a
,(select user_id,dates 
from user_behavior
group by user_id,dates
) b
where a.user_id=b.user_id and a.dates<=b.dates
group by a.dates

select * from retention_rate

-- 跳失率 
-- 跳失用户:在这段时间内只浏览一次的用户              -- 88
select count(*) 
from 
(
select user_id from user_behavior
group by user_id
having count(behavior_type)=1
) a

-- 查询浏览用户的总数(用户总访问量)
select sum(pv) 总访问量 from pv_uv_puv; -- 89660667

-- 所以用户的跳失率为 88/89660667
