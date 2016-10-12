#!/bin/bash
# @file: 
#	uninstall_java.sh
# @desc:
#	Uninstall java.
#	delete JAVA_HOME, CLASSPATH, 有 $JAVA_HOME 的 PATH -- 从 /etc/environment, ~/.bashrc, /etc/profile, ~/.profile 中删除
#	delete /usr/local/lib/java
#	delete /usr/lib/jvm
#	delete /etc/alternatives 中所有的 java 链接
#	重启生效
# @Author:
#	codergege
# @Last Update:
#	2016-10-11
# @usage:
#	bash uninstall_java.sh

# path
home=/home/codergege
env=/etc/environment
bashrc=$home/.bashrc
profile=/etc/profile
userProfile=$home/.profile

# 判断 env, bashrc, profile, userProfile 是否存在
# 如果存在, 则删除 含 JAVA_HOME 的行
if [ -f "$env" ]; then
	sudo sed -i '/JAVA_HOME/d' $env
fi
if [ -f "$bashrc" ]; then
	sudo sed -i '/JAVA_HOME/d' $bashrc
fi
if [ -f "$profile" ]; then
	sudo sed -i '/JAVA_HOME/d' $profile
fi
if [ -f "$userProfile" ]; then
	sudo sed -i '/JAVA_HOME/d' $userProfile
fi

# 删除 /usr/local/lib/java, /usr/lib/jvm
if [ -d "/usr/local/lib/java" ]; then
	echo "Deleting /usr/local/lib/java"
	sudo rm -rf /usr/local/lib/java
fi
if [ -d "/usr/lib/jvm" ]; then
	echo "Deleting /usr/lib/jvm"
	sudo rm -rf /usr/lib/jvm
fi

# 删除 /etc/alternatives 中所有的 java 链接
links=$(ls -al /etc/alternatives | grep 'java' | awk '{print $(NF-2)}')
cd /etc/alternatives
for link in $links
do
	sudo rm -rf $link
done

echo "Uninstall java complete"
