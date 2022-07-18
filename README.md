![author](https://img.shields.io/badge/author-Hayden-blueviolet.svg)
![license](https://img.shields.io/github/license/ghl1024/MySQL_Install.svg)
![last commit](https://img.shields.io/github/last-commit/ghl1024/MySQL_Install.svg)
![issues](https://img.shields.io/github/issues/ghl1024/MySQL_Install.svg)
![stars](https://img.shields.io/github/stars/ghl1024/MySQL_Install.svg)
![forks](https://img.shields.io/github/forks/ghl1024/MySQL_Install.svg)

## :pushpin: 使用说明

- 此脚本为二进制方式自动安装 `mysql5.7`，系统为 `CentOS7.x` 都可，请核对下载的安装介质是否正确。

- 安装前需要将脚本和安装介质传输到相同任意路径下，用 `root` 用户运行此脚本，根据提示输入内容安装即可。

- 脚本分为默认安装、自定义安装、取消安装三个选项；无论哪种选项，都会检查 `/etc/hosts` 中是否有本机 `IP` 与本机 `hostname`，请务必添加。

- [部署文档参考](https://dev.mysql.com/doc/refman/5.7/en/binary-installation.html)

- [ mysql5.7 安装包下载](https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.29-linux-glibc2.12-x86_64.tar)

## :sun_with_face: 1. 默认安装过程如下：

- 快速默认安装，（软件安装在 `/mysql/mysoft` 下，数据目录在 `/mysql/mydata` 下，端口为 `3306`，管理员用户为 `mysqladmin`，管理员密码为 `mysql`）；
- 一定要检察脚本输出的内容，是否有相关的文件系统，如果没有，会在根下自动创建 `/mysql/mysoft` 和 `/mysql/mydata` 后才进行安装；

### 1.1 查看主机名

```bash
[root@aliyun ~]$ hostname
aliyun
```

### 1.2 将 `ip` 和 `hostname` 加入到 `/etc/hosts` 中

```bash
[root@aliyun ~]$ cat > /etc/hosts << EOF
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
172.16.12.54  aliyun
EOF
```

### 1.3 查看 `/etc/hosts`

```bash
[root@aliyun ~]$ cat /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
172.16.12.54  aliyun
```

### 1.4 开始安装

```bash
[root@aliyun ~]$ pwd
/root
```

```bash
[root@aliyun ~]$ wget -c https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.29-linux-glibc2.12-x86_64.tar
```

```bash
[root@aliyun ~]$ git clone https://github.com/ghl1024/MySQL_Install.git
```

```bash
[root@aliyun ~]$ ll
total 680908
-rw-r--r-- 1 root root 697240064 Dec 18 21:54 mysql-5.7.29-linux-glibc2.12-x86_64.tar
drwxr-xr-x 3 root root      4096 Apr 11 16:49 MySQL_Install
```

```bash
[root@aliyun ~]$ sh MySQL_Install/MySQL_install.sh
Check /etc/hosts
check /etc/hosts IP hostname success!

##########################################
# 1,Default Quick Install                #
# 2,Custom Install                       #
# 3,Cancel Install                       #
# Version:MySQL 5.7.18                   #
##########################################

Please Select [1-3] To Continue (Default 1):  1   ###快速默认安装
id: mysql: no such user

uid=600(mysql) gid=600(mysql) groups=600(mysql)

Check /mysql/mysoft and /mysql/mydata
/mysql/mysoft not have lv   ###检测/mysql/mysoft不是lv
/mysql/mysoft dose not exist;
please press y to create /mysql/mysoft,n to quit (Y/N) (Default Y):  Y   ###是否创建目录/mysql/mysoft,在根下。（y,创建;n,不创建）

/mysql/mydata not have lv   ###检测/mysql/mysoft不是lv
/mysql/mydata dose not exist;
please press y to create /mysql/mydata,n to quit (Y/N) (Default Y):  Y   ###是否创建目录/mysql/mydata,在根下。（y,创建;n,不创建）


Check Old Mysql
check old mysql success!

|--------------------------------------------------------------------|
   Os Version:              CentOS Linux release 7.3.1611 (Core)
   MemTotal:                1839 M
   BaseDir:                 /mysql/mysoft
   DataDir:                 /mysql/mydata/3306
   Port   :                 3306
   Server Id:               55186
   Defalut Character:       utf8
   Innodb_buffer_pool_size: 1287 M
   Host Ipaddr:             172.16.12.54
|--------------------------------------------------------------------|

please press y to continue,n to quit (Y/N) (Default Y):  Y   ###列表输出安装信息，核对并确认是否继续安装（y,开始安装;n,取消安装）

/home/mysql/.bash_profile parameters  : success
Starting MySQL..                                           [  OK  ]
*******Sat Apr 11 21:03:09 CST 2020*******
**********Install Sucessful!**********
******* MySQL User: mysqladmin ****   ###输出mysql管理员用户名
******* User Password: mysql ******   ###输出mysql管理员密码
**************************************
[root@aliyun ~]$
```

### 1.5 安装完成查看

```bash
[root@aliyun ~]$ netstat -tnlp|egrep "3306|mysql"
tcp6       0      0 :::3306                 :::*                    LISTEN      3911/mysqld
```

```bash
[root@aliyun ~]$ ps -aux|grep mysql
root      2676  0.0  0.0  11760  1628 pts/0    S    21:03   0:00 /bin/sh /mysql/mysoft/mysql5.7/bin/mysqld_safe --datadir=/mysql/mydata/3306/data --pid-file=/mysql/mydata/3306/mysql.pid
mysql     3911  0.1 15.1 2660972 285380 pts/0  Sl   21:03   0:00 /mysql/mysoft/mysql5.7/bin/mysqld --basedir=/mysql/mysoft/mysql5.7 --datadir=/mysql/mydata/3306/data --plugin-dir=/mysql/mysoft/mysql5.7/lib/plugin --user=mysql --log-error=/mysql/mydata/3306/log/error.log --pid-file=/mysql/mydata/3306/mysql.pid --socket=/mysql/mydata/3306/mysql.sock --port=3306
```

```bash
#使用mysql用户登录
[root@aliyun ~]$ su - mysql
Last login: Sat Apr 11 21:07:01 CST 2020 on pts/0
```

```bash
[mysql@aliyun ~]$ mysql -umysqladmin -pmysql
mysql: [Warning] Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 17
Server version: 5.7.29-log MySQL Community Server (GPL)

Copyright (c) 2000, 2020, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

(mysqladmin@localhost) [(none)]> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
4 rows in set (0.00 sec)

(mysqladmin@localhost) [(none)]>
```

## :sun_with_face: 2. 自定义安装过程如下

- 自定义安装，是根据用户需要安装到指定路径下，（自动创建用户指定的软件目录与数据目录）;
- 如下示例（软件安装在 `/home/mysql/mysoft ` 下，数据目录在 `/home/mysql/mydata` 下，端口为 `3333`，管理员用户为 `root`，管理员密码为 `root`）；

### 2.1 查看主机名

```bash
[root@aliyun ~]$ hostname
aliyun
```

### 2.2 将 `ip` 和 `hostname` 加入到 `/etc/hosts` 中

```bash
[root@aliyun ~]$ cat > /etc/hosts << EOF
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
172.16.12.54  aliyun
EOF
```

### 2.3 查看 `/etc/hosts`

```bash
[root@aliyun ~]$ cat /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
172.16.12.54  aliyun
```

### 2.4 开始安装

```bash
[root@aliyun ~]$ pwd
/root
```

```bash
[root@aliyun ~]$ wget -c https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.29-linux-glibc2.12-x86_64.tar
```

```bash
[root@aliyun ~]$ git clone https://github.com/ghl1024/MySQL_Install.git
```

```bash
[root@aliyun ~]$ ll
total 680908
-rw-r--r-- 1 root root 697240064 Dec 18 21:54 mysql-5.7.29-linux-glibc2.12-x86_64.tar
drwxr-xr-x 3 root root      4096 Apr 11 16:49 MySQL_Install
```

```bash
[root@aliyun ~]$ sh MySQL_Install/MySQL_install.sh
Check /etc/hosts
check /etc/hosts IP hostname success!

##########################################
# 1,Default Quick Install                #
# 2,Custom Install                       #
# 3,Cancel Install                       #
# Version:MySQL 5.7.18                   #
##########################################

Please Select [1-3] To Continue (Default 1):  2   ###选择自定义安装
Please Input MySQL Port (Default 3306):  3333   ###输入端口号(默认为3306)
Please Input MySQL BaseDir (Default /mysql/mysoft):  /home/mysql/mysoft   ###输入软件安装目录(默认为/mysql/mysoft)
Please Input MySQL DataDir (Default /mysql/mydata):  /home/mysql/mydata      ###输入数据文件目录(默认为/mysql/mydata)
Please Input MySQL Server_Id (Default 55186):   ###输入server_id（默认取值为IP后两位的结合，如：192.168.1.124，server_id为1124）
Please Input MySQL Default Character (Default utf8):   ###输入数据库默认字符集（默认为utf8）
Please Input MySQL Innodb_Buffer_size (Default 1287 M):   ###输入innodb_buffer_size大小（默认取值为实际系统内存的70%）

uid=600(mysql) gid=600(mysql) groups=600(mysql)

Do you want to use users (mysql)  (no delet user and rebuild)[y|n] (Default y):  y   ###是否重建mysql用户（y,不重建;n,删除现有mysql用户并重建）

uid=600(mysql) gid=600(mysql) groups=600(mysql)

Check /home/mysql/mysoft and /home/mysql/mydata
/home/mysql/mysoft not have lv   ###检测/home/mysql/mysoft不是lv
/home/mysql/mysoft dose not exist;
please press y to create /home/mysql/mysoft,n to quit (Y/N) (Default Y):  y   ###是否创建目录/home/mysql/mysoft,在根下。（y,创建;n,不创建）

/home/mysql/mydata not have lv   ###检测/home/mysql/mydata不是lv
/home/mysql/mydata dose not exist;
please press y to create /home/mysql/mydata,n to quit (Y/N) (Default Y):  y   ###是否创建目录/home/mysql/mydata,在根下。（y,创建;n,不创建）


Check Old Mysql
check old mysql success!

|--------------------------------------------------------------------|
   Os Version:              CentOS Linux release 7.3.1611 (Core)
   MemTotal:                1839 M
   BaseDir:                 /home/mysql/mysoft
   DataDir:                 /home/mysql/mydata
   Port   :                 3333
   Server Id:               55186
   Defalut Character:       utf8
   Innodb_buffer_pool_size: 1287 M
   Host Ipaddr:             172.16.12.54
|--------------------------------------------------------------------|

please press y to continue,n to quit (Y/N) (Default Y):  y   ###列表输出安装信息，核对并确认是否继续安装（y,开始安装;n,取消安装）

/home/mysql/.bash_profile parameters  : already existed
Starting MySQL..                                           [  OK  ]
*******Sat Apr 11 21:57:52 CST 2020*******
*******Install Sucessful!*******
******* MySQL User: root *******   ###输出mysql管理员用户名
***** User Password : root *****   ###输出mysql管理员密码
********************************
[root@aliyun ~]$
```

### 2.5 安装完成查看

```bash
[root@aliyun ~]$ netstat -tnlp|egrep "3306|mysql"
tcp6       0      0 :::3333                 :::*                    LISTEN      4158/mysqld
[root@aliyun ~]$ ps -aux | grep mysql
root      2923  0.0  0.0  11760  1628 pts/0    S    21:57   0:00 /bin/sh /home/mysql/mysoft/mysql5.7/bin/mysqld_safe --datadir=/home/mysql/mydata/data --pid-file=/home/mysql/mydata/mysql.pid
mysql     4158  0.1 15.3 2660972 288628 pts/0  Sl   21:57   0:00 /home/mysql/mysoft/mysql5.7/bin/mysqld --basedir=/home/mysql/mysoft/mysql5.7 --datadir=/home/mysql/mydata/data --plugin-dir=/home/mysql/mysoft/mysql5.7/lib/plugin --user=mysql --log-error=/home/mysql/mydata/log/error.log --pid-file=/home/mysql/mydata/mysql.pid --socket=/home/mysql/mydata/mysql.sock --port=3333
root      4294  0.0  0.0 112648   968 pts/0    R+   22:07   0:00 grep --color=auto mysql
[root@aliyun ~]$
```

## :sun_with_face: 3. 退出

```bash
[root@aliyun ~]$ sh MySQL_Install/MySQL_install.sh
Check /etc/hosts
check /etc/hosts IP hostname success!

##########################################
# 1,Default Quick Install                #
# 2,Custom Install                       #
# 3,Cancel Install                       #
# Version:MySQL 5.7.18                   #
##########################################

Please Select [1-3] To Continue (Default 1):  3
[root@aliyun ~]$
```
