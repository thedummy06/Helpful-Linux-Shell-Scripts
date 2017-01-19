#!/bin/bash
#This updates the hosts file
mv /etc/hosts.bak /etc/hosts #This only matters after the first run, it'll move past this the first time.
cp /etc/hosts /etc/hosts.bak
#cd /home/$USER #If you run as cron job, uncomment this line.
wget https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts
cat hosts >> /etc/hosts 
service network-manager restart
rm hosts 
cat /etc/hosts >> hosts.log


