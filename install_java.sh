#!/bin/bash
# @file: 
#	install_java.sh
# @desc:
#	Install java.
#	jdk-7u80-linux-i586.tar.gz	http://download.oracle.com/otn/java/jdk/7u80-b15/jdk-7u80-linux-i586.tar.gz 
#	jdk-7u80-linux-x64.tar.gz	http://download.oracle.com/otn/java/jdk/7u80-b15/jdk-7u80-linux-x64.tar.gz
#	jdk-8u101-linux-i586.tar.gz	http://download.oracle.com/otn-pub/java/jdk/8u101-b13/jdk-8u101-linux-i586.tar.gz
#	jdk-8u101-linux-x64.tar.gz	http://download.oracle.com/otn-pub/java/jdk/8u101-b13/jdk-8u101-linux-x64.tar.gz
#	1. 判断是否安装了 jdk 
#		通过 /usr/local/lib/java 文件夹是否存在来判断; 如果存在, echo, exit
#	2. 判断 $home/develop/installation 下是否有对应的包下载好了, 如果没有, 就 wget 到该目录下
#	3. 解压缩到 /usr/local/lib/java 下
#	4. 配置环境变量
# @Author:
#	codergege
# @Last Update:
#	2016-10-11
# @usage:
#	bash install_java.sh java7 32
#	bash install_java.sh java8 64

# 只在当前脚本生效, 脚本执行完毕后, 父 shell 中还是原来的 PATH
PATH=$PATH:~/bin
export PATH
# path
home=/home/codergege
profile=/etc/profile

java_version=$1

# 判断 java_version

