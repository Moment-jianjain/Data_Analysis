-- 统计商品的热门品类、热门商品、热门品类热门商品
-- 小样本数据查看
select category_id
,count(if(behavior_type='pv',behavior_type,null)) '品类浏览量'
from temp_behavior
GROUP BY category_id
order by 2 desc
limit 10

select item_id
,count(if(behavior_type='pv',behavior_type,null)) '商品浏览量'
from temp_behavior
GROUP BY item_id
order by 2 desc
limit 10

select category_id,item_id,
品类商品浏览量 from
(
select category_id,item_id
,count(if(behavior_type='pv',behavior_type,null)) '品类商品浏览量'
-- ,rank()over(partition by category_id order by '品类商品浏览量' desc) r
-- 纠错，'品类商品浏览量'这里不能指代count(if(behavior_type='pv',behavior_type,null))因为还没返回
,rank()over(partition by category_id order by count(if(behavior_type='pv',behavior_type,null)) desc) r
from temp_behavior
GROUP BY category_id,item_id
order by 3 desc
) a
where a.r = 1
order by a.品类商品浏览量 desc
limit 10

-- ----------大数据集存储 -----------------------------------------------------------------------------------

create table popular_categories(
category_id int,
pv int);
create table popular_items(
item_id int,
pv int);
create table popular_cateitems(
category_id int,
item_id int,
pv int);


insert into popular_categories -- .................................
select category_id
,count(if(behavior_type='pv',behavior_type,null)) '品类浏览量'
from user_behavior
GROUP BY category_id
order by 2 desc
limit 10;


insert into popular_items -- .................................
select item_id
,count(if(behavior_type='pv',behavior_type,null)) '商品浏览量'
from user_behavior
GROUP BY item_id
order by 2 desc
limit 10;


insert into popular_cateitems -- .................................
select category_id,item_id,
品类商品浏览量 from
(
select category_id,item_id
,count(if(behavior_type='pv',behavior_type,null)) '品类商品浏览量'
,rank()over(partition by category_id order by count(if(behavior_type='pv',behavior_type,null)) desc) r
from user_behavior
GROUP BY category_id,item_id
order by 3 desc
) a
where a.r = 1
order by a.品类商品浏览量 desc
limit 10


-- 查看表数据.................................
select * from popular_categories;
select * from popular_items;
select * from popular_cateitems;
