#!/bin/bash
# @file: 
#	install_groovy_2.4.7.sh
# @desc:
#	https://dl.bintray.com/groovy/maven/apache-groovy-binary-2.4.7.zip
#	http://www.apache.org/dyn/closer.cgi/groovy/2.4.7/sources/apache-groovy-src-2.4.7.zip
#	https://dl.bintray.com/groovy/maven/apache-groovy-docs-2.4.7.zip
#	wget 这些到　~/develop/installation/groovy2.4.7/
#	cd ~/develop/installation/groovy2.4.7
#	unzip
#	cp -a xxx /usr/local/groovy/
#	edit /etc/profile
# @Author:
#	codergege
# @Last Update:
#	2016-10-20 
# @usage:
#	为了使 souce $config 生效, 要用 source 命令执行
#	source install_groovy_2.4.7.sh

# home
home=/home/codergege
# 安装包目录
pkgDir=$home/develop/installation/groovy
# 安装目录
installDir=/usr/local/groovy
# api 目录
apiDir=$home/develop/api-documentation
# config
config=/etc/profile
# 保存当前目录
pwdDir=$pwd

# wget 
pkgUrl=https://dl.bintray.com/groovy/maven/apache-groovy-binary-2.4.7.zip
srcUrl=http://www.apache.org/dyn/closer.cgi/groovy/2.4.7/sources/apache-groovy-src-2.4.7.zip
docUrl=https://dl.bintray.com/groovy/maven/apache-groovy-docs-2.4.7.zip

pkg=apache-groovy-binary-2.4.7.zip
srcpkg=apache-groovy-src-2.4.7.zip
docpkg=apache-groovy-docs-2.4.7.zip

if [ ! -d "$pkgDir" ]; then 
	mkdir $pkgDir
fi
cd $pkgDir
if [ ! -f "$pkg" ];then 
	echo "$pkg 不存在, 开始下载 "
	wget $pkgUrl
fi
if [ ! -f "$srcpkg" ];then 
	echo "$srcpkg 不存在, 开始下载 "
	wget $srcUrl
fi
if [ ! -f "$docpkg" ];then 
	echo "$docpkg 不存在, 开始下载 "
	wget $docUrl
fi

# 判断安装目录是否存在, 不存在就创建
if [ ! -d "$installDir" ]; then
	sudo mkdir -p $installDir
fi

# 如果 apiDir 不存在, 就创建
if [ ! -d "$apiDir" ]; then
    mkdir -p $apiDir
fi

# 解压到安装目录
groovyname=groovy-2.4.7
groovy=$installDir/$groovyname
if [ -d "$groovy" ]; then
	sudo rm -rf $groovy
fi
unzip  $pkg
#unzip  $srcpkg
#unzip  $docpkg
cd $installDir
sudo mv $pkgDir/$groovyname .

# 将 docpkg 复制到 $apiDir
cd $apiDir
cp -a $pkgDir/$docpkg .
unzip $docpkg
rm $docpkg


# 将 java 环境变量写入 $config 的函数
function set_groovy_env() {
	sudo sed -i '$a # Set groovy environment GROOVY_HOME' $config
	echo "export GROOVY_HOME=$groovy" | sudo tee -a $config
	sudo sed -i '$a export PATH=$PATH:$GROOVY_HOME/bin' $config
}

# set groovy environment
if ! grep "GROOVY_HOME" $config; then
	echo "设置 groovy environment"
	set_groovy_env
else
	echo "$config 中已存在 GROOVY_HOME, 将删除原设置, 并重新设置"
	# 如果已经有了设置, 先删除再写入
	sudo sed -i '/GROOVY_HOME/d' $config
	set_groovy_env
fi

cd $pwdDir
source $config
echo "========> $groovy installed"
