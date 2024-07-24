use taobao;
desc user_behavior;
select * from user_behavior limit 5;

-- 改变字段名
alter table user_behavior change timestamp timestamps int(14);
desc user_behavior;

-- 检查空值 
select * from user_behavior where user_id is null;
select * from user_behavior where item_id is null;
select * from user_behavior where category_id is null;
select * from user_behavior where behavior_type is null;
select * from user_behavior where timestamps is null;

-- 检查重复值 
select user_id,item_id,timestamps from user_behavior
group by user_id,item_id,timestamps
having count(*)>1;

-- 去重 
alter table user_behavior add id int first;
select * from user_behavior limit 5;
alter table user_behavior modify id int primary key auto_increment;
--
delete user_behavior from
user_behavior,
(
select user_id,item_id,timestamps,min(id) id from user_behavior
group by user_id,item_id,timestamps
having count(*)>1
) t2
where user_behavior.user_id=t2.user_id
and user_behavior.item_id=t2.item_id
and user_behavior.timestamps=t2.timestamps
and user_behavior.id>t2.id;

-- 新增日期：date time hour
-- 更改buffer值
show VARIABLES like '%_buffer%';
set GLOBAL innodb_buffer_pool_size=10700000000;
-- datetime对时间进行处理
alter table user_behavior add datetimes TIMESTAMP(0);
update user_behavior set datetimes=FROM_UNIXTIME(timestamps);
select * from user_behavior limit 5;
-- date
alter table user_behavior add dates char(10);
alter table user_behavior add times char(8);
alter table user_behavior add hours char(2);
-- update user_behavior set dates=substring(datetimes,1,10),times=substring(datetimes,12,8),hours=substring(datetimes,12,2);
update user_behavior set dates=substring(datetimes,1,10);
update user_behavior set times=substring(datetimes,12,8);
update user_behavior set hours=substring(datetimes,12,2);
select * from user_behavior limit 5;

-- 去异常 
select max(datetimes),min(datetimes) from user_behavior;
delete from user_behavior
where datetimes < '2017-11-25 00:00:00'
or datetimes > '2017-12-03 23:59:59';

-- 数据概览 
desc user_behavior;
select * from user_behavior limit 5;
SELECT count(1) from user_behavior; -- 查看处理后最终还有多少数据>>>>>>>100095495条记录
