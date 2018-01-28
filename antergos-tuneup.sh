#!/bin/bash

#This is for service management, probably a bad ideal, but...
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
		echo "Please enter the name of a service to enable"
		read service
		sudo systemctl enable $service
	;;
	2)
		systemctl list-unit-files --type=service | grep enabled
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
		echo "Smart choice. Exiting."
		sleep 2
	;;
esac

#This refreshes systemd in case of changed or failed units
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

#This will reload the firewall to ensure it's enabled
sudo ufw reload

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

#This allows you to remove any other unwanted junk on your system
echo "Are there any other applications you'd like to remove(Y/n)"
read answer 
while [ $answer ==  Y ];
do
	echo "Please enter the name of any software you wish to remove"
	read software
	sudo pacman -Rs --noconfirm $software
	break
done

#Optional This will remove the pamac cached applications and older versions
cat <<_EOF_
It's probably not a great idea to be cleaning this part of the system
all willy nilly, but here is a way to free up some space before doing
backups that may cause you to not be able to downgrade, so be careful. 
It is possible and encouraged to clean all but the latest three versions of software on your
system that you may not need, but this removes all backup versions. 
You will be given a choice, but it is strongly recommended that you use the simpler option to 
remove only up to the latest three versions of your software. Thanks. 
_EOF_

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
while [ $answer == Y ];
do 
	Mountpoint=$(lsblk | grep  sdb1 | awk '{print $7}')
	if [[ $Mountpoint != /mnt ]];
	then
		sudo mount /dev/sdb1 /mnt
		sudo rsync -aAXv --delete --exclude={/dev/*,/home/*/Music/*,/home/*/Wallpapers,/media/*,/mnt/*,/proc/*,/run/*,/sys/*,/tmp/*,/lost+found} / /mnt/JamesBackup/
	fi

	sudo sync && sudo umount /dev/sdb1

break
done

#This tries to restore the home folder
echo "Would you like to restore the home folder?(Y/n)"
read answer 
while [ $answer == Y ];
do
cat <<_EOF_
This tries to restore the home folder and nothing else, if you want to 
restore the entire system,  you will have to do that in a live environment.
This can, however, help in circumstances where you have family photos and
school work stored in the home directory. This also assumes that your home
directory is on the drive in question. 
_EOF_

	Mountpoint=$(lsblk | grep  sdb1 | awk '{print $7}')
	if [[ $Mountpoint != /mnt ]];
	then
		read -p "Please insert the backup drive and hit enter..."
		sleep 1 
		sudo mount /dev/sdb1 /mnt 
		sudo rsync -aAXv \ /media/$user/XBT_Drive/XBT_Backups/$host/Home_Backup/ \
		/home/
	fi 
	
	sudo sync && sudo umount /dev/sdb1

break
done

#Optional and prolly not needed
#sudo e4defrag / -c > fragmentation.log #Only to be used on HDD

#This will reboot the system
sudo systemctl reboot
