#!/bin/bash

#This refreshes systemd in case of changed or failed units
sudo systemctl daemon-reload

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
		sudo ip link set $interface up #Refer to networkconfig.log
	fi
done  

#This will reload the firewall to ensure it's enabled
sudo ufw disable && sudo ufw enable

#This will clean the cache
sudo rm -r .cache/*
sudo rm -r .thumbnails/* 
sudo rm -r ~/.local/share/Trash
sudo rm -r ~/.nv/*
sudo rm -r ~/.local/share/recently-used.xbel
sudo rm -r /tmp/*
find ~/Downloads/* -mtime +1 -exec rm {} \; #Deletes content older than one day
history -cw && cat /dev/null/ > ~/.bash_history

#This could clean your Video folder and Picture folder based on a set time
TRASHCAN=~/.local/share/Trash/
find ~/Video/* -mtime +30 -exec mv {} $TRASHCAN \; #Throws away content one month old
find ~/Pictures/* -mtime +30 -exec mv {} $TRASHCAN \;

#Sometimes it's good to check for and remove broken symlinks
find -xtype l -delete

#clean some unneccessary files leftover by applications in home directory
find $HOME -type f -name "*~" -print -exec rm {} \;

#Optionally, you can remove old backups to make room for new ones
find /Backups/* -mtime +30 -exec rm {} \;

#This helps get rid of old archived log entries
sudo journalctl --vacuum-size=25M 

#This will remove orphan packages from pacman 
sudo pacman -Rsn --noconfirm $(pacman -Qqdt)

#Optional This will remove the pamac cached applications and older versions
sudo pacman -Sc --noconfirm

#This will ensure you are up to date and running fastest mirrors 
sudo reflector -l 50 -f 20 --save /tmp/mirrorlist.new && rankmirrors -n 0 /tmp/mirrorlist.new > /tmp/mirrorlist && sudo cp /tmp/mirrorlist /etc/pacman.d
sudo rankmirrors -n 0 /etc/pacman.d/antergos-mirrorlist > /tmp/antergos-mirrorlist && sudo cp /tmp/antergos-mirrorlist /etc/pacman.d
sudo pacman -Syyu --noconfirm

#This refreshes index cache
sudo updatedb && sudo mandb

#update the grub 
sudo grub-mkconfig -o /boot/grub/grub.cfg >/dev/null

#This runs a disk checkup and attempts to fix filesystem
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

#This will reboot the system
sudo systemctl reboot
