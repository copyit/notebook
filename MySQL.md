


## 查看表结构

desc 表名称;

### 查看建表sql语句

```
show create table 表名称;
```

----

## MERGE存储引擎

官方文档：http://dev.mysql.com/doc/refman/5.7/en/merge-storage-engine.html

查看能用的引擎：**show engines**

## 创建一个MERGE表：

假设有a,b表，他们的结构完全相同，然后就可以建立一个c表，注意这个表的定义要与a和b表完全一致

```sql
drop table if exists data;
CREATE TABLE c (
   `id` int(11) NOT NULL,
  `data` longtext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE= MRG_MYISAM ,UNION=(a,b);
```

特点：

这种表不会创建额外的索引，但查询起来比视图速度更快；

不能在这种表上建立全文索引

----

## 删除表的冗余

两行只有一列(这里假设为 gettime )不同，删除其中一行

```sql
delete t1 from t as t1, t as t2 where
    t1.id = t2.id and
    t1.其他列=t2.其他列 and
    t1.gettime>t2.gettime;
```

----

## 修改表 alter table

```sql
ALTER IGNORE TABLE `表名称`
MODIFY COLUMN `id`  int(11) NOT NULL FIRST,
MODIFY COLUMN `user` varchar(66) NOT NULL AFTER `id`,
MODIFY COLUMN `content` longtext NOT NULL AFTER `user`,
DROP PRIMARY KEY,
ADD PRIMARY KEY (`id`),
DROP INDEX `a1`,
ADD INDEX `a1` (`user`);
```

----

## 将中文转为拼音 函数

代码在[code/pinyin.sql](code/pinyin.sql)

----

## 从路径URL获取文件名称

来源 http://stackoverflow.com/questions/17090237/extracting-filenames-from-a-path-mysql

使用SUBSTRING_INDEX函数，假设url此行的内容为"http://example.com/some/path/to/filename.zip"

    select SUBSTRING_INDEX(url, '/', -1) as filename;
    
即可得到一列filename，此行数据为"filename.zip"

----

## 查询优化

### explain发现出现了using filesort

> 参考 http://www.ccvita.com/169.html

如果使用了order by或者group by，需要建索引以优化这个查询

group by用了两个列，两列要合在一起创建索引

### 内存表索引的选择

> 参考 https://dev.mysql.com/doc/refman/5.5/en/optimizing-memory-tables.html

内存表的索引应该选择BTREE

----

## 内存表The table is full

修改MySQL的配置文件/etc/mysql/my.cnf，在[mysqld]下添加/修改两行(下面的值仅供参考,请根据实际情况酌情处理)： 

```
tmp_table_size = 256M // 临时表大小 
max_heap_table_size = 256M // 内存表大小 
```

----

## replace函数替换文本

```
update `content` set value=replace(value,"original content","replaced content");
```

注意replace不要反引号

----

## 简单的split功能，文本转数字

表的设计违背了一列只存放一种数据的原则，搞出了这样一个Text类型的列(假设为info)，格式为"用户名: 数值"

现在需要将数值从这一列中提取出来，并转为int类型

```
convert (
	substr(
		`info`,
		locate(':', `info`) + 2
	),
	unsigned integer
)
```

Google关键词：`mysql split string`,`mysql string to int`

参考：

https://stackoverflow.com/questions/14950466/how-to-split-the-name-string-in-mysql

https://stackoverflow.com/questions/5960620/convert-text-into-number-in-mysql-query

----

## mysqld配置参数调优

> 参考：[https://www.linode.com/docs/databases/mysql/how-to-optimize-mysql-performance-using-mysqltuner](https://www.linode.com/docs/databases/mysql/how-to-optimize-mysql-performance-using-mysqltuner)

使用MySQLTuner这个工具得到一些建议：

```
curl -L http://mysqltuner.pl/ | perl
```

对于其最后给出的参数建议照做即可。

`key_buffer`参数是最关键的参数，决定了mysql占用的内存大小

----

## 支持emoji，从utf8升级到utf8mb4

为了让mysql存储[emoji表情](http://getemoji.com/)，需要进行表的变更操作 以及 连接代码的修改

参考[https://stackoverflow.com/questions/26532722/how-to-encode-utf8mb4-in-python](https://stackoverflow.com/questions/26532722/how-to-encode-utf8mb4-in-python)

#### 表的变更 表的每一个`CHAR`，`VARCHAR`和`TEXT`类型的列都要改为使用utf8mb4

举个例子，表名称{tablename}，修改其`user`列和`content`列，以及表的默认字符集：

```sql
ALTER TABLE `{tablename}`
MODIFY COLUMN `user`  varchar(66) CHARACTER SET utf8mb4 NOT NULL AFTER `edittime`,
MODIFY COLUMN `content`  longtext CHARACTER SET utf8mb4 NOT NULL AFTER `user`,
DEFAULT CHARACTER SET=utf8mb4;
```

#### 连接代码的改动

在执行 insert 的 sql语句之前，先执行这三条sql:

```
SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4; 
SET character_set_connection=utf8mb4;
```

----

## 解决 Too many open files 错误

>参考：https://duntuk.com/how-raise-ulimit-open-files-and-mysql-openfileslimit

> https://stackoverflow.com/questions/22495124/cannot-set-limit-of-mysql-open-files-limit-from-1024-to-65535/35515570

系统环境： ubuntu16.04，用apt install mysql-server安装的mysql

这个问题的原因是mysql默认的open_files_limit是1024，在mysql打开1024个文件后就无法再打开新文件，需要修改这个limit，如改为1024000

修改`/etc/mysql/mysql.conf.d/mysqld.cnf`，在[mysqld_safe]和[mysqld]都加入一行：

```
open_files_limit = 1024000
```

在`/etc/security/limits.conf`中加入：

```
* soft nofile 1024000
* hard nofile 1024000
* soft nproc 10240
* hard nproc 10240
```

上述还不够，由于mysql服务被systemd管理，还要修改`/lib/systemd/system/mysql.service`，在最后加入

```
LimitNOFILE = infinity
LimitMEMLOCK = infinity
```

在ubuntu16.04上，这些还不够，还要继续改systemd:
（参考：https://serverfault.com/questions/791729/ubuntu-16-04-server-mysql-open-file-limit-wont-go-higher-than-65536）

```
mkdir /etc/systemd/system/mysql.service.d
tee /etc/systemd/system/mysql.service.d/override.conf <<-'EOF'
[Service]
LimitNOFILE=1024000
EOF
```

然后重启mysql：

```
systemctl daemon-reload
systemctl restart mysql.service
```

使用这两种方法都能看到修改是否生效：

```
ps aux|grep mysqld #找到mysqld的进程ID
cat /proc/上述找到的进程ID/limits | grep files

mysql -u root -p
show global variables like "%open_files_limit%";
```

----

## 解决ubuntu16.04上mysql被apt upgrade自动关闭的问题

问题现象： mysql服务自动退出，查日志`jounralctl -xe|tac|less`发现是`apt upgrade`引起的自动退出

发现这是一个ubuntu16.04的特性，每天凌晨6点会自动apt upgrade安全更新，但不明原因这个更新失败了，apt关掉了mysql服务后由于异常退出并没有重新把mysql服务启动

如果你想关掉自动更新（不建议）：修改`/etc/apt/apt.conf.d/20auto-upgrades`，改为`APT::Periodic::Unattended-Upgrade "0";`

执行`apt upgrade`或者`apt-get install -f`看看，能重现问题（mysql被关掉了），也发现了报错信息：

```
mysql_upgrade: Got error: 2002: Can't connect to local MySQL server through socket '/var/run/mysqld/mysqld.sock' (2) while connecting to the MySQL server
  Upgrade process encountered error and will not continue.
```

然后就查这个报错，发现了这个：https://github.com/chef-cookbooks/mysql/issues/466

人家的解决方案是：`systemctl enable mysql`，然而我执行又遇到了systemd的报错：`Failed to execute operation: Invalid argument`

最终解决方案就是先disable一下

```
systemctl disable mysql
systemctl enable mysql
apt-get install -f
```

----

## NULL转0

用函数IFNULL，写法就是`IFNULL(列名, 0)`

举个例子

```
select sum(IFNULL(score, 0)) from runs;
```

----

## 给MySQL增加一个slave做主从复制

master启用binlog配置server-id；master用mysqldump导出数据库；slave导入，开始slave

### master创建用户

```
GRANT REPLICATION SLAVE ON *.* TO 'slave_user'@'%' IDENTIFIED BY 'password';
FLUSH PRIVILEGES;
```

### master启用binlog

/etc/mysql/conf.d/master.cnf

```
[mysqld]
server-id=1
log-bin=mysql-bin.log
innodb_flush_log_at_trx_commit=1
sync_binlog=1
```

### 搬运数据库

由于binlog是在已经有数据之后才开启的，而mysql不会自己执行全量同步，就只能靠手工搬运sql文件咯

跨地域复制网速是限制因素，就用7z压缩了

```
mysqldump -h 127.0.0.1 -P 3306 -u root -p --opt --single-transaction --comments --hex-blob --dump-date --no-autocommit --all-databases --master-data | 7z a -si dbdump.sql.7z
7z x -so dbdump.sql.7z | mysql -h 127.0.0.1 -u root -p
```

你也可以使用ssh和管道操作，就不用创建文件了：

```
ssh master_server "mysqldump -h 127.0.0.1 -P 3306 -u root -ppassword --opt --single-transaction --comments --hex-blob --dump-date --no-autocommit --all-databases --master-data |gzip" | zcat | mysql -h 127.0.0.1 -u root -ppassword
```

其中`--master-data`很重要，导出的时候就自动带上了master的信息，无需再手工记录

`CHANGE MASTER TO MASTER_LOG_FILE='mysql-bin.000002', MASTER_LOG_POS=15410;`

### 配置slave

实际使用中很容易遇到duplicate key的问题，导致slave线程停住，配置直接忽略这个错误 [参考](https://www.ducea.com/2008/02/13/mysql-skip-duplicate-replication-errors/)

```
server-id               = 2
relay-log               = mysql-relay-bin.log
log_bin                 = mysql-bin.log
slave-skip-errors = 1062
```

```
CHANGE MASTER TO MASTER_HOST='12.34.56.789',MASTER_USER='slave_user', MASTER_PASSWORD='password';
START SLAVE;
SHOW SLAVE STATUS\G
```

### Docker镜像

https://github.com/bitnami/bitnami-docker-mysql

但这个镜像也不会帮你自动完成mysqldump，但配置一个slave还是很省心的

注意权限配置，如果原本数据文件夹不存在，Docker创建的是root用户才能读写，导致容器直接退出，坑的地方在于没有报错信息

```
mkdir -p /srv/mysql-slave/data
chown 1001 /srv/mysql-slave/data -R

docker run -it -v /srv/mysql-slave/my.cnf:/opt/bitnami/mysql/conf/my.cnf:ro -v /srv/mysql-slave/data:/bitnami/mysql/data \
     --name mysql-slave -e MYSQL_REPLICATION_MODE=slave -e MYSQL_REPLICATION_USER=slave_user -e MYSQL_REPLICATION_PASSWORD=password \
      -e MYSQL_MASTER_HOST=12.34.56.789 -e MYSQL_MASTER_PORT_NUMBER=3306 \
      -e MYSQL_MASTER_ROOT_USER=slave_user -e MYSQL_MASTER_ROOT_PASSWORD=password \
      bitnami/mysql:5.7
```

其中MYSQL_MASTER_ROOT_USER虽然人家说要root用户，实际上代码里只是用来select 1，所以用slave_user即可，参见[我提的issue](https://github.com/bitnami/bitnami-docker-mysql/issues/87)

容器启动后一般会由于master的binlog不完整执行sql失败（表不存在），需要继续操作：

修改my.cnf在`[mysqld]`增加`skip-grant-tables` 注意复数，来保证slave可以连上进行操作

然后执行sql语句`STOP SLAVE;` 再执行上述搬运数据库的操作，导入完成后`START SLAVE`

使用`show slave status;`查看slave状态

另外，配合autossh和ssh的端口转发可以避免将mysql端口暴露在外：

```
autossh -M 0 -o ServerAliveInterval=30 -o ServerAliveCountMax=3 -L 172.17.0.1:3306:127.0.0.1:3306 user@12.34.56.789
```

相应地，slave配置的master地址改为172.17.0.1

