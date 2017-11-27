#!/bin/bash

#This restarts systemd daemon. This can be useful for different reasons.
sudo systemctl daemon-reload #For systemd releases

#This will try to ensure you have a strong network connection
for c in computer;
do 
	ping -c4 google.com 
	if [ $? -eq 0 ]
	then 
		echo "Connection successful"
	else
		interface=$(ip -o -4 route show to default | awk '{print $5}')
		sudo dhclient -v -r && sudo dhclient
		sudo systemctl stop NetworkManager.service
		sudo systemctl disable NetworkManager.service
		sudo systemctl enable NetworkManager.service
		sudo systemctl start NetworkManager.service
		sudo iplink set $interface up #Refer to networkconfig.log
	fi
done 

#This reconfigures packages, should you wish to, fixes some things #May not work on new systems.
#sudo dpkg-reconfigure -a 
#sudo apt-get install --reinstall initramfs-tools

#It is recommended that your firewall is enabled
sudo ufw disable && sudo ufw enable

#This flushes apt cache
sudo apt-get -y autoremove
sudo apt-get -y autoclean 
sudo apt-get clean 

#This clears the cache and thumbnails and other junk
sudo rm -r .cache/*
sudo rm -r .thumbnails/*
sudo rm -r ~/.local/share/Trash
sudo rm -r ~/.nv/*
sudo rm -r ~/.local/share/recently-used.xbel
sudo rm -r /tmp/*
find ~/Downloads/* -mtime +1 -exec rm {} \; #Deletes content over 1 day old
history -cw && cat /dev/null/? ~/.bash_history

#This could clean your Video folder and Picture folder based on a set time
TRASHCAN=~/.local/share/Trash/
find ~/Video/* -mtime +30 -exec mv {} $TRASHCAN \; #Throws away month old content
find ~/Pictures/* -mtime +30 -exec mv {} $TRASHCAN \;

#check for and remove broken symlinks
find -xtype l -delete

#clean some unneccessary files leftover by applications in home directory
find $HOME -type f -name "*~" -print -exec rm {} \;

#Optionally, you can remove old backups to make room for new ones
find /Backups/* -mtime +30 -exec rm {} \;
 
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

#This will make a backup of your system
echo "Would you like to make a backup? (Y/n)"
read answer
if [[ $answer == Y ]];
then 
	sudo rsync -aAXv --exclude=dev --exclude=proc --exclude=Backups --exclude=Music --exclude=sys --exclude=tmp --exclude=run --exclude=mnt --exclude=media --exclude=lost+found / /Backups
else 
	echo "It is a good idea to create a backup after such changes, maybe later."
fi

#Optional and prolly not needed
#sudo e4defrag / -c > fragmentation.log #Only to be used on HDD

#You should really reboot now!
sudo systemctl reboot 
