#!/bin/bash
# @file: 
#	install_tomcat.sh
# @desc:
#	如果要安装的 tomcat 版本改变, 脚本中的一些设置也需要改变
#	1. 判断是否安装了 tomcat 
#		通过 /usr/local/tomcat 文件夹是否存在来判断; 如果存在, echo, exit
#		通过判断 $config 中是否存在 TOMCAT_HOME ; 如果存在, echo, exit
#	2. 判断 $home/develop/installation 下是否有对应的包下载好了, 如果没有, 就 wget 到该目录下
#	3. 解压缩到 /usr/local/tomcat 下
#	4. 配置环境变量
#		重要的一步是往 setclasspath.sh 中写入 JAVA_HOME, 否则 tomcat 找不到
#	5. 在 /usr/local/bin 中建立 link
#		startup -> $TOMCAT_HOME/bin/startup.sh
#		shutdown -> $TOMCAT_HOME/bin/shutdown.sh
# @Author:
#	codergege
# @Last Update:
#	2016-10-12
# @usage:
#	为了使 souce $config 生效, 要用 source 命令执行
#	source install_tomcat.sh tomcat7
#	source install_tomcat.sh tomcat8

# home
home=/home/codergege
# 安装包目录
pkgDir=$home/develop/installation
# 安装目录
installDir=/usr/local/tomcat
# config
config=/etc/profile
# 保存当前目录
pwdDir=$pwd
# tomcat 
url7=http://mirrors.cnnic.cn/apache/tomcat/tomcat-7/v7.0.72/bin/apache-tomcat-7.0.72.tar.gz
pkg7=$pkgDir/apache-tomcat-7.0.72.tar.gz
tomcat7=apache-tomcat-7.0.72
url8=http://mirrors.cnnic.cn/apache/tomcat/tomcat-8/v8.5.6/bin/apache-tomcat-8.5.6.tar.gz
pkg8=$pkgDir/apache-tomcat-8.5.6.tar.gz
tomcat8=apache-tomcat-8.5.6

# 检查输入参数 以后再加 tomcat9
if [ $1 == "tomcat7" ] || [ $1 == "tomcat8" ]; then
	echo "安装 $1"
else
	echo "必须加入第一个参数 tomcat7 或 tomcat8"
	exit 1
fi

# 确定安装包名, 下载网址
if [ $1 == "tomcat7" ] ; then
	pkg=$pkg7
	url=$url7
	tomcat=$installDir/$tomcat7
fi
if [ $1 == "tomcat8" ]; then
	pkg=$pkg8
	url=$url8
	tomcat=$installDir/$tomcat8
fi

# 判断安装包是否存在
cd $pkgDir
if [ -f "$pkg" ]; then
	echo "找到本地安装包, 准备安装..."
else
	echo "未找到本地安装包, 准备下载..."
	wget -P $pkgDir $url
fi

# 判断安装目录是否存在
if [ ! -d "$installDir" ]; then
	sudo mkdir -p $installDir
fi

# 解压到安装目录
if [ -d "$tomcat" ]; then
sudo rm -rf $tomcat
fi
sudo tar -xvf $pkg -C $installDir

# 创建 link 
cd /usr/bin
sudo rm -f /usr/bin/startup
sudo rm -f /usr/bin/tshutdown
sudo ln -s $tomcat/bin/startup.sh startup
sudo ln -s $tomcat/bin/shutdown.sh tshutdown

# 将 tomcat 环境变量写入 $config 的函数
function set_tomcat_env() {
	sudo sed -i '$a # Set tomcat environment TOMCAT_HOME' $config
	echo "export TOMCAT_HOME=$tomcat" | sudo tee -a $config
	echo "export CATALINA_HOME=$tomcat" | sudo tee -a $config
	echo "export CATALINA_BASE=$tomcat" | sudo tee -a $config
	sudo sed -i '$a export PATH=$PATH:$TOMCAT_HOME/bin' $config
	# 如果 setclasspath 中没有写入, 那就写入
	setclasspath=$tomcat/bin/setclasspath.sh
#	echo "======>$setclasspath"
	if ! sudo grep "javahome" $setclasspath; then
		javahome=$(cat $config | grep 'JAVA_HOME=' | awk 'BEGIN {FS="="} {print $2}')
		rm -f /tmp/script
		touch /tmp/script
		echo "export JAVA_HOME=$javahome #javahome" >> /tmp/script
		sudo sed -i '1r /tmp/script' $setclasspath
		rm -f /tmp/script
	fi
}

# 删除 $config 文件中的 tomcat 设置 
function remove_tomcat_env() {
	sudo sed -i '/TOMCAT_HOME/d' $config
	sudo sed -i '/CATALINA/d' $config
}

# set tomcat environment
if ! grep "TOMCAT_HOME" $config; then
	echo "设置 tomcat environment"
	set_tomcat_env
else
	echo "$config 中已存在 TOMCAT_HOME, 将删除原设置, 并重新设置"
	# 如果已经有了设置, 先删除再写入
	remove_tomcat_env
	set_tomcat_env
fi

cd $pwdDir
source $config
echo "========> $tomcat installed"

