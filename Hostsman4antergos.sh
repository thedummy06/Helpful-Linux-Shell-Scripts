#!/bin/bash
#This updates the hosts file

echo "creating hosts file to block adverts"
find /etc/hosts.bak 
while [ $? -gt 0 ]
do  
	sudo cp /etc/hosts /etc/hosts.bak
	break
done

cp /etc/hosts.bak /etc/hosts

echo "Please enter your username."
read username
house=/home/$username
cd $house

package=("1" "2" "3" "4")

echo "Select your package 1 2 3 4"
read package

if [[ $package -eq "1" ]];
then 
	wget https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts
	cat Jameshostslist >> hosts
	sort -u hosts > /tmp/hosts.new && mv /tmp/hosts.new hosts && uniq -u hosts > /tmp/hosts.new && mv /tmp/hosts.new hosts
elif [[ $package -eq "2" ]];
then 
	wget https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts
	wget https://hosts-file.net/ad_servers.txt
	cat ad_servers.txt >> hosts
	cat Jameshostslist >> hosts
	sed -i 's/127.0.0.1/0.0.0.0/g' hosts
	sort -u hosts > /tmp/hosts.new && mv /tmp/hosts.new hosts && uniq -u hosts > /tmp/hosts.new && mv /tmp/hosts.new hosts
	#sed -i '6,23d' hosts
	rm ad_servers.txt
elif [[ $package -eq "3" ]];
then 
	wget http://www.montanamenagerie.org/hostsfile/hosts.txt
	wget https://hosts-file.net/hphosts-partial.txt
	wget http://sysctl.org/cameleon/hosts -O cameleonhosts
	cat hphosts-partial.txt >> hosts.txt
	cat cameleonhosts >> hosts.txt
	cat Jameshostslist >> hosts.txt
	mv hosts.txt hosts
	sed -i 's/127.0.0.1/0.0.0.0/g' hosts
	sort -u hosts > /tmp/hosts.new && mv /tmp/hosts.new hosts && uniq -u hosts > /tmp/hosts.new && mv /tmp/hosts.new hosts
	rm hphosts-partial.txt cameleonhosts 
elif [[ $package -eq "4" ]];
then 
	wget https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling/hosts
	wget http://www.montanamenagerie.org/hostsfile/hosts.txt
	wget https://hosts-file.net/hphosts-partial.txt
	wget http://sysctl.org/cameleon/hosts -O cameleonhosts
	cat hosts.txt >> hosts
	cat hphosts-partial.txt >> hosts
	cat cameleonhosts >> hosts
	cat Jameshostslist >> hosts
	sed -i 's/127.0.0.1/0.0.0.0/g' hosts
	sort -u hosts > /tmp/hosts.new && mv /tmp/hosts.new hosts && uniq -u hosts > /tmp/hosts.new && mv /tmp/hosts.new hosts
	#sed -i '6,23d' hosts
	rm cameleonhosts hosts.txt hphosts-partial.txt
else 
	echo "Run again and pick a valid number."
	exit
fi

cat hosts >> /etc/hosts
rm hosts
systemctl restart NetworkManager
cat /etc/hosts >> hosts.log
