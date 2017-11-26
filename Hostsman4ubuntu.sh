#!/bin/bash
#This updates the hosts file

echo "WARNING! USE OF THESE LISTS COULD CAUSE MANY OF YOUR FAVORITE SITES TO CEASE FUNCTIONING. PROCEED WITH CAUTION."

echo "searching for /etc/hosts.bak and then creating hosts file to block tracking"
find /etc/hosts.bak 
while [ $? -gt 0 ]
do  
	sudo cp /etc/hosts /etc/hosts.bak
	break
done

sudo cp /etc/hosts.bak /etc/hosts

echo "Please enter your username."
read username
house=/home/$username
cd $house

package=(1 2 3 4 5 6 7)

echo "Select your package 1 2 3 4 5 6 7"
read package

if [[ $package -eq 1 ]];
then 
	wget https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts
	cat Jameshostslist >> hosts
	sort -u hosts > /tmp/hosts.new && mv /tmp/hosts.new hosts && uniq -u hosts > /tmp/hosts.new && mv /tmp/hosts.new hosts
	#sed -i '6,22d' hosts
elif [[ $package -eq 2 ]];
then 
	wget https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts
	wget https://hosts-file.net/ad_servers.txt
	cat ad_servers.txt >> hosts
	cat Jameshostslist >> hosts
	sed -i 's/127.0.0.1/0.0.0.0/g' hosts
	sort -u hosts > /tmp/hosts.new && mv /tmp/hosts.new hosts && uniq -u hosts > /tmp/hosts.new && mv /tmp/hosts.new hosts
	#sed -i '6,23d' hosts
	rm ad_servers.txt
elif [[ $package -eq 3 ]];
then 
	wget http://www.montanamenagerie.org/hostsfile/hosts.txt
	wget https://hosts-file.net/hphosts-partial.txt
	#wget https://raw.githubusercontent.com/Clefspeare13/pornhosts/master/0.0.0.0/hosts -O pron
	wget http://sysctl.org/cameleon/hosts -O cameleonhosts
	cat hphosts-partial.txt >> hosts.txt
	cat cameleonhosts >> hosts.txt
	#cat pron >> hosts
	cat Jameshostslist >> hosts.txt
	mv hosts.txt hosts
	sed -i 's/127.0.0.1/0.0.0.0/g' hosts
	sort -u hosts > /tmp/hosts.new && mv /tmp/hosts.new hosts && uniq -u hosts > /tmp/hosts.new && mv /tmp/hosts.new hosts
	grep -v "1337x.to" hosts > /tmp/hosts.new && mv /tmp/hosts.new hosts
	rm hphosts-partial.txt cameleonhosts 
elif [[ $package -eq 4 ]];
then 
	wget https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts
	wget http://www.montanamenagerie.org/hostsfile/hosts.txt
	wget https://hosts-file.net/hphosts-partial.txt
	wget http://sysctl.org/cameleon/hosts -O cameleonhosts
	cat hosts.txt >> hosts
	cat hphosts-partial.txt >> hosts
	cat cameleonhosts >> hosts
	cat Jameshostslist >> hosts
	sed -i 's/127.0.0.1/0.0.0.0/g' hosts
	sort -u hosts > /tmp/hosts.new && mv /tmp/hosts.new hosts && uniq -u hosts > /tmp/hosts.new && mv /tmp/hosts.new hosts
	grep -v "1337x.to" hosts > /tmp/hosts.new && mv /tmp/hosts.new hosts
	#sed -i '6,23d' hosts
	rm cameleonhosts hosts.txt hphosts-partial.txt
elif [[ $package -eq 5 ]];
then
	echo "In many ways, this is the same as package 1, however, it stays slightly more up to date as some lists update daily."

	wget https://raw.githubusercontent.com/FadeMind/hosts.extras/master/SpotifyAds/hosts -O spotifyads	
	wget https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts -O adservers.txt
	wget http://winhelp2002.mvps.org/hosts.txt -O MVPShosts
	wget someonewhocares.org/hosts/hosts
	wget https://raw.githubusercontent.com/Clefspeare13/pornhosts/master/0.0.0.0/hosts
	wget http://www.malwaredomainlist.com/hostslist/hosts.txt -O Malwarehosts
	wget https://raw.githubusercontent.com/tyzbit/hosts/master/data/tyzbit/hosts -O tyzbit
	wget https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.2o7Net/hosts -O add.2o7Net
	wget https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.Dead/hosts -O add.Dead
	wget https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.Risk/hosts -O add.Risk
	wget https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.Spam/hosts -O add.Spam
	wget https://raw.githubusercontent.com/azet12/KADhosts/master/KADhosts.txt
	wget https://raw.githubusercontent.com/mitchellkrogza/Badd-Boyz-Hosts/master/hosts -O Badd-Boyz
	wget https://raw.githubusercontent.com/FadeMind/hosts.extras/master/UncheckyAds/hosts -O unchecky	
	cat MVPShosts >> hosts
	cat Malwarehosts >> hosts
	cat add.Spam >> hosts
	cat add.Dead >> hosts
	cat add.Risk >> hosts
	cat add.2o7Net >> hosts
	cat KADhosts.txt >> hosts
	cat Badd-Boyz >> hosts
	cat tyzbit >> hosts
	cat adservers.txt >> hosts
	cat spotifyads >> hosts
	cat unchecky >> hosts
	sed -i 's/127.0.0.1/0.0.0.0/g' hosts
	sort -u hosts > /tmp/hosts.new && mv /tmp/hosts.new hosts && uniq -u hosts > /tmp/hosts.new && mv /tmp/hosts.new hosts
	rm KADhosts.txt MVPShosts Malwarehosts add.Spam add.Dead add.Risk add.2o7Net Badd-Boyz tyzbit adservers.txt spotifyads unchecky
elif [[ $package -eq 6 ]];
then

	echo "This could block sites that you need, you've been warned."

	wget hosts-file.net/ad_servers.txt
	#wget https://raw.githubusercontent.com/Clefspeare13/pornhosts/master/0.0.0.0/hosts -O pron
	wget https://raw.githubusercontent.com/joeylane/hosts/master/hosts # Does block google
	cat ad_servers.txt >> hosts
	#cat pron >> hosts
	cat Jameshostslist >> hosts
	sed -i 's/127.0.0.1/0.0.0.0/g' hosts
	sort -u hosts > /tmp/hosts.new && mv /tmp/hosts.new hosts && uniq -u hosts >/tmp/hosts.new && mv /tmp/hosts.new hosts
	sed -i '76724,149206d' hosts
	rm ad_servers.txt
	#rm pron
	#grep -v "Google.com" hosts > /tmp/hosts.new && mv /tmp/hosts.new hosts #This unblocks google.com outright
elif [[ $package -eq 7 ]];
then
#Really large hosts file

	wget https://github.com/mitchellkrogza/Ultimate.Hosts.Blacklist/blob/master/hosts.zip?raw=true
	unzip 'hosts.zip?raw=true'
	cat Jameshostslist >> hosts
	sort -u hosts > /tmp/hosts.new && mv /tmp/hosts.new hosts && uniq -u hosts > /tmp/hosts.new && mv /tmp/hosts.new hosts
else 
	echo "Run again and pick a valid number."
	exit
fi

echo "Are there any other sites you wish to exclude?(Y/n)"
read answer
while [ $answer == Y ]
do
	read -p "Enter any other sites you wish to exclude:" Sites
	grep -v "$Sites" hosts > /tmp/hosts.new && mv /tmp/hosts.new hosts
done

sudo cat hosts >> /etc/hosts
rm hosts
sudo /etc/init.d/network-manager restart
cat /etc/hosts >> hosts.log
