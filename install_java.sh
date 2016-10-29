#!/bin/bash
# @file: 
#	install_java.sh
# @desc:
#	如果要安装的 java 版本改变, 脚本中的一些设置也需要改变(java7已经稳定, 一般不会变了): pkg, jdk, url
#	Install java.
#	7u80的版本链接 otn 改成 otn-pub
# @Author:
#	codergege
# @Last Update:
#	2016-10-29
# @usage:
#	为了使 souce $config 生效, 要用 source 命令执行
#	source install_java.sh java7 32
#	source install_java.sh java8 64

# home
home=/home/codergege
# 安装包目录
pkgDir=$home/develop/installation
# 安装目录
installDir=/usr/local/java
# config
config=/etc/profile
# 保存当前目录
pwdDir=$pwd

# 检查输入参数
if [ $1 == "java7" ] || [ $1 == "java8" ]; then
	echo "安装 $1"
else
	echo "必须加入第一个参数 java7 或 java8"
	exit 1
fi
if [ $2 == "32" ] || [ $2 == "64" ]; then
	echo "安装 $2 位版本"
else
	echo "必须加入第二个参数 32 或 64"
	exit 1
fi

# 确定安装包名, 下载网址
if [ $1 == "java7" ] && [ $2 == "32" ]; then
	pkg=$pkgDir/jdk-7u80-linux-i586.tar.gz
	jdk=jdk1.7.0_80
	url=http://download.oracle.com/otn-pub/java/jdk/7u80-b15/jdk-7u80-linux-i586.tar.gz
fi
if [ $1 == "java7" ] && [ $2 == "64" ]; then
	pkg=$pkgDir/jdk-7u80-linux-x64.tar.gz
	jdk=jdk1.7.0_80
	url=http://download.oracle.com/otn-pub/java/jdk/7u80-b15/jdk-7u80-linux-x64.tar.gz
fi
if [ $1 == "java8" ] && [ $2 == "32" ]; then
	pkg=$pkgDir/jdk-8u101-linux-i586.tar.gz
	jdk=jdk1.8.0_101
	url=http://download.oracle.com/otn-pub/java/jdk/8u101-b13/jdk-8u101-linux-i586.tar.gz
fi
if [ $1 == "java8" ] && [ $2 == "64" ]; then
	pkg=$pkgDir/jdk-8u101-linux-x64.tar.gz	
	jdk=jdk1.8.0_101
	url=http://download.oracle.com/otn-pub/java/jdk/8u101-b13/jdk-8u101-linux-x64.tar.gz
fi

# 判断安装包是否存在
cd $pkgDir
if [ -f "$pkg" ]; then
	echo "找到本地安装包, 准备安装..."
else
	echo "未找到本地安装包, 准备下载..."
	wget --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" -P $pkgDir $url
fi
if [ ! -d "$installDir" ]; then
	sudo mkdir -p $installDir
fi

# 解压到安装目录
jdk=$installDir/$jdk
if [ -d "$jdk" ]; then
sudo rm -rf $jdk
fi
sudo tar -xvf $pkg -C $installDir

# 创建 link 这步不需要
# cd $installDir

# 将 java 环境变量写入 $config 的函数
function set_java_env() {
	sudo sed -i '$a # Set java environment JAVA_HOME' $config
	echo "export JAVA_HOME=$jdk" | sudo tee -a $config
	sudo sed -i '$a export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar' $config
	sudo sed -i '$a export PATH=$PATH:$JAVA_HOME/bin' $config
}

# set java environment
if ! grep "JAVA_HOME" $config; then
	echo "设置 java environment"
	set_java_env
else
	echo "$config 中已存在 JAVA_HOME, 将删除原设置, 并重新设置"
	# 如果已经有了设置, 先删除再写入
	sudo sed -i '/JAVA_HOME/d' $config
	set_java_env
fi

cd $pwdDir
source $config
echo "========> $jdk installed"

