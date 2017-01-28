#!/bin/bash

#This reconfigures packages, should you wish to, fixes some things
echo -n "Would you like to try reconfiguring the desktop first? Sometimes it helps! (Y/n)"
read answer
if [[ $answer == Y ]];
then 
sudo dpkg-reconfigure -a 
sudo apt-get install --reinstall initramfs-tools
sudo dpkg --configure -a #Incase of broken packages
fi

#This section displays system information including disk usage, RAM usage
mkdir troubleshooting
cd troubleshooting
df -h >> analysis.txt
free -h >> analysis.txt
sudo lspci >> lspci.txt
sudo lsusb >> lsusb.txt
uname -a >> analysis.txt
cat /var/log/dmesg >> dmesg.txt
sudo dmidecode >> dmidecode.txt
#journalctl -a >> journallog.txt #For newer systemd releases
#systemd-analyze >> boottimer.txt #For newer systemd releases
#systemd-analyze blame >> boottimer.txt #For newer systemd releases
sudo blkid >> analysis.txt
lsblk >> analysis.txt
lsb_release -a >> analysis.txt
sudo ps aux >> analysis.txt
ifconfig >> analysis.txt
Xorg -version >> analysis.txt
ldd --version >> analysis.txt
cd 

#This checks for and repairs internet connection
#This mainly checks for wired connections, if you want wireless
#I may include a wireless rendition of this later on as a separate script
for c in computer; 
do ping -c4 google.com > /dev/null
if [ $? -eq 0 ]
then 
	echo "Connection successful!"
else
sudo nmcli nm enable false 
sudo nmcli nm enable true
sudo service network-manager restart
sudo ifconfig eth0 up  
sudo dhclient eth0
fi 
done

#This cleans apt cache
sudo apt-get autoremove
sudo apt-get autoclean 
sudo apt-get clean 

#This clears the cache and thumbnails and other junk
sudo rm -r .cache/*
sudo rm -r .thumbnails/*
sudo rm -r ~/.local/share/Trash

#This trims journal logs
#sudo journalctl --vacuum-size=100M #For newer systemd releases

#This updates the system
sudo apt-get update && sudo apt-get -y dist-upgrade

#This updates the hosts file:Optional 
#sudo ./hostsman4linux.sh

#Checks disk for errors
sudo touch /forcefsck

#Cleans more debris, useful if you're backing up
echo -n "Would you like to run bleachbit? (Y/n)"
read answer
if [[ $answer == Y ]] 
then 
bleachbit
fi 

#It is recommended that your firewall is enabled
sudo ufw disable && sudo ufw enable

#More info?
echo -n "More info can be acquired about your system, open hardinfo? (Y/n)"
read answer
if [[ $answer == Y ]];
then
sudo apt-get install hardinfo 
hardinfo
fi

#Check for and remove broken symlinks
find -xtype l -delete

#You should really reboot now!
sudo shutdown -r now 
