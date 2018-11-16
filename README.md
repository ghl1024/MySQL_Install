mysql_install_new_v2.sh
1，此脚本为mysql5.7二进制方式自动安装脚本。请核对下载的安装介质是否正确。
2，安装前需要将脚本和安装介质传输到相同任意路径下，用root用户运行脚本，根据提示输入内容安装即可。
3，脚本分为快速默认安装，自定义安装及取消安装三个选项。无论哪种选项，都会检查/etc/hosts中是否有本机IP与本机hostname，请务必添加。
（1）快速默认安装，（软件安装在/mysql/mysoft,数据目录在/mysql/mydata)
		注意：一定要检察脚本输出的内容，是否有相关的文件系统，如果没有，会在根下自动创建/mysql/mysoft,/mysql/mydata后再进行安装。
（2）自定义安装，是根据用户需要安装到指定路径下。（自动创造用户指定的软件目录与数据目录）
（3）退出脚本，取消安装。

1，快速默认安装过程如下：
[root@lvs2 mysql]# sh mysql_install.sh 
check /etc/hosts IP hostname success!
                                         
##########################################
# 1,Default Quick Install                #
# 2,Custom Install                       #
# 3,Cancel Install                       #
# Version:MySQL 5.7.18                   #
##########################################
 
Please Select [1-3] To Continue (Default 1): 1

uid=27(mysql) gid=27(mysql) groups=27(mysql)

Do you want to use users (mysql)  (no delet user and rebuild)[y|n] (Default y):   ---是否重建mysql用户（y,不重建;n,删除现有mysql用户并重建）
Check $base and $data
/mysql/mysoft not have lv    ---检测/mysql/mysoft不是lv
/mysql/mysoft dose not exist;
please press y to create /mysql/mysoft,n to quit (Y/N) (Default Y):  ---是否创建目录/mysql/mysoft,在根下。（y,创建;n,不创建）

/mysql/mydata not have lv    ---检测/mysql/mysoft不是lv
/mysql/mydata dose not exist;
please press y to create /mysql/mydata,n to quit (Y/N) (Default Y):  ---是否创建目录/mysql/mydata,在根下。（y,创建;n,不创建）

               
Check Old Mysql  ---检测并删除旧的mysql软件

check old mysql: mysql-5.1.73-3.el6_5.x86_64
mysql-server-5.1.73-3.el6_5.x86_64
mysql-libs-5.1.73-3.el6_5.x86_64
libdbi-dbd-mysql-0.8.3-5.1.el6.x86_64
mysql-connector-java-5.1.17-6.el6.noarch
mysql-test-5.1.73-3.el6_5.x86_64
mysql-bench-5.1.73-3.el6_5.x86_64
mysql-connector-odbc-5.1.5r1144-7.el6.x86_64 delete success!
             
|--------------------------------------------------------------------|
   Os Version:              Red Hat Enterprise Linux Server release 6.6 (Santiago)                                
   MemTotal:                1862 M                                    
   BaseDir:                 /mysql/mysoft                                     
   DataDir:                 /mysql/mydata/3306                               
   Port   :                 3306                                     
   Defalut Character:       utf8                                     
   Innodb_buffer_pool_size: 1303 M                                 
   Host Ipaddr:             192.168.1.124                                   
|--------------------------------------------------------------------|        
              
please press y to continue,n to quit (Y/N) (Default Y):  ---列表输出安装信息，核对并确认是否继续安装（y,开始安装;n,取消安装）
/home/mysql/.bash_profile parameters  : success
Starting MySQL....                                         [  OK  ]
*******Fri Nov 24 00:57:16 CST 2017*******
**********Install Sucessful!**********
******* MySQL User: hxbmysqladmin ****   ---输出mysql管理员用户名（按照规范root用户修改为hxbmysqladmin）
******* User Password: hxbmysql ******   ---输入mysql管理员用户密码
**************************************


2，自定义安装过程如下：
check /etc/hosts IP hostname success!
                                         
##########################################
# 1,Default Quick Install                #
# 2,Custom Install                       #
# 3,Cancel Install                       #
# Version:MySQL 5.7.18                   #
##########################################
 
Please Select [1-3] To Continue (Default 1):  2
Please Input MySQL Port (Default 3306):               ---输入端口号(默认为3306)
Please Input MySQL BaseDir (Default /mysql/mysoft):   ---输入软件安装目录(默认为/mysql/mysoft)
Please Input MySQL DataDir (Default /mysql/mydata):   ---输入数据文件目录(默认为/mysql/mydata)
Please Input MySQL Server_Id (Default 1124):          ---输入server_id（默认取值为IP后两位的结合，如：192.168.1.124，server_id为1124）
Please Input MySQL Default Character (Default utf8):  ---输入数据库默认字符集（默认为utf8）
Please Input MySQL Innodb_Buffer_size (Default 1303 M):  ---输入innodb_buffer_size大小（默认取值为实际系统内存的70%）

uid=27(mysql) gid=27(mysql) groups=27(mysql)

Do you want to use users (mysql)  (no delet user and rebuild)[y|n] (Default y):  ---是否重建mysql用户（y,不重建;n,删除现有mysql用户并重建）

uid=27(mysql) gid=27(mysql) groups=27(mysql)

Check $base and $data
/mysql/mysoft not have lv    ---检测/mysql/mysoft不是lv
/mysql/mysoft dose not exist;
please press y to create /mysql/mysoft,n to quit (Y/N) (Default Y):  ---是否创建目录/mysql/mysoft,在根下。（y,创建;n,不创建）

/mysql/mydata not have lv    ---检测/mysql/mysoft不是lv
/mysql/mydata dose not exist;
please press y to create /mysql/mydata,n to quit (Y/N) (Default Y):  ---是否创建目录/mysql/mydata,在根下。（y,创建;n,不创建）
               
Check Old Mysql
check old mysql success!
             
|--------------------------------------------------------------------|
   Os Version:              Red Hat Enterprise Linux Server release 6.6 (Santiago)                                
   MemTotal:                1862 M                                    
   BaseDir:                 /mysql/mysoft                                     
   DataDir:                 /mysql/mydata                                     
   Port   :                 3306                                     
   Defalut Character:       utf8                                     
   Innodb_buffer_pool_size: 1303 M                                 
   Host Ipaddr:             192.168.1.124                                   
|--------------------------------------------------------------------|
              
please press y to continue,n to quit (Y/N) (Default Y):  ---列表输出安装信息，核对并确认是否继续安装（y,开始安装;n,取消安装）
/home/mysql/.bash_profile parameters  : success
Starting MySQL....                                         [  OK  ]
*******Fri Nov 24 00:57:16 CST 2017*******
**********Install Sucessful!**********
******* MySQL User: root *******   ---输出mysql管理员用户名
***** User Password : root *****   ---输入mysql管理员用户密码
**************************************






