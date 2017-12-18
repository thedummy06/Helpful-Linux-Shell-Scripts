#!/bin/bash
#This updates the hosts file

echo "WARNING! USE OF THESE HOSTS COULD CAUSE MANY OF YOUR FAVORITE SITES TO CEASE FUNCTIONING. PROCEED WITH CAUTION."

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

package=(1 2 3 4 5 6 7 8)

echo "Select your package 1 2 3 4 5 6 7 8"
read package

if [[ $package -eq 1 ]];
then 
	wget https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts
	cat Jameshostslist >> hosts
	uniq -u hosts > /tmp/hosts.new && mv /tmp/hosts.new hosts
	#sed -i '6,22d' hosts
elif [[ $package -eq 2 ]];
then 
	wget https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts
	wget https://hosts-file.net/ad_servers.txt
	cat ad_servers.txt >> hosts
	cat Jameshostslist >> hosts
	sed -i 's/0.0.0.0/127.0.0.1/g' hosts
	uniq -u hosts > /tmp/hosts.new && mv /tmp/hosts.new hosts
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
	sed -i 's/0.0.0.0/127.0.0.1/g' hosts
	uniq -u hosts > /tmp/hosts.new && mv /tmp/hosts.new hosts
	rm hphosts-partial.txt cameleonhosts 
elif [[ $package -eq 4 ]];
then 
	wget https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts
	wget http://www.montanamenagerie.org/hostsfile/hosts.txt
	wget https://hosts-file.net/hphosts-partial.txt
	wget https://raw.githubusercontent.com/zant95/hmirror/master/data/spam404.com/list.txt -O spamhosts && sed -i -e 's/^/127.0.0.1  /' spamhosts
	wget http://sysctl.org/cameleon/hosts -O cameleonhosts
	wget https://raw.githubusercontent.com/zant95/hmirror/master/data/malwaredomains.com-justdomains/list.txt -O Malwarehosts2 && sed -i 's/^/127.0.0.1  /' Malwarehosts2
	cat hosts.txt >> hosts
	cat hphosts-partial.txt >> hosts
	cat cameleonhosts >> hosts
	cat spamhosts >> hosts
	cat Malwarehosts2 >> hosts
	cat Jameshostslist >> hosts
	sed -i 's/0.0.0.0/127.0.0.1/g' hosts
	uniq -u hosts > /tmp/hosts.new && mv /tmp/hosts.new hosts
	#sed -i '6,23d' hosts
	rm cameleonhosts hosts.txt hphosts-partial.txt spamhosts Malwarehosts2
elif [[ $package -eq 5 ]];
then
	wget https://raw.githubusercontent.com/FadeMind/hosts.extras/master/SpotifyAds/hosts -O spotifyads	
	wget https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts -O adservers.txt
	wget http://winhelp2002.mvps.org/hosts.txt -O MVPShosts
	wget someonewhocares.org/hosts/hosts
	wget https://raw.githubusercontent.com/Sinfonietta/hostfiles/master/snuff-hosts -O Pron2
	wget https://raw.githubusercontent.com/marktron/fakenews/master/fakenews
	wget https://raw.githubusercontent.com/Sinfonietta/hostfiles/master/gambling-hosts -O Gamblinglist
	wget https://raw.githubusercontent.com/StevenBlack/hosts/master/data/StevenBlack/hosts -O Stevenhosts
	wget https://raw.githubusercontent.com/Clefspeare13/pornhosts/master/0.0.0.0/hosts -O Pron
	wget http://www.malwaredomainlist.com/hostslist/hosts.txt -O Malwarehosts
	wget https://raw.githubusercontent.com/tyzbit/hosts/master/data/tyzbit/hosts -O tyzbit
	wget https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.2o7Net/hosts -O add.2o7Net
	wget https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.Dead/hosts -O add.Dead
	wget https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.Risk/hosts -O add.Risk
	wget https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.Spam/hosts -O add.Spam
	wget https://raw.githubusercontent.com/azet12/KADhosts/master/KADhosts.txt
	wget https://raw.githubusercontent.com/mitchellkrogza/Badd-Boyz-Hosts/master/hosts -O Badd-Boyz
	wget https://raw.githubusercontent.com/FadeMind/hosts.extras/master/UncheckyAds/hosts -O unchecky
	wget https://raw.githubusercontent.com/zant95/hmirror/master/data/spam404.com/list.txt -O spamhosts && sed -i -e 's/^/127.0.0.1  /' spamhosts
	wget http://www.montanamenagerie.org/hostsfile/hosts.txt
	wget https://hosts-file.net/hphosts-partial.txt	
	wget http://sysctl.org/cameleon/hosts -O cameleonhosts
	wget https://raw.githubusercontent.com/zant95/hmirror/master/data/malwaredomains.com-justdomains/list.txt -O Malwarehosts2 && sed -i 's/^/127.0.0.1  /' Malwarehosts2
	cat MVPShosts >> hosts
	cat Malwarehosts >> hosts
	cat Pron >> hosts
	cat Pron2 >> hosts
	cat add.Spam >> hosts
	cat add.Dead >> hosts
	cat add.Risk >> hosts
	cat add.2o7Net >> hosts
	cat Gamblinglist >> hosts
	cat KADhosts.txt >> hosts
	cat Stevenhosts >> hosts
	cat Badd-Boyz >> hosts
	cat fakenews >> hosts
	cat tyzbit >> hosts
	cat adservers.txt >> hosts
	cat spotifyads >> hosts
	cat unchecky >> hosts
	cat spamhosts >> hosts
	cat hosts.txt >> hosts
	cat hphosts-partial.txt >> hosts
	cat cameleonhosts >> hosts
	cat Malwarehosts2 >> hosts
	cat Jameshostslist >> hosts
	sed -i 's/0.0.0.0/127.0.0.1/g' hosts
	uniq -u hosts > /tmp/hosts.new && mv /tmp/hosts.new hosts
	rm KADhosts.txt MVPShosts Malwarehosts Malwarehosts2 add.Spam add.Dead add.Risk add.2o7Net Badd-Boyz tyzbit adservers.txt hphosts-partial.txt hosts.txt cameleonhosts spotifyads unchecky spamhosts Stevenhosts Pron Pron2 Gamblinglist fakenews
elif [[ $package -eq 6 ]];
then
	echo "This could block sites that you need, you've been warned."

	wget hosts-file.net/ad_servers.txt
	#wget https://raw.githubusercontent.com/Clefspeare13/pornhosts/master/0.0.0.0/hosts -O pron
	wget https://raw.githubusercontent.com/joeylane/hosts/master/hosts # Does block google
	cat ad_servers.txt >> hosts
	#cat pron >> hosts
	cat Jameshostslist >> hosts
	sed -i 's/0.0.0.0/127.0.0.1/g' hosts
	uniq -u hosts >/tmp/hosts.new && mv /tmp/hosts.new hosts
	#sed -i '76724,149206d' hosts
	rm Canvas1 Canvas2 Audiotracking NSAlist Webrtc Commontracking 
	#grep -v "Google.com" hosts > /tmp/hosts.new && mv /tmp/hosts.new hosts #This unblocks google.com outright
elif [[ $package -eq 7 ]];
then
#Really large hosts file

	wget https://github.com/mitchellkrogza/Ultimate.Hosts.Blacklist/blob/master/hosts.zip?raw=true
	unzip 'hosts.zip?raw=true'
	cat Jameshostslist >> hosts
	uniq -u hosts > /tmp/hosts.new && mv /tmp/hosts.new hosts
elif [[ $package -eq 8 ]];
then
#Umatrix style formula with something extra
	wget hosts-file.net/ad_servers.txt
	wget someonewhocares.org/hosts/hosts
	wget http://sysctl.org/cameleon/hosts -O cameleonhosts
	wget http://winhelp2002.mvps.org/hosts.txt -O MVPShosts
	wget http://www.malwaredomainlist.com/hostslist/hosts.txt -O Malwarehosts
	wget https://raw.githubusercontent.com/zant95/hmirror/master/data/pgl.yoyo.org/list.txt -O Petersadslist && sed -i -e 's/^/127.0.0.1  /' Petersadslist
	wget https://raw.githubusercontent.com/zant95/hmirror/master/data/malwaredomains.com-justdomains/list.txt -O Malware2 && sed -i -e 's/^/127.0.0.1  /' Malware2
	wget https://raw.githubusercontent.com/zant95/hmirror/master/data/spam404.com/list.txt -O Spamhosts && sed -i -e 's/^/127.0.0.1  /' Spamhosts
	cat MVPShosts >> hosts 
	cat Malwarehosts >> hosts 
	cat Petersadslist >> hosts
	cat Malware2 >> hosts
	cat cameleonhosts >> hosts
	cat ad_servers.txt >> hosts
	cat Spamhosts >> hosts
	cat Jameshostslist >> hosts
	sed -i 's/0.0.0.0/127.0.0.1/g' hosts
	uniq -u hosts > /tmp/hosts.new && mv /tmp/hosts.new hosts
	rm ad_servers.txt Petersadslist Malwarehosts Malware2 Spamhosts MVPShosts cameleonhosts
else 
	echo "Run again and pick a valid number."
	exit
fi

echo "Are there any other sites that you wish to exclude?(Y/n)"
read answer
while [ $answer == Y ]
do
	read -p "Enter any other sites you wish to exclude up to 3:" Site1 Site2 Site3 Site4 Site5
	cd $house 
	grep -v "$Site1" hosts > /tmp/hosts.new && mv /tmp/hosts.new hosts
	grep -v "$Site2" hosts > /tmp/hosts.new && mv /tmp/hosts.new hosts
	grep -v "$Site3" hosts > /tmp/hosts.new && mv /tmp/hosts.new hosts
	grep -v "$Site4" hosts > /tmp/hosts.new && mv /tmp/hosts.new hosts
	grep -v "$Site5" hosts > /tmp/hosts.new && mv /tmp/hosts.new hosts
break
done

echo "This hosts file doesn't update as often" 
echo "Would you like to add some extra sites?"
read answer 
if [[ $answer == Y ]];
then 
	wget https://raw.githubusercontent.com/bjornstar/hosts/master/hosts -O bjornhosts
	cat bjornhosts >> hosts 
	uniq -u hosts > /tmp/hosts.new && mv /tmp/hosts.new hosts 
	rm bjornhosts
fi

sudo cat hosts >> /etc/hosts
rm hosts
sudo systemctl restart NetworkManager
cat /etc/hosts >> hosts.log
