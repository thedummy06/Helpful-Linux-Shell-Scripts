#!/bin/bash

#This reconfigures packages, should you wish to, fixes some things
#sudo dpkg-reconfigure -a 
#sudo apt-get install --reinstall initramfs-tools

#This restarts systemd daemon. This can be useful for different reasons.
sudo systemctl daemon-reload #For systemd releases

#It is recommended that your firewall is enabled
sudo ufw reload

#This section displays system information including disk usage, RAM usage
df -h >> analysis.txt
free -h >> analysis.txt
ifconfig -a >> analysis.txt
dmesg >> dmesg.txt
journalctl -a >> journallog.txt 
systemd-analyze >> boot-check.txt
systemd-analyze blame >> boot-check.txt
hostnamectl >> hostname.log
sudo ps aux >> analysis.txt

#This will try to ensure you have a strong network connection
for c in computer;
do 
	ping -c4 google.com 
	if [ $? -eq 0 ]
	then 
		echo "Connection successful"
	else
		ifconfig >> ifconfig.txt
		sudo dhclient -v -r && sudo dhclient
		sudo systemctl stop NetworkManager.service
		sudo systemctl disable NetworkManager.service
		sudo systemctl enable NetworkManager.service
		sudo systemctl start NetworkManager.service
		sudo ifconfig $interfacename up #Refer to ifconfig.txt
	fi
done 

#This flushes apt cache
sudo apt-get -y autoremove
sudo apt-get -y autoclean 
sudo apt-get clean 

#This clears the cache and thumbnails and other junk
sudo rm -r .cache/*
sudo rm -r .thumbnails/*
sudo rm -r ~/.local/share/Trash
history -c

#This trims the journal logs
sudo journalctl --vacuum-size=25M #For newer systemd releases

#This tries to repair dpkg and apt and then update the system.
sudo dpkg --configure -a 
sudo apt-get install -f
sudo apt-get update && sudo apt-get -y dist-upgrade

#This runs update db for index cache and cleans the manual database
sudo updatedb && sudo mandb 

#Checks disk for errors
sudo touch /forcefsck

#check for and remove broken symlinks
find -xtype l -delete

#This will make a backup of your system
echo "Would you like to make a backup? (Y/n)"
read answer
if [[ $answer == Y ]];
then 
	sudo rsync -aAXv --exclude=dev --exclude=proc --exclude=Backup --exclude=Music --exclude=sys --exclude=tmp --exclude=run --exclude=mnt --exclude=media --exclude=lost+found / /Backup
else 
	echo "It is a good idea to create a backup after such changes, maybe later."
fi

#You should really reboot now!
sudo systemctl reboot 
