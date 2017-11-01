#!/bin/bash
#This updates the hosts file
mv /etc/hosts.bak /etc/hosts
cp /etc/hosts /etc/hosts.bak
cd $HOME #If you run as cron job.
wget https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling/hosts
wget http://www.montanamenagerie.org/hostsfile/hosts.txt
wget https://hosts-file.net/hphosts-partial.txt
wget http://sysctl.org/cameleon/hosts -O cameleonhosts
sed -i 's/127.0.0.1/0.0.0.0/g' hosts.txt
sed -i 's/127.0.0.1/0.0.0.0/g' hphosts-partial.txt
sed -i 's/127.0.0.1/0.0.0.0/g' cameleonhosts
cat hosts.txt >> hosts
cat hphosts-partial.txt >> hosts
cat cameleonhosts >> hosts
cat Jameshostslist >> hosts
sort -u hosts > /tmp/hosts.new && mv /tmp/hosts.new hosts
uniq -u hosts > /tmp/hosts.new && mv /tmp/hosts.new hosts 
sed -i '1,19d' hosts
grep -v "1337x.to" hosts > /tmp/hosts.new && mv /tmp/hosts.new hosts
cat hosts >> /etc/hosts 
sudo /etc/init.d/network-manager restart
rm hosts hphosts-partial.txt hosts.txt cameleonhosts
cat /etc/hosts >> hosts.log
