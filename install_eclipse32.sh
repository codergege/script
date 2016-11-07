#!/bin/bash
# @file: 
#	install_eclipse.sh
# @desc:
#	如果要安装的 eclipse 版本改变, 脚本中的一些设置也需要改变
#   该 script 安装的是 eclipse for java 4.6.1 版本.
#   wget -> tar -xvf 到 /usr/local/eclipse -> cd /usr/bin; ln -s xxx
# @Author:
#	codergege
# @Last Update:
#	2016-11-07
# @usage:
#	sh install_eclipse32.sh 

# home
home=/home/codergege
# 安装包目录
pkgDir=$home/develop/installation
# 安装目录
installDir=/usr/local
# config
config=/etc/profile
# 保存当前目录
pwdDir=$pwd
# eclipse 
url=http://mirrors.neusoft.edu.cn/eclipse/technology/epp/downloads/release/neon/1a/eclipse-jee-neon-1a-linux-gtk.tar.gz
pkg=eclipse-jee-neon-1a-linux-gtk.tar.gz
eclipse=$installDir/eclipse

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

# 判断 elcipse 目录是否存在, 若已经存在, 先删除
if [ -d "$eclipse" ]; then
	sudo rm -rf $eclipse
fi

# 解压到安装目录
sudo tar -xvf $pkg -C $installDir

# 创建 link 
cd /usr/bin
sudo rm -f /usr/bin/eclipse
sudo ln -s $eclipse/eclipse eclipse

cd ~
rm -rf .vrapperrc
ln -s .vim/.vrapperrc .vrapperrc

cd $pwdDir
echo "========> $eclipse installed"

