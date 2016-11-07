#!/bin/bash
# @file: 
#	install_eclim_2.6.0.sh
# @desc:
#
# @Author:
#	codergege
# @Last Update:
#	2016-11-07
# @usage:
#	sh install_eclim_2.6.0.sh 

# home
home=/home/codergege
# 安装包目录
pkgDir=$home/develop/installation
# 安装目录
#installDir=/usr/local/eclim
# config
config=/etc/profile
# 保存当前目录
pwdDir=$pwd
#url=https://github.com/ervandew/eclim/releases/download/2.6.0/eclim_2.6.0.tar.gz
url=https://github.com/ervandew/eclim/releases/download/2.6.0/eclim_2.6.0.jar
#pkg=eclim_2.6.0.tar.gz
eclimjar=eclim_2.6.0.jar

# 确定安装包名, 下载网址
#eclim=$installDir/eclim_2.6.0

# 判断安装包是否存在
cd $pkgDir
if [ -f "$eclimjar" ]; then
	echo "找到本地安装包, 准备安装..."
else
	echo "未找到本地安装包, 准备下载..."
	wget -P $pkgDir $url
fi

# 判断 elcim 目录是否存在, 若已经存在, 先删除
#if [ -d "$eclim" ]; then
	#sudo rm -rf $eclim
#fi

# 安装
java -jar $eclimjar

#sudo rm -f /usr/bin/eclipse
#sudo ln -s $eclipse/eclipse eclipse

cd $pwdDir
echo "========> $eclim installed"

