#!/bin/bash
#####Install Failed Delete MySQL#####
#####rm -rf $base/*
#####rm -rf $data/*
#####rm -rf /etc/init.d/mysqld
#####rm -rf /usr/local/mysql
clear

#check /etc/hosts
echo "Check /etc/hosts"
hostname=`hostname`
host=`cat /etc/hosts|grep $hostname`
if [ -z "$host" ];then
echo 'check /etc/hosts IP hostname Failed!'
exit 0
else
echo 'check /etc/hosts IP hostname success!'
rehost=`echo $host|awk '{print $1}'`
id1=`echo ${rehost#*.}`
id2=`echo ${id1#*.}`
id=`echo $id2|sed 's/\.//g'`
##check memory
mem=`grep MemTotal /proc/meminfo|awk '{print $2}'`
let innobufsiz=$mem*7/10/1024
let mem=$mem/1024
echo "                                         "
echo "##########################################"
echo "# 1,Default Quick Install                #"
echo "# 2,Custom Install                       #"
echo "# 3,Cancel Install                       #"
echo "# Version:MySQL 5.7.18                   #"
echo "##########################################"
echo " "

#####please input : 1,Default Install 2,Custom Install 3,Cancel Install#######
read -p "Please Select [1-3] To Continue (Default 1):  " which
which=${which:=1}
while true
do
case "$which" in
1)
################Default Quick Install################

##Define variables
port=3306
base='/mysql/mysoft'
data='/mysql/mydata'
ser_id=$id
char='utf8'
innodb=$innobufsiz
azlj=`pwd`
##create user
usero=`id mysql|awk '{print $1}'`
if [ -z "$usero" ];then
	/usr/sbin/groupadd -g 600 mysql
	/usr/sbin/useradd -u 600 -g mysql mysql
	echo mysql | passwd mysql --stdin 1>/dev/null
echo ""
	id mysql
echo ""
	else
	echo ""
		id mysql
	echo ""
	echo -n "Do you want to use users (mysql)  ("no" delet user and rebuild)[y|n] (Default y):  "
	read cho
	cho=${cho:='y'}
	echo ""
	while true
	do
		case $cho in

		N|NO|n|no)
		/usr/sbin/userdel -r mysql 2>/dev/null
		/usr/sbin/groupdel mysql 2>/dev/null
		/usr/sbin/groupadd -g 600 mysql
		/usr/sbin/useradd -u 600 -g mysql mysql
	echo mysql | passwd mysql --stdin 1>/dev/null	
        id mysql
  echo ""
   break
   ;;
   Y|YES|y|yes)
        id mysql
      	echo mysql | passwd mysql --stdin 1>/dev/null  
   echo ""
	 break
	 ;;
   exit|EXIT)
        exit
   break
   ;;
	 *)
	  echo -n "Do you want to use users (mysql)  ("no" delet user and rebuild)[y|n] (Default y):  "
	  read cho
	  cho=${cho:='y'}
	  echo ""		
		;;
	 esac
	done
fi

####################os check####################
echo "Check $base and $data"
mysql=`df -hm| grep -w $base | awk '{print $(NF-2)}'`
   if [ ! -n "$mysql" ];then
      echo  "$base not have lv" 
      if [ ! -d "$base" ];then
  			   echo "$base dose not exist;"
  			   echo -n "please press y to create $base,n to quit (Y/N) (Default Y):  " 
				   read cho
					 cho=${cho:='y'}
					 echo ""
					 while true
						 do
							 case $cho in
						    N|NO|n|no)
        		    echo "Please create $base !!!"
        		    echo ""
						    exit
						    ;;
						    Y|YES|y|yes)
						    mkdir -p $base
						    break
						    ;;
						   esac
            done
      fi
   else
      if [ "$mysql" -lt 29000 ];then
		     echo '$base lv must >=30G' 
      fi
   fi
mydata=`df -hm| grep -w $data | awk '{print $(NF-2)}'`
   if [ ! -n "$mydata" ];then
      echo  "$data not have lv" 
      if [ ! -d "$data" ];then
  			   echo "$data dose not exist;"
  			   echo -n "please press y to create $data,n to quit (Y/N) (Default Y):  " 
				   read cho
					 cho=${cho:='y'}
					 echo ""
					 while true
						 do
							 case $cho in
						    N|NO|n|no)
        		    echo "Please create $data !!!"
        		    echo ""
						    exit
						    ;;
						    Y|YES|y|yes)
						    mkdir -p $data
						    break
						    ;;
						   esac
            done
      fi
   else
      if [ "$mydata" -lt 99000 ];then
		     echo '$data lv must >=100G' 
      fi
   fi
echo "               "
##osversion
os=`lsb_release -a|grep Description`
v_version=`echo ${os#*:}`

##check old mysql
echo "Check Old Mysql"
rpm=`rpm -qa | grep mysql`
if [ -z "$rpm" ];then
echo "check old mysql success!"
else
rpm -e $rpm --nodeps
echo "check old mysql: $rpm delete success!"
fi
echo "             "

##print message
echo "|--------------------------------------------------------------------|"
echo "   Os Version:              $v_version                                "
echo "   MemTotal:                $mem M                                    "
echo "   BaseDir:                 $base                                     "
echo "   DataDir:                 $data/$port                               "
echo "   Port   :                 $port                                     "
echo "   Server Id:               $ser_id                                   "
echo "   Defalut Character:       $char                                     "
echo "   Innodb_buffer_pool_size: $innodb M                                 "
echo "   Host Ipaddr:             $rehost                                   "
echo "|--------------------------------------------------------------------|"

echo "              "
echo -n "please press y to continue,n to quit (Y/N) (Default Y):  " 
read cho
cho=${cho:='y'}
echo ""
	while true
	do
		case $cho in

		N|NO|n|no)
		
        echo "Thanks!"
        echo ""
		break
		;;
		Y|YES|y|yes)
##new directory
mkdir -p $data/$port/data
mkdir -p $data/$port/log
mkdir -p $data/$port/binlog
mkdir -p $data/$port/tmp

##edit limits.conf
cat >>/etc/security/limits.conf << END
mysql hard nofile 65535
mysql soft nofile 65535
END

##edit .bash_profile
PROFILES="/home/mysql/.bash_profile"
for PROFILE in $PROFILES ; do
if [ -f "$PROFILE" ] ; then
  if [ -z "$(grep "MySQL" $PROFILE)" ] ; then
    cat >>$PROFILE << END
#MySQL
export MYSQL_HOME=$base
export PATH=\$MYSQL_HOME/mysql5.7/bin:\$PATH
END
    echo "$PROFILE parameters  : success"
  else	
    echo "$PROFILE parameters  : already existed"
  fi
else
  echo "$0: $PROFILE not found "
fi
done
##install software
cd $azlj
tar -xf mysql*5.7*tar* -C $base
cd $base
tar xf mysql-5.7*tar.gz
ln -s mysql-5.7*-x86_64 mysql5.7
chown -R mysql:mysql $base
chown -R mysql:mysql $data
chmod -R 755 $data
#cd /usr/local
#ln -s $base/mysql5.7 /usr/local/mysql
rm -rf /etc/my.cnf
M="M"
cnf="/etc/my.cnf"
cat >>$cnf << END
[client]
port		= $port
socket		= $data/$port/mysql.sock

[mysql]
no-auto-rehash
prompt=(\\u@\\h) [\\d]>\\_

[mysqld]
# basic settings #
server_id = $ser_id
user = mysql
port = $port
basedir = $base/mysql5.7
datadir = $data/$port/data
socket = $data/$port/mysql.sock
pid-file = $data/$port/mysql.pid
log_error = $data/$port/log/error.log
sql_mode = "STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION,NO_ZERO_DATE,NO_ZERO_IN_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER"
autocommit = 1
character_set_server=$char
transaction_isolation = READ-COMMITTED
explicit_defaults_for_timestamp = 1
max_allowed_packet = 16777216
event_scheduler = 1
tmpdir = $data/$port/tmp
log_timestamps=system
lower_case_table_names = 1

# connection #
interactive_timeout = 43200
wait_timeout = 43200
lock_wait_timeout = 43200
skip_name_resolve = 1
max_connections = 2000
max_connect_errors = 100000

# table cache performance settings #
table_open_cache = 4096
table_definition_cache = 4096
table_open_cache_instances = 64

# session memory settings #
read_buffer_size = 16M
read_rnd_buffer_size = 32M
sort_buffer_size = 32M
tmp_table_size = 64M
join_buffer_size = 128M
thread_cache_size = 64

# log settings #
slow_query_log  = 1
slow_query_log_file = $data/$port/log/slow.log
log_queries_not_using_indexes = 1
log_slow_admin_statements = 1
log_slow_slave_statements = 1
log_throttle_queries_not_using_indexes = 10
expire_logs_days = 7
long_query_time = 2
min_examined_row_limit = 100
binlog-rows-query-log-events = 1
log-bin-trust-function-creators = 1
max_binlog_size = 512M

# InnoDB settings #
innodb_page_size = 16384
innodb_data_file_path = ibdata1:1G:autoextend
innodb_buffer_pool_size = $innodb$M
innodb_buffer_pool_instances = 16
innodb_buffer_pool_load_at_startup = 1
innodb_buffer_pool_dump_at_shutdown = 1
innodb_lru_scan_depth = 4096
innodb_lock_wait_timeout  = 50
innodb_io_capacity = 10000
innodb_io_capacity_max = 20000
innodb_flush_method = O_DIRECT
innodb_file_format = Barracuda
innodb_file_format_max = Barracuda
innodb_undo_logs = 128
innodb_undo_tablespaces = 3
innodb_flush_neighbors = 0
innodb_log_buffer_size = 16777216
innodb_log_file_size = 1048576000
innodb_log_files_in_group = 3
innodb_purge_threads = 4
innodb_large_prefix = 1
innodb_thread_concurrency = 64
innodb_print_all_deadlocks = 1
innodb_strict_mode = 1
innodb_sort_buffer_size = 67108864
innodb_write_io_threads = 16
innodb_read_io_threads = 16
innodb_file_per_table = 1
innodb_stats_persistent_sample_pages = 64
innodb_autoinc_lock_mode = 2
innodb_online_alter_log_max_size = 1G
innodb_open_files = 4096
innodb_flush_log_at_trx_commit = 1

# Myisam settings #
myisam_max_sort_file_size=512M
myisam_sort_buffer_size	 =8M

# replication settings #
#read_only = 1
skip_slave_start = 1
slave_parallel_workers = 4
slave_parallel_type = 'LOGICAL_CLOCK'
slave_preserve_commit_order = on
master_info_repository = table
relay_log_info_repository = table
sync_binlog = 1
gtid_mode = on
enforce_gtid_consistency = 1
log-slave-updates = 1
log_bin = $data/$port/binlog/mysql-bin
log_bin_index = $data/$port/binlog/binlog.index
binlog_format = row
binlog_row_image = minimal
binlog_rows_query_log_events = 1
#relay_log_index = $data/$port/binlog/relaylog.index
#relay_log = $data/$port/binlog/relay.log
#relay_log_recovery = 1
#slave_skip_errors = ddl_exist_errors
#slave-rows-search-algorithms = 'INDEX_SCAN,HASH_SCAN'

# semi sync replication settings #
#plugin_load = "validate_password.so;rpl_semi_sync_master=semisync_master.so;rpl_semi_sync_slave.so'
#rpl_semi_sync_master_enabled = 1
#rpl_semi_sync_master_timeout = 3000
#rpl_semi_sync_slave_enabled= 1

# password plugin #
#validate_password_policy = strong
#validate-password = force_plus_permanent

END
chown mysql:mysql /etc/my.cnf
$base/mysql5.7/bin/mysqld --initialize --user=mysql
cd $base/mysql5.7/support-files/
cp mysql.server /etc/init.d/mysqld
chkconfig --add mysqld
chkconfig --level 345 mysqld on
service mysqld start
pass=`cat $data/$port/log/error.log | grep "A temporary password is" | awk '{print $NF}'`
sed -i "/\[client\]/a\user=root" /etc/my.cnf
sed -i "/\user=/a\password='$pass'" /etc/my.cnf
cat >>/etc/profile <<EOF
export PATH=$base/mysql5.7/bin:\$PATH
EOF
source /etc/profile
mysql --connect-expired-password -e "set password='mysql';"
sed -i '/user=/d' /etc/my.cnf
sed -i '/password=/d' /etc/my.cnf
mysql -uroot -pmysql -e "update mysql.user set User='mysqladmin' where user='root' and host='localhost';">/dev/null 2>/dev/null
mysql -uroot -pmysql -e "flush privileges;">/dev/null 2>/dev/null
mysql -umysqladmin -pmysql -e "create user @'%' identified by '';">/dev/null 2>/dev/null
mysql -umysqladmin -pmysql -e "grant process,replication client on *.* to @'%';">/dev/null 2>/dev/null
mysql -umysqladmin -pmysql -e "grant select on sys.* to @'%';">/dev/null 2>/dev/null
mysql -umysqladmin -pmysql -e "grant select on performance_schema.* to @'%';">/dev/null 2>/dev/null
mysql -umysqladmin -pmysql -e "create user tivoli@'%' identified by 'tivoli';">/dev/null 2>/dev/null
mysql -umysqladmin -pmysql -e "grant process,replication client on *.* to tivoli@'%';">/dev/null 2>/dev/null
mysql -umysqladmin -pmysql -e "grant select on sys.* to tivoli@'%';">/dev/null 2>/dev/null
mysql -umysqladmin -pmysql -e "grant select on performance_schema.* to tivoli@'%';">/dev/null 2>/dev/null
mysql -umysqladmin -pmysql -e "create user sjwh@'%' identified by 'sjwh';">/dev/null 2>/dev/null
mysql -umysqladmin -pmysql -e "grant SELECT, UPDATE, INSERT, DELETE, CREATE, DROP, RELOAD, PROCESS, FILE, REFERENCES, INDEX, ALTER, SHOW DATABASES,CREATE TEMPORARY TABLES, LOCK TABLES, EXECUTE, CREATE VIEW, SHOW VIEW, CREATE ROUTINE, ALTER ROUTINE, CREATE USER, EVENT, TRIGGER, CREATE TABLESPACE on *.* to sjwh@'%';">/dev/null 2>/dev/null
sed -i '$d' /etc/profile
source /etc/profile
sed -i "/\[client\]/a\user=" /etc/my.cnf
sed -i "/\user=/a\password=" /etc/my.cnf
suce=`ps -ef | grep mysqld|wc -l`
if [ $suce -gt 2 ] ; then
echo "*******`date`*******"
echo "**********Install Sucessful!**********"
echo "******* MySQL User: mysqladmin ****"
echo "******* User Password: mysql ******"
echo "**************************************"
else
echo "*******`date`*******"
echo "***Install Failed,Please Check!***"
echo "**********************************"
fi
rm -rf /var/lock/subsys/mysql
		break
		;;
   exit|EXIT)
      exit
      break
      ;;
   *)
      echo -n "please press y to continue,n to quit (Y/N):" 
	    read cho
	    echo ""		
	    ;;
	    esac
	  done		
break
;;        
2)
################Default Quick Install################

##Define variables
read -p "Please Input MySQL Port (Default 3306):  " port
port=${port:=3306}
read -p "Please Input MySQL BaseDir (Default /mysql/mysoft):  " base
base=${base:='/mysql/mysoft'}
read -p "Please Input MySQL DataDir (Default /mysql/mydata):  " data
data=${data:='/mysql/mydata'}
read -p "Please Input MySQL Server_Id (Default $id):  " ser_id
ser_id=${ser_id:=$id}
read -p "Please Input MySQL Default Character (Default utf8):  " char
char=${char:='utf8'}
read -p "Please Input MySQL Innodb_Buffer_size (Default $innobufsiz M):  " innodb
innodb=${innodb:=$innobufsiz}
azlj=`pwd`
##create user
usero=`id mysql|awk '{print $1}'`
if [ -z "$usero" ];then
	/usr/sbin/groupadd -g 600 mysql
	/usr/sbin/useradd -u 600 -g mysql mysql
	echo mysql | passwd mysql --stdin 1>/dev/null
echo ""
	id mysql
echo ""
	else
	echo ""
		id mysql
	echo ""
	echo -n "Do you want to use users (mysql)  ("no" delet user and rebuild)[y|n] (Default y):  "
	read cho
	cho=${cho:='y'}
	echo ""
	while true
	do
		case $cho in

		N|NO|n|no)
		/usr/sbin/userdel -r mysql 2>/dev/null
		/usr/sbin/groupdel mysql 2>/dev/null
		/usr/sbin/groupadd -g 600 mysql
		/usr/sbin/useradd -u 600 -g mysql mysql
	echo mysql | passwd mysql --stdin 1>/dev/null	
        id mysql
  echo ""
   break
   ;;
   Y|YES|y|yes)
        id mysql
      	echo mysql | passwd mysql --stdin 1>/dev/null  
   echo ""
	 break
	 ;;
   exit|EXIT)
        exit
   break
   ;;
	 *)
	  echo -n "Do you want to use users (mysql)  ("no" delet user and rebuild)[y|n] (Default y):  "
	  read cho
	  cho=${cho:='y'}
	  echo ""		
		;;
	 esac
	done
fi

####################os check####################
echo "Check $base and $data"
mysql=`df -hm| grep -w $base | awk '{print $(NF-2)}'`
   if [ ! -n "$mysql" ];then
      echo  "$base not have lv" 
      if [ ! -d "$base" ];then
  			   echo "$base dose not exist;"
  			   echo -n "please press y to create $base,n to quit (Y/N) (Default Y):  " 
				   read cho
					 cho=${cho:='y'}
					 echo ""
					 while true
						 do
							 case $cho in
						    N|NO|n|no)
        		    echo "Please create $base !!!"
        		    echo ""
						    exit
						    ;;
						    Y|YES|y|yes)
						    mkdir -p $base
						    break
						    ;;
						   esac
            done
      fi
   else
      if [ "$mysql" -lt 29000 ];then
		     echo '$base lv must >=30G' 
      fi
   fi
mydata=`df -hm| grep -w $data | awk '{print $(NF-2)}'`
   if [ ! -n "$mydata" ];then
      echo  "$data not have lv" 
      if [ ! -d "$data" ];then
  			   echo "$data dose not exist;"
  			   echo -n "please press y to create $data,n to quit (Y/N) (Default Y):  " 
				   read cho
					 cho=${cho:='y'}
					 echo ""
					 while true
						 do
							 case $cho in
						    N|NO|n|no)
        		    echo "Please create $data !!!"
        		    echo ""
						    exit
						    ;;
						    Y|YES|y|yes)
						    mkdir -p $data
						    break
						    ;;
						   esac
            done
      fi
   else
      if [ "$mydata" -lt 99000 ];then
		     echo '$data lv must >=100G' 
      fi
   fi
echo "               "
##osversion
os=`lsb_release -a|grep Description`
v_version=`echo ${os#*:}`

##check old mysql
echo "Check Old Mysql"
rpm=`rpm -qa | grep mysql`
if [ -z "$rpm" ];then
echo "check old mysql success!"
else
rpm -e $rpm --nodeps
echo "check old mysql: $rpm delete success!"
fi
echo "             "

##print message
echo "|--------------------------------------------------------------------|"
echo "   Os Version:              $v_version                                "
echo "   MemTotal:                $mem M                                    "
echo "   BaseDir:                 $base                                     "
echo "   DataDir:                 $data                                     "
echo "   Port   :                 $port                                     "
echo "   Server Id:               $ser_id                                   "
echo "   Defalut Character:       $char                                     "
echo "   Innodb_buffer_pool_size: $innodb M                                 "
echo "   Host Ipaddr:             $rehost                                   "
echo "|--------------------------------------------------------------------|"

echo "              "
echo -n "please press y to continue,n to quit (Y/N) (Default Y):  " 
read cho
cho=${cho:='y'}
echo ""
	while true
	do
		case $cho in

		N|NO|n|no)
		
        echo "Thanks!"
        echo ""
		break
		;;
		Y|YES|y|yes)
##new directory
mkdir -p $data/data
mkdir -p $data/log
mkdir -p $data/binlog
mkdir -p $data/tmp

##edit limits.conf
cat >>/etc/security/limits.conf << END
mysql hard nofile 65535
mysql soft nofile 65535
END

##edit .bash_profile
PROFILES="/home/mysql/.bash_profile"
for PROFILE in $PROFILES ; do
if [ -f "$PROFILE" ] ; then
  if [ -z "$(grep "MySQL" $PROFILE)" ] ; then
    cat >>$PROFILE << END
#MySQL
export MYSQL_HOME=$base
export PATH=\$MYSQL_HOME/mysql5.7/bin:\$PATH
END
    echo "$PROFILE parameters  : success"
  else	
    echo "$PROFILE parameters  : already existed"
  fi
else
  echo "$0: $PROFILE not found "
fi
done
##install software
cd $azlj
tar -xf mysql*5.7*tar* -C $base
cd $base
tar xf mysql-5.7*-x86_64.tar.gz
ln -s mysql-5.7*-x86_64 mysql5.7
chown -R mysql:mysql $base
chown -R mysql:mysql $data
chmod -R 755 $data
#cd /usr/local
#ln -s $base/mysql5.7 /usr/local/mysql
rm -rf /etc/my.cnf
M="M"
cnf="/etc/my.cnf"
cat >>$cnf << END
[client]
port		= $port
socket		= $data/mysql.sock

[mysql]
no-auto-rehash
prompt=(\\u@\\h) [\\d]>\\_

[mysqld]
# basic settings #
server_id = $ser_id
user = mysql
port = $port
basedir = $base/mysql5.7
datadir = $data/data
socket = $data/mysql.sock
pid-file = $data/mysql.pid
log_error = $data/log/error.log
sql_mode = "STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION,NO_ZERO_DATE,NO_ZERO_IN_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER"
autocommit = 1
character_set_server=$char
transaction_isolation = READ-COMMITTED
explicit_defaults_for_timestamp = 1
max_allowed_packet = 16777216
event_scheduler = 1
tmpdir = $data/tmp
log_timestamps=system
lower_case_table_names = 1

# connection #
interactive_timeout = 43200
wait_timeout = 43200
lock_wait_timeout = 43200
skip_name_resolve = 1
max_connections = 2000
max_connect_errors = 100000

# table cache performance settings #
table_open_cache = 4096
table_definition_cache = 4096
table_open_cache_instances = 64

# session memory settings #
read_buffer_size = 16M
read_rnd_buffer_size = 32M
sort_buffer_size = 32M
tmp_table_size = 64M
join_buffer_size = 128M
thread_cache_size = 64

# log settings #
slow_query_log  = 1
slow_query_log_file = $data/log/slow.log
log_queries_not_using_indexes = 1
log_slow_admin_statements = 1
log_slow_slave_statements = 1
log_throttle_queries_not_using_indexes = 10
expire_logs_days = 7
long_query_time = 2
min_examined_row_limit = 100
binlog-rows-query-log-events = 1
log-bin-trust-function-creators = 1
max_binlog_size = 512M

# InnoDB settings #
innodb_page_size = 16384
innodb_data_file_path = ibdata1:1G:autoextend
innodb_buffer_pool_size = $innodb$M
innodb_buffer_pool_instances = 16
innodb_buffer_pool_load_at_startup = 1
innodb_buffer_pool_dump_at_shutdown = 1
innodb_lru_scan_depth = 4096
innodb_lock_wait_timeout  = 50
innodb_io_capacity = 10000
innodb_io_capacity_max = 20000
innodb_flush_method = O_DIRECT
innodb_file_format = Barracuda
innodb_file_format_max = Barracuda
innodb_undo_logs = 128
innodb_undo_tablespaces = 3
innodb_flush_neighbors = 0
innodb_log_buffer_size = 16777216
innodb_log_file_size = 1048576000
innodb_log_files_in_group = 3
innodb_purge_threads = 4
innodb_large_prefix = 1
innodb_thread_concurrency = 64
innodb_print_all_deadlocks = 1
innodb_strict_mode = 1
innodb_sort_buffer_size = 67108864
innodb_write_io_threads = 16
innodb_read_io_threads = 16
innodb_file_per_table = 1
innodb_stats_persistent_sample_pages = 64
innodb_autoinc_lock_mode = 2
innodb_online_alter_log_max_size = 1G
innodb_open_files = 4096
innodb_flush_log_at_trx_commit = 1

# Myisam settings #
myisam_max_sort_file_size=512M
myisam_sort_buffer_size	 =8M

# replication settings #
#read_only = 1
skip_slave_start = 1
slave_parallel_workers = 4
slave_parallel_type = 'LOGICAL_CLOCK'
slave_preserve_commit_order = on
master_info_repository = table
relay_log_info_repository = table
sync_binlog = 1
gtid_mode = on
enforce_gtid_consistency = 1
log-slave-updates = 1
log_bin = $data/binlog/mysql-bin
log_bin_index = $data/binlog/binlog.index
binlog_format = row
binlog_row_image = minimal
binlog_rows_query_log_events = 1
#relay_log_index = $data/binlog/relaylog.index
#relay_log = $data/binlog/relay.log
#relay_log_recovery = 1
#slave_skip_errors = ddl_exist_errors
#slave-rows-search-algorithms = 'INDEX_SCAN,HASH_SCAN'

# semi sync replication settings #
#plugin_load = "validate_password.so;rpl_semi_sync_master=semisync_master.so;rpl_semi_sync_slave.so'
#rpl_semi_sync_master_enabled = 1
#rpl_semi_sync_master_timeout = 3000
#rpl_semi_sync_slave_enabled= 1

# password plugin #
#validate_password_policy = strong
#validate-password = force_plus_permanent

END
chown mysql:mysql /etc/my.cnf
$base/mysql5.7/bin/mysqld --initialize --user=mysql
cd $base/mysql5.7/support-files/
cp mysql.server /etc/init.d/mysqld
chkconfig --add mysqld
chkconfig --level 345 mysqld on
service mysqld start
pass=`cat $data/log/error.log | grep "A temporary password is" | awk '{print $NF}'`
sed -i "/\[client\]/a\user=root" /etc/my.cnf
sed -i "/\user=/a\password='$pass'" /etc/my.cnf
cat >>/etc/profile <<EOF
export PATH=$base/mysql5.7/bin:\$PATH
EOF
source /etc/profile
mysql --connect-expired-password -e "set password='root';"
sed -i '/user=/d' /etc/my.cnf
sed -i '/password=/d' /etc/my.cnf
sed -i '$d' /etc/profile
source /etc/profile
suce=`ps -ef | grep mysqld|wc -l`
if [ $suce -gt 2 ] ; then
echo "*******`date`*******"
echo "*******Install Sucessful!*******"
echo "******* MySQL User: root *******"
echo "***** User Password : root *****"
echo "********************************"
else
echo "*******`date`*******"
echo "***Install Failed,Please Check!***"
echo "**********************************"
fi
rm -rf /var/lock/subsys/mysql
		break
		;;
   exit|EXIT)
      exit
      break
      ;;
   *)
      echo -n "please press y to continue,n to quit (Y/N):" 
	    read cho
	    echo ""		
	    ;;
	    esac
	  done
break
;;

3)
################Cancel Install################

break
;;

*)
read -p "please select [1-3] to continue :" which
;;

esac

done
fi
