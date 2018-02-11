#!/bin/bash

#This is for service management Prolly not a great idea, but...
cat <<_EOF_
This is usually better off left undone, only disable services you know 
you will not need or miss. I can not be held responsible if you brick your system.
Handle with caution.
_EOF_

echo "Which would you like to do?"
echo "1 - enable service"
echo "2 - disable service"
echo "3 - save a copy of all the services on your system to a text file"
echo "4 - Exit without doing anything"

read operation;
 
case $operation in
	1) 
		systemctl list-unit-files --type=service | grep disabled
		sleep 3
		echo "Please enter the name of a service to enable"
		read service
		sudo systemctl enable $service
	;;
	2)
		systemctl list-unit-files --type=service | grep enabled
		sleep 3
		echo "Please enter the name of a service to disable"
		read service 
		sudo systemctl disable $service
	;;
	3)
		systemctl list-unit-files --type=service >> services.txt
		echo "Thank you for your patience"
		sleep 3
	;;
	4)
		echo "Smart choice."
		sleep 2
	;;
esac

#This refreshes systemd in case of failed or changed units
sudo systemctl daemon-reload

#This will try to ensure you have a strong network connection
for c in computer;
do 
	ping -c4 google.com 
	if [[ $? -eq 0 ]];
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

#This gives a list of available kernels and offers to both install and uninstall them
echo "What would you like to do today?"
echo "1 - Install new kernel(s)"
echo "2 - Uninstall kernel(s)"
echo "3 - save a list of available and installed kernels to a text file"
echo "4 - skip"

read operation;

case $operation in
	1)
	sudo mhwd-kernel -l
	sleep 3
	echo "Are you sure you want to install a kernel?(Y/n)"
	read answer
	while [ $answer == Y ];
	do
		echo "Enter the name of the kernel you wish to install"
		read kernel
		sudo mhwd-kernel -i $kernel
	break
	done
;;
	2)
	sudo mhwd-kernel -li 
	sleep 3
	echo "Are you sure you want to remove a kernel?(Y/n)"
	read answer
	while [ $answer == Y ];
	do
		echo "Enter the name of the kernel you wish to remove"
		read kernel
		sudo mhwd-kernel -r $kernel
	break
	done
;;
	3)
	sudo mhwd-kernel -l >> kernels.txt
	echo "######################################################" >> kernels.txt
	sudo mhwd-kernel -li >> kernels.txt
;;
	4)
	echo "Skipping"
;;
esac

#This will reload the firewall to ensure it's enabled
sudo ufw reload

#This will clean the cache
sudo rm -r .cache/*
sudo rm -r .thumbnails/*
sudo rm -r ~/.local/share/Trash
sudo rm -r ~/.nv/*
sudo rm -r ~/.local/share/recently-used.xbel
sudo rm -r /tmp/* 
find ~/Downloads/* -type f -mtime +1 -exec rm {} \; #Deletes contents older than one day
history -cw && cat /dev/null/ > ~/.bash_history

#This could clean your Video folder and Picture folder based on a set time
TRASHCAN=~/.local/share/Trash/
find ~/Videos/* -mtime +30 -exec mv {} $TRASHCAN \; #throws away month old content
find ~/Pictures/* -mtime +30 -exec mv {} $TRASHCAN \; #The times can be changed

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

#This allows the user to remove unwanted shite
echo "Would you like to remove any other unwanted shite?(Y/n)"
read answer 
while [ $answer == Y ];
do
	echo "Please enter the name of any software you wish to remove"
	read software
	sudo pacman -Rs --noconfirm $software
	break
done

#Optional This will remove the pamac cached applications and older versions
echo "What would you like to do?"
echo "1 - Remove up to the latest three versions of software"
echo "2 - Remove all cache except for the version on your system"
echo "3 - Remove all cache from every package and every version"
echo "4 - Skip this step"

read operation;

case $operation in 
	1)
	sudo paccache -rvk3
	sleep 3
	;;
	2)
	sudo pacman -Sc --noconfirm 
	sleep 3
	;;
	3)
	sudo pacman -Scc --noconfirm
	sleep 3
	;;
	4)
	echo "NICE!"
	;;
esac

#This will ensure you are up to date and running fastest mirrors 
sudo pacman-mirrors -b unstable
sudo pacman -Syyu --noconfirm

#This refreshes index cache
sudo updatedb && sudo mandb 

#update the grub 
sudo grub-mkconfig -o /boot/grub/grub.cfg

#This runs a disk checkup and attempts to fix filesystem
sudo touch /forcefsck 

#This will create a backup of your system
echo "Would you like to make a backup? (Y/n)"
read answer
while [ $answer == Y ];
do
	Mountpoint=$(lsblk | grep  sdb1 | awk '{print $7}')
	if [[ $Mountpoint != /mnt ]];
	then
		sudo mount /dev/sdb1 /mnt
		sudo rsync -aAXv --delete --exclude={/dev/*,/home/*/Music/*,/home/*/Wallpapers,/media/*,/mnt/*,/proc/*,/run/*,/sys/*,/tmp/*,/lost+found} / /mnt/JamesBackup/
	fi

	sudo sync
	sudo umount /dev/sdb1

break
done

#Optional and prolly not needed
#sudo e4defrag / -c > fragmentation.log #only to be used on HDD

#This will sync any data and reboot the system
sudo sync && sudo systemctl reboot
