#!/bin/bash
# @file: 
#	wget_page.sh
# @desc:
#	从网站上下载页面, 方便脱机浏览;
#	一般用于下载 document, 在线书籍
# @Author:
#	codergege
# @Last Update:
#	2016-10-14
# @usage:
#	bash wget_page.sh url dir

# path
home=/home/codergege
pwdDir=$pwd

wget -c -r -np -k -L -p --level=0 $1 -P $2

#wget -c -r -np -k -L -p www.xxx.org/pub/path/
#在下载时。有用到外部域名的图片或连接。如果需要同时下载就要用-H参数。
#
#wget -np -nH -r --span-hosts www.xxx.org/pub/path/
#
#-c 断点续传
#-r 递归下载，下载指定网页某一目录下（包括子目录）的所有文件
#-nd 递归下载时不创建一层一层的目录，把所有的文件下载到当前目录
#-np 递归下载时不搜索上层目录，如wget -c -r www.xxx.org/pub/path/
#没有加参数-np，就会同时下载path的上一级目录pub下的其它文件
#-k 将绝对链接转为相对链接，下载整个站点后脱机浏览网页，最好加上这个参数
#-L 递归时不进入其它主机，如wget -c -r www.xxx.org/ 
#如果网站内有一个这样的链接： 
#www.yyy.org，不加参数-L，就会像大火烧山一样，会递归下载www.yyy.org网站
#-p 下载网页所需的所有文件，如图片等
#-P 指定保存目录
#
