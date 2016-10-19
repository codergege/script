#!/bin/bash
# @file: 
#	tmp_java_builder.sh
# @desc:
#	临时的 java 构建脚本
# @Author:
#	codergege
# @Last Update:
#	2016-10-19 
# @usage:
#	chmod 755 tmp_java_builder.sh
#	cp -a 项目根目录下 或　ln ...
#	./tmp_java_builder.sh

# path
home=/home/codergege
pwdDir=$pwd
# workspace dir
workspaceDir=$home/workspace/java/demos
#/home/codergege/workspace/java/demos/
projectName=java8newfeatures
projectDir=$workspaceDir/$projectName
classesDir=$projectDir/target/classes

if [ ! -d $classesDir ]; then
	mkdir -p $classesDir
fi

#javac /home/codergege/workspace/java/demos/java8newfeatures/src/main/java/cn/codergege/demo/NewFeaturesTester.java -d $classesDir 
javac $projectDir/src/main/java/cn/codergege/demo/NewFeaturesTester.java -d $classesDir 
cd $classesDir
java cn.codergege.demo.NewFeaturesTester
cd $pwdDir
