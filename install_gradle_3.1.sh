#!/bin/bash
# @file: 
#	install_gradle_3.1.sh
# @desc:
#	Install gradle 3.1.
#	下载 gradle 3.1
#	判断 /develop/installation/gradle-3.1-all 是否存在, 不存在就 wget
# @Author:
#	codergege
# @Last Update:
#	2016-10-29
# @usage:
#	为了使 souce $config 生效, 要用 source 命令执行
#	source install_gradle_3.1.sh

# home
home=/home/codergege
# 安装包目录
pkgDir=$home/develop/installation
# 安装目录
installDir=/usr/local/gradle
# config
config=/etc/profile
# 保存当前目录
pwdDir=$pwd
# 安装包
pkg=$pkgDir/gradle-3.1-all.zip
url=https://services.gradle.org/distributions/gradle-3.1-all.zip
# gradle version
gv=gradle-3.1

# 判断安装包是否存在
cd $pkgDir
if [ -f "$pkg" ]; then
	echo "找到本地安装包, 准备安装..."
else
	echo "未找到本地安装包, 准备下载..."
	wget -P $pkgDir $url 
fi
if [ ! -d "$installDir" ]; then
	sudo mkdir -p $installDir
fi

# 解压并 mv 到安装目录
gradle=$installDir/$gv
if [ -d "$gradle" ]; then
	sudo rm -rf $gradle
fi
# 解压
dtrx -nov --one h $gv-all.zip
sudo mv $pkgDir/$gv-all/$gv $installDir/
 
# 创建 doc link 
cd /home/codergege/api-documentation
sudo rm -f $gv
sudo ln -s $gradle/docs $gv

# 将 gradle 环境变量写入 $config 的函数
function set_gradle_env() {
	sudo sed -i '$a # Set gradle environment GRADLE_HOME' $config
	echo "export GRADLE_HOME=$gradle" | sudo tee -a $config
	sudo sed -i '$a export PATH=$PATH:$GRADLE_HOME/bin' $config
}

# set gradle environment
if ! grep "GRADLE_HOME" $config; then
	echo "设置 gradle environment"
	set_gradle_env
else
	echo "$config 中已存在 GRADLE_HOME, 将删除原设置, 并重新设置"
	# 如果已经有了设置, 先删除再写入
	sudo sed -i '/GRADLE_HOME/d' $config
	set_gradle_env
fi

cd $pwdDir
source $config
echo "========> $gradle installed"

