#!/bin/bash
# @file: 
#	update_tomcat_setclasspath.sh
# @desc:
#	更新 setclasspath.sh 中的 export JAVA_HOME=
# @Author:
#	codergege
# @Last Update:
#	2016-10-12
# @usage:
#	bash update_tomcat_setclasspath.sh 
#	java 版本切换后, 执行这个脚本对 setclasspath.sh 进行更新

# config
config=/etc/profile
# 获得 tomcat 版本
tomcat=$(cat $config | grep 'TOMCAT_HOME=' | awk 'BEGIN {FS="="} {print $2}')
# 获得 setclasspath
setclasspath=$tomcat/bin/setclasspath.sh

if sudo grep "javahome" $setclasspath; then
	sudo sed -i '/javahome/d' $setclasspath
fi
javahome=$(cat $config | grep 'JAVA_HOME=' | awk 'BEGIN {FS="="} {print $2}')
rm -f /tmp/script
touch /tmp/script
echo "export JAVA_HOME=$javahome #javahome" >> /tmp/script
sudo sed -i '1r /tmp/script' $setclasspath
rm -f /tmp/script
