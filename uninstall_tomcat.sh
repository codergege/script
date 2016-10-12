#!/bin/bash
# @file: 
#	uninstall_tomcat.sh
# @desc:
#	Uninstall tomcat.
#	delete $config 中的 tomcat 设置
#	delete /usr/local/tomcat
#	delete /usr/local/bin 中所有的链接
#	重启生效
# @Author:
#	codergege
# @Last Update:
#	2016-10-12
# @usage:
#	source uninstall_tomcat.sh

# path
home=/home/codergege
config=/etc/profile

# 删除 $config 文件中的 tomcat 设置 
function remove_tomcat_env() {
	sudo sed -i '/TOMCAT_HOME/d' $config
	sudo sed -i '/CATALINA/d' $config
}

remove_tomcat_env

# 删除 /usr/local/tomcat
if [ -d "/usr/local/tomcat" ]; then
	echo "Deleting /usr/local/tomcat"
	sudo rm -rf /usr/local/tomcat
fi

# 删除所有 /usr/local/bin 中的链接
sudo rm -f /usr/local/bin/startup
sudo rm -f /usr/local/bin/tshutdown

source $config
echo "Uninstall tomcat complete"
