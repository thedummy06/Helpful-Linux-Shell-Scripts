#!/bin/bash
#This updates the hosts file
mv /etc/hosts.bak /etc/hosts #Really only matters the second time and thereafter.
cp /etc/hosts /etc/hosts.bak
#cd /home/$USER #If you run as cron job, uncomment this line.
wget https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts
cat list >> hosts
cat hosts >> /etc/hosts 
systemctl restart NetworkManager.service
rm hosts 
cat /etc/hosts >> hosts.log


