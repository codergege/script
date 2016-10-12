#!/bin/bash
# @file: 
#	switch_tomcat.sh
# @desc:
#	切换 tomcat 版本
#	调用 update_tomcat_setclasspath.sh
#	重启生效
# @Author:
#	codergege
# @Last Update:
#	2016-10-12
# @usage:
#	source switch_tomcat.sh tomcat7
#	source switch_tomcat.sh tomcat8

# path
pwdDir=$pwd
home=/home/codergege
config=/etc/profile
installDir=/usr/local/lib/tomcat
tomcat7=apache-tomcat-7.0.72
tomcat8=apache-tomcat-8.5.6

if [ $1 == "tomcat7" ]; then
	tomcat=$installDir/$tomcat7
elif [ $1 == "tomcat8" ]; then
	tomcat=$installDir/$tomcat8
else
	echo "第一参数必须是 tomcat7 或 tomcat8"
	exit 1
fi

# 将 tomcat 环境变量写入 $config 的函数
function set_tomcat_env() {
	sudo sed -i '$a # Set tomcat environment TOMCAT_HOME' $config
	echo "export TOMCAT_HOME=$tomcat" | sudo tee -a $config
	echo "export CATALINA_HOME=$tomcat" | sudo tee -a $config
	echo "export CATALINA_BASE=$tomcat" | sudo tee -a $config
	sudo sed -i '$a export PATH=$PATH:$TOMCAT_HOME/bin' $config
	source $home/script/update_tomcat_setclasspath.sh
#	# 如果 setclasspath 中没有写入, 那就写入
#	setclasspath=$tomcat/bin/setclasspath.sh
##	echo "======>$setclasspath"
#	if ! sudo grep "javahome" $setclasspath; then
#		javahome=$(cat $config | grep 'JAVA_HOME=' | awk 'BEGIN {FS="="} {print $2}')
#		rm -f /tmp/script
#		touch /tmp/script
#		echo "export JAVA_HOME=$javahome #javahome" >> /tmp/script
#		sudo sed -i '1r /tmp/script' $setclasspath
#		rm -f /tmp/script
#	fi
}

# 删除 $config 文件中的 tomcat 设置 
function remove_tomcat_env() {
	sudo sed -i '/TOMCAT_HOME/d' $config
	sudo sed -i '/CATALINA/d' $config
}

# 删除 $config 文件中的 tomcat 设置 
remove_tomcat_env

# 重新设置 tomcat 环境变量和 setclasspath.sh
set_tomcat_env

# 创建 link 
cd /usr/local/bin
sudo rm -f /usr/local/bin/startup
sudo rm -f /usr/local/bin/tshutdown
sudo ln -s $tomcat/bin/startup.sh startup
sudo ln -s $tomcat/bin/shutdown.sh tshutdown

source $config

cd $pwdDir
echo "tomcat 版本切换成功."
echo "现在 tomcat 版本为 $tomcat"
echo "重启后生效"
