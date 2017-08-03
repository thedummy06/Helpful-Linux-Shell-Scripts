#!/bin/bash
#This updates the hosts file
mv /etc/hosts.bak /etc/hosts
cp /etc/hosts /etc/hosts.bak
#cd /home/$USER #If you run as cron job.
wget https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts
#cat list >> hosts
cat hosts >> /etc/hosts 
/etc/init.d/network-manager restart
rm hosts 
cat /etc/hosts >> hosts.log


