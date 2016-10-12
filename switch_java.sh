#!/bin/bash
# @file: 
#	switch_java.sh
# @desc:
#	切换 java 版本
#	重启生效
# @Author:
#	codergege
# @Last Update:
#	2016-10-11
# @usage:
#	source switch_java.sh java7
#	source switch_java.sh java8

# path
home=/home/codergege
config=/etc/profile
java7=/usr/local/lib/java/jdk1.7.0_80
java8=/usr/local/lib/java/jdk1.8.0_101

if [ $1 == "java7" ]; then
	jdk=$java7
elif [ $1 == "java8" ]; then
	jdk=$java8
else
	echo "第一参数必须是 java7 或 java8"
	exit 1
fi

# 删除配置文件中的 java 配置
sudo sed -i '/JAVA_HOME/d' $config

# 重新写入
# 将 java 环境变量写入 $config 的函数
function set_java_env() {
	    sudo sed -i '$a # Set java environment JAVA_HOME' $config
		echo "export JAVA_HOME=$jdk" | sudo tee -a $config
		sudo sed -i '$a export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar' $config
		sudo sed -i '$a export PATH=$PATH:$JAVA_HOME/bin' $config
}

set_java_env

source $config

echo "Java 版本切换成功."
echo "现在 java 版本为 $jdk"
echo "重启后生效"


