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
elif [[ $package -eq 2 ]];
then 
	wget https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts
	wget https://hosts-file.net/ad_servers.txt
	wget http://sysctl.org/cameleon/hosts -O cameleonhosts
	cat ad_servers.txt >> hosts
	cat cameleonhosts >> hosts
	rm ad_servers.txt cameleonhosts
elif [[ $package -eq 3 ]];
then
	wget http://hosts-file.malwareteks.com/hosts.txt -O hosts
	wget raw.githubusercontent.com/ZeroDot1/CoinBlockerLists/master/hosts -O coinblocker
	wget https://hosts-file.net/hphosts-partial.txt
	wget http://sysctl.org/cameleon/hosts -O cameleonhosts
	cat hphosts-partial.txt >> hosts
	cat cameleonhosts >> hosts
	cat coinblocker >> hosts
	rm hphosts-partial.txt cameleonhost coinblocker
elif [[ $package -eq 4 ]];
then 
	wget https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts
	wget http://hosts-file.malwareteks.com/hosts.txt -O hphosts
	wget https://hosts-file.net/hphosts-partial.txt
	wget https://raw.githubusercontent.com/hectorm/hmirror/master/data/spam404.com/list.txt -O spamhosts && sed -i -e 's/^/0.0.0.0  /' spamhosts
	wget http://sysctl.org/cameleon/hosts -O cameleonhosts
	wget https://raw.githubusercontent.com/hectorm/hmirror/master/data/malwaredomains.com-justdomains/list.txt -O Malwarehosts2 && sed -i 's/^/0.0.0.0  /' Malwarehosts2
	cat hphosts >> hosts
	cat hphosts-partial.txt >> hosts
	cat cameleonhosts >> hosts
	cat spamhosts >> hosts
	cat Malwarehosts2 >> hosts
	rm cameleonhosts hphosts hphosts-partial.txt spamhosts Malwarehosts2
elif [[ $package -eq 5 ]];
then
	wget https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts -O adservers.txt
	wget http://winhelp2002.mvps.org/hosts.txt -O MVPShosts
	wget someonewhocares.org/hosts/hosts
	wget https://raw.githubusercontent.com/lightswitch05/hosts/master/ads-and-tracking-extended.txt -O lightswitch05list
	wget raw.githubusercontent.com/ZeroDot1/CoinBlockerLists/master/hosts -O coinblocker
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
	wget https://raw.githubusercontent.com/zant95/hmirror/master/data/spam404.com/list.txt -O spamhosts && sed -i -e 's/^/0.0.0.0  /' spamhosts
	wget http://hosts-file.malwareteks.com/hosts.txt -O hphosts
	wget https://hosts-file.net/hphosts-partial.txt	
	wget http://sysctl.org/cameleon/hosts -O cameleonhosts
	wget https://raw.githubusercontent.com/zant95/hmirror/master/data/malwaredomains.com-justdomains/list.txt -O Malwarehosts2 && sed -i 's/^/0.0.0.0  /' Malwarehosts2
	cat MVPShosts >> hosts
	cat coinblocker >> hosts
	cat Malwarehosts >> hosts
	cat lightswitch05list >> hosts
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
	cat unchecky >> hosts
	cat spamhosts >> hosts
	cat hphosts >> hosts
	cat hphosts-partial.txt >> hosts
	cat cameleonhosts >> hosts
	cat Malwarehosts2 >> hosts
	rm KADhosts.txt MVPShosts lightswitch05list coinblocker Malwarehosts Malwarehosts2 add.Spam add.Dead add.Risk add.2o7Net Badd-Boyz tyzbit adservers.txt hphosts-partial.txt hphosts cameleonhosts unchecky spamhosts Stevenhosts Pron Pron2 Gamblinglist fakenews
elif [[ $package -eq 6 ]];
then
	echo "This could block sites that you need, you've been warned."
	sleep 1
	wget hosts-file.net/ad_servers.txt
	wget raw.githubusercontent.com/ZeroDot1/CoinBlockerLists/master/hosts -O coinblocker
	wget https://raw.githubusercontent.com/joeylane/hosts/master/hosts # Does block google
	cat ad_servers.txt >> hosts
	cat coinblocker >> hosts
	rm ad_servers.txt coinblocker
	#grep -v "Google.com" hosts > /tmp/hosts.new && mv /tmp/hosts.new hosts #This unblocks google.com outright
elif [[ $package -eq 7 ]];
then
#Really large hosts file
	wget https://github.com/mitchellkrogza/Ultimate.Hosts.Blacklist/blob/master/hosts.zip?raw=true
	unzip 'hosts.zip?raw=true'
	mv hosts.txt hosts
	wget raw.githubusercontent.com/ZeroDot1/CoinBlockerLists/master/hosts -O coinblocker
	cat coinblocker >> hosts
	rm'hosts.zip?raw=true' coinblocker
elif [[ $package -eq 8 ]];
then
#Umatrix style formula with some extra
	wget hosts-file.net/ad_servers.txt
	wget someonewhocares.org/hosts/hosts
	wget raw.githubusercontent.com/ZeroDot1/CoinBlockerLists/master/hosts -O coinblocker
	wget http://sysctl.org/cameleon/hosts -O cameleonhosts
	wget http://winhelp2002.mvps.org/hosts.txt -O MVPShosts
	wget http://www.malwaredomainlist.com/hostslist/hosts.txt -O Malwarehosts
	wget https://raw.githubusercontent.com/hectorm/hmirror/master/data/pgl.yoyo.org/list.txt -O Petersadslist && sed -i -e 's/^/0.0.0.0  /' Petersadslist
	wget https://raw.githubusercontent.com/hectorm/hmirror/master/data/malwaredomains.com-immortaldomains/list.txt -O Malware2 && sed -i -e 's/^/0.0.0.0  /' Malware2
	wget https://raw.githubusercontent.com/hectorm/hmirror/master/data/spam404.com/list.txt -O Spamhosts && sed -i -e 's/^/0.0.0.0  /' Spamhosts
	cat MVPShosts >> hosts 
	cat Malwarehosts >> hosts 
	cat Petersadslist >> hosts
	cat Malware2 >> hosts
	cat cameleonhosts >> hosts
	cat ad_servers.txt >> hosts
	cat Spamhosts >> hosts
	cat coinblocker >> hosts
	rm ad_servers.txt Petersadslist coinblocker Malwarehosts Malware2 Spamhosts MVPShosts cameleonhosts
else 
	echo "Run again and pick a valid number."
	exit
fi

#These can add extra lists for deeper blocking of ads
echo "Would you like to add some extra domains?(Y/n)"
read answer 
if [[ $answer == Y ]];
then 
	wget https://raw.githubusercontent.com/bjornstar/hosts/master/hosts -O bjornhosts
	cat bjornhosts >> hosts 
	rm bjornhosts
fi

echo "This hosts file also doesn't update everyday, however, it does block some third-parties that others do not."
echo "Would you like to add My own hosts list?(Y/n)"
read answer
if [[ $answer == Y ]];
then
	wget https://raw.githubusercontent.com/thedummy06/Helpful-Linux-Shell-Scripts/master/extrahosts
	cat extrahosts >> hosts
	rm extrahosts
fi

echo "Are there any other domains that you wish to exclude?(Y/n)"
read answer
while [ $answer == Y ]
do
	read -p "Enter any other domains you wish to exclude up to 10:" Domain1 Domain2 Domain3 Domain4 Domain5 Domain6 Domain7 Domain8 Domain9 Domain10
	grep -v "$Domain1" hosts > /tmp/hosts.new && mv /tmp/hosts.new hosts
	grep -v "$Domain2" hosts > /tmp/hosts.new && mv /tmp/hosts.new hosts
	grep -v "$Domain3" hosts > /tmp/hosts.new && mv /tmp/hosts.new hosts
	grep -v "$Domain4" hosts > /tmp/hosts.new && mv /tmp/hosts.new hosts
	grep -v "$Domain5" hosts > /tmp/hosts.new && mv /tmp/hosts.new hosts
	grep -v "$Domain6" hosts > /tmp/hosts.new && mv /tmp/hosts.new hosts
	grep -v "$Domain7" hosts > /tmp/hosts.new && mv /tmp/hosts.new hosts
	grep -v "$Domain8" hosts > /tmp/hosts.new && mv /tmp/hosts.new hosts
	grep -v "$Domain9" hosts > /tmp/hosts.new && mv /tmp/hosts.new hosts
	grep -v "$Domain10" hosts > /tmp/hosts.new && mv /tmp/hosts.new hosts
break
done

#This ensures that we are using All 0's for pointing back to home
sed -i 's/127.0.0.1/0.0.0.0/g' hosts

#This attempts to dedupe the file as much as possible
uniq -u hosts > /tmp/hosts.new && mv /tmp/hosts.new hosts

sudo cat hosts >> /etc/hosts
rm hosts

#Checking distribution to determine best way to restart network
	distribution=$(cat /etc/issue | awk '{print $1}')
	find /etc/issue
	while [ $? -eq 0 ]
	do 
		if [ $distribution == Ubuntu ]
		then
			sudo /etc/init.d/network-manager restart
		elif [ $distribution == Debian ]
		then
			sudo /etc/init.d/network-manager restart
		elif [ $distribution == Linux ]
		then 
			sudo /etc/init.d/network-manager restart
		elif [ $distribution == Manjaro ]
		then
			sudo systemctl restart NetworkManager
		elif [ $distribution == Antergos ]
		then
			sudo systemctl restart NetworkManager
		else
			echo "You're using a distribution I have not tested yet"
		fi
		break
	done
	
	while [ $? -gt 0 ]
	do 
		find /etc/issue.net
		if [ $distribution == Ubuntu ]
		then
			sudo /etc/init.d/network-manager restart
		elif [ $distribution == Debian ]
		then
			sudo /etc/init.d/network-manager restart
		elif [ $distribution  == Linux ]
		then 
			sudo /etc/init.d/network-manager restart
		elif [ $distribution == Manjaro ]
		then
			sudo systemctl restart NetworkManager
		elif [ $distribution == Antergos ]
		then
			sudo systemctl restart NetworkManager
		else
			echo "You're using a distribution I have not tested yet"
		fi
		break
	done

cat /etc/hosts > $house/logs/hosts.log
