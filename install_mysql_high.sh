#!/bin/bash
# @file: 
#	install_mysql_high.sh
# @desc:
#	如果要安装的 mysql 版本改变, 脚本中的一些设置也需要改变
#	1. 判断是否安装了 mysql, 是否存在用户 mysql
#		通过 /usr/local/mysql 文件夹是否存在来判断; 如果存在, echo, exit
#	2. 判断 $home/develop/installation 下是否有对应的包下载好了, 如果没有, 就 wget 到该目录下
#	3. 解压缩到 /usr/local/下
# @Author:
#	codergege
# @Last Update:
#	2016-10-12
# @usage:
#	source install_mysql_high.sh 64
#	source install_mysql_high.sh 32

# home
home=/home/codergege
# 安装包目录
pkgDir=$home/develop/installation
# 安装目录
installDir=/usr/local
# config
config=/etc/profile
# 保存当前目录
pwdDir=$pwd
# mysql 
dataDir=/var/lib/mysql
socketfile=/var/tmp/mysql.sock
logfile=/var/log/mysqld.log
url64=http://cdn.mysql.com//Downloads/MySQL-5.7/mysql-5.7.15-linux-glibc2.5-x86_64.tar
pkg64=$pkgDir/mysql-5.7.15-linux-glibc2.5-x86_64.tar
mysql64=mysql-5.7.15-linux-glibc2.5-x86_64
url32=http://cdn.mysql.com//Downloads/MySQL-5.7/mysql-5.7.15-linux-glibc2.5-i686.tar
pkg32=mysql-5.7.15-linux-glibc2.5-i686.tar
mysql32=mysql-5.7.15-linux-glibc2.5-i686

# 检查输入参数
if [ $1 == "64" ] || [ $1 == "32" ]; then
	echo "安装 $1 位高版本 mysql"
else
	echo "必须加入第一个参数 64 或 32"
	exit 1
fi

# 确定安装包名, 下载网址
if [ $1 == "64" ] ; then
	pkg=$pkg64
	url=$url64
	mysql=$installDir/$mysql64
fi
if [ $1 == "32" ]; then
	pkg=$pkg32
	url=$url32
	mysql=$installDir/$mysql32
fi

# 判断安装包是否存在
cd $pkgDir
if [ -f "$pkg" ]; then
	echo "找到本地安装包, 准备安装..."
else
	echo "未找到本地安装包, 准备下载..."
	wget -P $pkgDir $url
fi

#判断是否有 mysql 账号
acount=$(cat /etc/passwd | grep 'mysql' | cut -c 1-5)
if [ account != "mysql" ]; then
	echo "Not account mysql exists. Creating the account."
	 groupadd mysql
	 useradd -r -g mysql -s /bin/false mysql
fi

# 判断安装目录是否存在
#if [ ! -d "$installDir" ]; then
#	 mkdir -p $installDir
#fi

# 解压到安装目录
## 第一层解压
if [ ! -f $pkg.gz ];then
	tar -xvf $pkg -C $pkgDir
fi
pkg=$pkg.gz
## 第二层, 解压到安装目录
if [ -d "$mysql" ]; then
 rm -rf $mysql
fi
 tar -zxvf $pkg -C $installDir

# 创建 link 
cd $installDir
 rm -f /usr/local/mysql
 ln -s $mysql mysql
mysql=$installDir/mysql

# create mysql-file, chmod
cd mysql
 mkdir mysql-files
# 删除 $dataDir
 rm -rf $dataDir
 mkdir -p $dataDir/data
 chmod 750 mysql-files
 chown -R mysql .
 chgrp -R mysql .
 chown -R mysql $dataDir
 chgrp -R mysql $dataDir

# my.cnf, mysql.server
# mysql 启动方式为 mysql.server start, stop
 rm -f /etc/my.cnf
 cp -a $home/vimwiki/knowledge/config/mysql/mysql_high_my.cnf.wiki /etc/my.cnf
 cp -a support-files/mysql.server bin/mysql.server
 chown mysql /etc/my.cnf
 chgrp mysql /etc/my.cnf

# 加入 /etc/init.d 使开机启动
 rm -f /etc/init.d/mysql
 cp -a support-files/mysql.server /etc/init.d/mysql

# chkconfig --add mysql
# chkconfig --level 345 mysql on
# ubuntu 中使用如下命令
cd /etc/init.d
 update-rc.d mysql defaults 345
# 卸载使用如下命令
#cd /etc/init.d
# update-rc.d -f mysql remove

# 删除 sock, log
rm -f $socketfile
rm -f $logfile

# 将 /usr/local/mysql/bin 加入 PATH
function set_mysql_env() {
	 sed -i '$a # Set mysql environment MYSQL_HOME' $config
	echo "export MYSQL_HOME=$mysql" |  tee -a $config
	 sed -i '$a export PATH=$PATH:$MYSQL_HOME/bin' $config
}

# 删除 $config 文件中的 mysql 设置 
function remove_mysql_env() {
	 sed -i '/MYSQL_HOME/d' $config
}

# set mysql environment
if ! grep "MYSQL_HOME" $config; then
	echo "设置 mysql environment"
	set_mysql_env
else
	echo "$config 中已存在 MYSQL_HOME, 将删除原设置, 并重新设置"
	# 如果已经有了设置, 先删除再写入
	remove_mysql_env
	set_mysql_env
fi

# mysqld
sed -i 's#^basedir=$#basedir='${mysql}'#' /etc/init.d/mysql
sed -i 's#^datadir=$#datadir='${dataDir}/data'#' /etc/init.d/mysql
# 会失败, 没关系
/etc/init.d/mysql start
systemctl daemon-reload

rm $dataDir/data/*
$mysql/bin/mysqld --defaults-file=/etc/my.cnf --user=mysql --initialize-insecure

source $config
cd $pwdDir
echo "========> mysql installed"

#
#shell> bin/mysqld --initialize --user=mysql # MySQL 5.7.6 and up
#shell> bin/mysql_ssl_rsa_setup              # MySQL 5.7.6 and up
#shell> chown -R root .
#shell> chown -R mysql data mysql-files
#shell> bin/mysqld_safe --user=mysql &
# Next command is optional
#shell> cp support-files/mysql.server /etc/init.d/mysql.server
