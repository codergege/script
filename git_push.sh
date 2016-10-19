#!/bin/bash
# @file: 
#	git_push.sh
# @desc:
#	git add .
#	git commmt -m 'datetime'
#	git push origin master
# @Author:
#	codergege
# @Last Update:
#	2016-10-19
# @usage:
#	copy to git repository
#	chmod 755 git_push.sh
#	./git_push.sh
#	

# path
home=/home/codergege
pwdDir=$pwd

# git add
git add .

# git commit -m 'datetime'
datetime=$(date +%Y%m%d%H%M%S)
git commit -m $datetime

# git push 
git push origin master

