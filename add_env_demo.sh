#!/bin/bash
# Program: add_env_demo.sh
#	Add environment variables.
#	新打开的 shell 窗口中就会生效了
# Author: codergege
# Last Update: 2016-10-11

# 只在当前脚本生效, 脚本执行完毕后, 父 shell 中还是原来的 PATH
PATH=$PATH:~/bin
export PATH
# path
home=/home/codergege

# 写入 .bashrc, 永久生效
# 找到 .bashrc 中 export PATH 开头的行, 将其删除
sed -i '/^.*export\ PATH/d' $home/.bashrc
# 在 #THIS MUST 行前插入
sed -i '/^.*#THIS\ MUST/i export PATH=$PATH:/home/codergege/bin' $home/.bashrc
source $home/.bashrc


