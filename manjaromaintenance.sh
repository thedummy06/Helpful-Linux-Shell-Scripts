#!/bin/bash

#This will try to ensure you have a strong network connection
for c in computer;
do 
	ping -c4 google.com 
	if [ $? -eq 0 ]
	then 
		echo "Connection successful"
	else
		sudo dhclient -v -r && sudo dhclient
		sudo systemctl stop NetworkManager.service
		sudo systemctl disable NetworkManager.service
		sudo systemctl enable NetworkManager.service
		sudo systemctl start NetworkManager.service
		sudo ifconfig $interfacename up #Refer to analysis.txt
	fi
done 

#This refreshes systemd in case of new or failed units
sudo systemctl daemon-reload

#This will reload the firewall to ensure it's enabled
sudo ufw reload

#This will clean the cache
sudo rm -r .cache/*
sudo rm -r .thumbnails/*
sudo rm -r ~/.local/share/Trash
history -c

#This helps get rid of old archived log entries
sudo journalctl --vacuum-size=25M

#This will remove orphan packages from pacman 
sudo pacman -Rs --noconfirm $(pacman -Qqdt)

#Optional This will remove the pamac cached applications and older versions
#sudo pacman -Sc --noconfirm

#This will ensure you are up to date and running fastest mirrors 
sudo pacman-mirrors -g
sudo pacman -Syyu --noconfirm

#This refreshes index cache
sudo updatedb && sudo mandb 

#update the grub 
sudo grub-mkconfig -o /boot/grub/grub.cfg

#This runs a disk checkup and attempts to fix filesystem
sudo touch /forcefsck 

#Sometimes it's good to check for and remove broken symlinks
find -xtype l -delete

#clean some unneccessary files leftover by applications in home directory
find $HOME -type f -name "*~" -print -exec rm {} \;

#This will create a backup of your system
echo "Would you like to make a backup? (Y/n)"
read answer
if [[ $answer == Y ]];
then 
	sudo rsync -aAXv --exclude=dev --exclude=proc --exclude=Backup --exclude=Music --exclude=sys --exclude=tmp --exclude=run --exclude=mnt --exclude=media --exclude=lost+found / /Backup
else 
	echo "It is a good idea to create a backup after such changes, maybe later."
fi

#This will reboot the system
sudo systemctl reboot
