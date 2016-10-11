#!/bin/bash
# Program: template.sh
#	This is a templation
# Author: codergege
# Last Update: 2016-10-11

# 只在当前脚本生效, 脚本执行完毕后, 父 shell 中还是原来的 PATH
PATH=$PATH:~/bin
export PATH
# path
home=/home/codergege
links=$(ls -al /etc/alternatives/ | grep java | awk '{print $9}')
cd /etc/alternatives
for link in $links
do
sudo rm -rf $link
done
