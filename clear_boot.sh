#!/bin/bash
# @file: 
#	clear_boot.sh
# @desc:
#	清理 boot 空间
# @Author:
#	codergege
# @Last Update:
#	2016-11-23 
# @usage:
#	sh clear_boot.sh

# path
home=/home/codergege
pwdDir=$pwd

# 查看
dpkg --get-selections|grep linux
# 删除
sudo apt-get remove linux-image-*
sudo apt-get autoremove
