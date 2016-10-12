#!/bin/bash

# path
home=/home/codergege
links=$(ls -al /etc/alternatives/ | grep java | awk '{print $9}')
cd /etc/alternatives
for link in $links
do
sudo rm -rf $link
done
