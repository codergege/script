#!/bin/bash
# @file: 
#	uninstall_groovy.sh
# @desc:
#	Uninstall tomcat.
#	delete $config 中的 groovy 设置
#	delete /usr/local/groovy
#	重启
# @Author:
#	codergege
# @Last Update:
#	2016-10-20 
# @usage:
#	source uninstall_groovy.sh

# path
home=/home/codergege
config=/etc/profile

# 删除 $config 文件中的 tomcat 设置 
function remove_groovy_env() {
	sudo sed -i '/GROOVY_HOME/d' $config
}

remove_groovy_env

# 删除 /usr/local/groovy
if [ -d "/usr/local/groovy" ]; then
	echo "Deleting /usr/local/groovy"
	sudo rm -rf /usr/local/groovy
fi

source $config
echo "Uninstall groovy complete"
