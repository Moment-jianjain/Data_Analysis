# <span style="color:green">基于100万某宝用户的1亿条行为数据分析
#### <span style="color:yellow">----该项目于2024年跟做完成>>用于学习!!!<<具体详细过程可在我的[CSDN](https://blog.csdn.net/m0_62123085/article/details/140627137?spm=1001.2014.3001.5501)中查看--------</span>
## <span style="color:green">1. 项目背景及意义
#### 背景
随着互联网和电商的发展，人们现在早已经习惯于网上购物。

在国内，电商平台深受欢迎，每年的双11，双12,女神节,以及618狂欢活动，大量的用户在淘宝平台浏览商品，或收藏或加入购物车或直接购买。

通过对用户的行为分析，探索用户购买的规律，了解商品的受欢迎程度，结合店铺的营销策略，实现更加精细和精准的运营，让业务获得更好的增长

#### 意义

| 角度                 | 意义                                        | 具体方向 |
|--------------------|:------------------------------------------|--|
| 电商平台            | 用户行为理解<br/>个性化推荐优化<br/>营销策略调整<br/>风险管理与防范 | ①通过分析用户的行为数据，电商平台可以深入了解用户的购物习惯、偏好和需求 <br/>②利用这些数据，平台可以构建更加精准的个性化推荐系统，提高用户的购物体验和满意度<br/>③ 数据分析可以帮助电商平台调整营销策略，比如确定最佳的促销时段、针对特定用户群体的促销活动等<br/>④识别异常行为模式，如刷单、欺诈等，及时采取措施保护平台和用户的权益|
| 商家              | 市场趋势把握<br/>竞品分析<br/>客户细分与精准营销             |①通过分析整体用户行为数据来把握市场趋势，调整产品线和库存策略<br/>②　了解竞争对手的商品表现，调整自身产品定位和营销策略<br/>③ 基于用户行为数据对客户进行细分，实现更精准的目标市场定位和营销 |
| 消费者 | 提升购物体验<br/>发现潜在需求                         |①个性化推荐使得消费者能够更快地找到自己感兴趣的商品，提升购物效率和满意度<br/>②　数据分析可能揭示消费者自己尚未意识到的需求，引导他们发现新的商品或服务|
#### 对研究人员的意义
社会科学研究：用户行为数据是社会科学研究的宝贵资源，可以用来研究消费行为、社会网络、信息传播等多个领域。
数据科学与算法发展：大规模的用户行为数据为机器学习算法和数据挖掘技术提供了丰富的实验场，推动了相关技术的发展。

#### 本文基于这个问题，针对淘宝用户购物行为数据集进行"获客情况" "留存情况" "时间序列分析" "用户转化率分析" "行为路径分析" "RFM模型" "商品按热度分类

![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/1c4d717107404e438233c4df0c518893.png)


<center><b>图 1 用户行为日内详细分析</b></center>


## 2. 环境准备

<center><b>表 1-1 开发工具和环境</b></center>

| 开发工具/环境            | 版本        | 备注    |
|--------------------|:----------|-------|
| Windows            | Windows10 | 系统    |
| MySQL              |           | 数据库存储 |
| Navicat Premium 17 |           | 编写代码  |


## 3. 项目实现

​	**该项目一共分为三个子任务完成 : 数据采集—数据预处理—数据分析/可视化。**

**本项目的数据集来之阿里天池的 [淘宝用户购物行为数据集](https://tianchi.aliyun.com/dataset/649)** <<<<< **可点击中具体查看**


### 数据集介绍
UserBehavior.csv
本数据集包含了2017年11月25日至2017年12月3日之间，有行为的约一百万随机用户的所有行为（行为包括点击、购买、加购、喜欢）。

数据集的组织形式和MovieLens-20M类似，即数据集的每一行表示一条用户行为，由用户ID、商品ID、商品类目ID、行为类型和时间戳组成，并以逗号分隔。

关于数据集中每一列的详细描述如下：



![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/2acc4bd035f54370b307d2119518a211.png)
<center><b>图 2 数据集详情</b></center>

### 实验环境准备:

**一:MySQL的安装**

**二:Navicat Premium 17的安装**

### 数据库准备:
**一:在MySQL中创建相关数据库**

```sql
create database taobao;
use taobao;
create table user_behavior (
  user_id int(9), item_id int(9), 
  category_id int(9), 
  behavior_type varchar(5), 
  timestamp int(14)
);
```

**二:在Navicat Premium 通过导入向导将数据导入(但是数据量可能过大,会导致导入速度很慢)**

![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/8feefb1d77714d6b9c1d34f5a3811135.png)

**PS:你可以通过kettle以及安装必要的JDK,通过设置运行kettle来进行数据传输,具体看官方介绍:**

 **可点击具体查看**>>>>>>>>>**[kettle](http://www.kettle.org.cn/)** <<<<< **可点击具体查看**

**导入成功后可以看到如下:<此时的timestamp已经变成了timestamps,因为这张图是后面截取的**

![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/ef362ba4acaa437e8c80778940c0f1f8.png)

### 数据处理与分析
#### 一:数据预处理

![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/330f7bc823c144c8b814921d5d9ae4aa.png)

<center><b>图 3 项目预处理流程图</b></center>

1.首先我们改变字段名:将timestamp改为timestamps,避免与数据类型混淆     PS:上图是过程中的图,已经改过了
![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/9c302832406645a8974a5d7ac3ae955d.png)

2.接着我们检查空值项:(并没有存在)
![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/96efd92b27494265974c80fb3bd5b3e3.png)

3.在去重前,我们将每一条记录添加一个id,并设置为主键
![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/882d1479e0bc46fcab0e890b734830e9.png)

4.主键id自增后,我们可以看到相应的id数值
![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/c6d465b814ee4d948f2b7968fce3817c.png)

**5.为了加快处理速度,我们增大buffer的值**
```sql
-- 更改buffer值
show VARIABLES like '%_buffer%';
set GLOBAL innodb_buffer_pool_size=1070000000;
```
6.新增datetimes字段
```sql
-- datetime
alter table user_behavior add datetimes TIMESTAMP(0);
update user_behavior set datetimes=FROM_UNIXTIME(timestamps);
select * from user_behavior limit 5;
```
![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/f0b672a8f12e44aca55af22a4111a4a2.png)

7.同理,我们添加data,time,以及hours字段(此过程非常漫长,因为我们处理的是一亿级别的数据量)
![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/c79903d9c7e94b9aaf035981ea7a3350.png)

**>>>>>>>>>>>>注:直接运行注释的这个,分别运行三个花费时间太长了**
![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/c79903d9c7e94b9aaf035981ea7a3350.png)
```sql
--在代码中直接运行这个
 update user_behavior set dates=substring(datetimes,1,10),times=substring(datetimes,12,8),hours=substring(datetimes,12,2);

--不要运行这个
update user_behavior set dates=substring(datetimes,1,10);
update user_behavior set times=substring(datetimes,12,8);
update user_behavior set hours=substring(datetimes,12,2);
```
8.最终添加了各个时间字段维度处理结果如下
![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/df5ade059d6f4d9883415265c608ba2d.png)

9.查询一下数据的时间段,通过查看最大和最小时间段

**这里就存在异常数据>>>>>2037-04-09以及1970-01-01<<<<<<<**
![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/18f33a79f73a4f938a5dfd9d6bf318e9.png)

10.我们删除时间段不在2017-11-25 00:00:00和2017-12-03 23:59:59之间的时间段

保留从  2017-11-25 00:00:00  到  2017-12-03 23:59:59  之间,共处理了5万多条数据
![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/744a0b555900475ab084abad17883f39.jpeg)

最终处理完的数据如下:
![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/1c78b4db3bac4b29ab0e0fdfac4c8a11.png)

![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/25b1243f1e8b417291f0dfb3b94a809b.png)

#### 二:获客情况
![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/0c60ade8341a43a6afc4a8162a409688.png)
1.首先创建temp_behavior临时表来拉取储存来自user_behavior中的10万条数据,通过小样本数据来处理避免出现失误,造成数据破坏,带来不必要的麻烦
temp_behavior临时表如下
![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/ea2ef577826b4bb79f3508e5b939cc21.png)

2.首先处理临时表上的 pv,uv以及浏览深度pv/uv
![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/da9ce31ba9bb43be83837691027782e1.png)

3.我们对原表进行处理-- 处理真实数据user_behavior
-- 创建pv_uv_puv来存储页面浏览量,独立访客数以及浏览深度pv/uv
![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/b6e1f09f9ddb48f198d7252389796a13.png)

##### 三:留存情况
![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/17704a0ce95d41bfb7776aaee19879a1.png)

![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/08ed9f5cd8834923b58efcc2f0d04b9a.png)
<center><b>图4 活跃用户次日留存率</b></center>

##### 四:时间序列分析
![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/221ca22809e14ae38995eaadc44dd453.png)
<center><b>图5 用户购买及收藏加购率日内变化</b></center>

##### 五:用户转化率分析
![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/33b7bc243e4443e19896ebd52bb91d02.png)
<center><b>图6 收藏加购流量转化率</b></center>

##### 六:行为路径分析
![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/fc8f46917b6343a3a29043f716c9434b.png)
<center><b>图7 用户行为路径分析</b></center>

##### 七:RFM模型
![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/0bab97e0968c4cbbb3e0aa713ab1b095.png)
<center><b>图8 用户定位RFM模型</b></center>

##### 八:商品按热度分类
![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/4fd103558cba48d5b98f758bc8c82d81.png)
<center><b>图9 热门商品分析</b></center>


#### 关于>>>"留存情况" "时间序列分析" "用户转化率分析" "行为路径分析" "RFM模型" "商品按热度分类"<<<的具体过程就不在此赘述
#### 具体可见 **[CSDN](https://blog.csdn.net/m0_62123085/article/details/140627137?spm=1001.2014.3001.5501)** 中,因为在Readme文档中编辑加美化有点耗时
