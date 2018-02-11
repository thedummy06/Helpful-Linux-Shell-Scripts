#!/bin/bash

init=$(ps -p1 | awk 'NR!=1{print $4}')

for init in $init;
do
if [[ $init == upstart ]];
then
	echo "What would you like to do?"
	echo "1 - Enable services"
	echo "2 - Disable services"
	echo "3 - create a list of all services running on your system"
	echo "4 - Nothing just get me out of this menu"

	read operation;

	case $operation in
		1)
		service --status-all 
		echo "Enter the name of the service you wish to enable"
		read service
		sudo /etc/init.d/$service start
	;;
		2)
		service --status-all 
		echo "Enter the name of the service you wish to disable"
		read service
		sudo /etc/init.d/$service stop 
		echo "Optionally we can create an override which will keep this setting"
		echo "Would you like to retain this setting after reboot?(Y/n)"
		read answer
		while [ $answer == Y ];
		do
			echo manual | sudo tee /etc/init/$service.override
		break
		done
	;;
		3)
		service --status-all >> services.txt
		systemctl list-unit-files --type=service >> services.txt
	;;
		4)
		echo "Great choice"
	;;
	esac
elif [[ $init == systemd ]];
then
	echo "What would you like to do?"
	echo "1 - Enable services"
	echo "2 - Disable services"
	echo "3 - create a list of all services running on your system"
	echo "4 - Nothing just get me out of this menu"

	read operation;

	case $operation in
		1)
		systemctl list-unit-files --type=service | grep disabled
		echo "Enter the name of the service you wish to enable"
		read service
		sudo systemctl enable $service
		sudo systemctl start $service
	;;
		2)
		systemctl list-unit-files --type=service | grep enabled
		echo "Enter the name of the service you wish to disable"
		read service
		sudo systemctl stop $service
		sudo systemctl disable $service
	;;
		3)
		systemctl list-unit-files --type=service >> services.txt
	;;
		4)
		echo "Nice!!!!!"
	;;
	esac
else
	echo "You might be running an init system I haven't tested yet"
fi
done
		
#This restarts systemd daemon. This can be useful for different reasons.
sudo systemctl daemon-reload #For systemd releases

#This will ensure you do not have any common network issues
for c in computer; 
do 
	ping -c4 google.com > /dev/null
	if [[ $? -eq 0 ]];
	then 
		echo "Connection successful!"
	else
		interface=$(ip -o -4 route show to default | awk '{print $5}')
		sudo dhclient -v -r && sudo dhclient
		sudo mmcli nm enable false 
		sudo nmcli nm enable true
		sudo /etc/init.d/ network-manager restart
		sudo ip link set $interface up #Refer to networkconfig.log
	fi
done 

#This reconfigures packages, should you wish to, fixes some things #May not work on new systems.
#sudo dpkg-reconfigure -a 
#sudo apt-get install --reinstall initramfs-tools

#It is recommended that your firewall is enabled
sudo ufw reload

#This flushes apt cache
sudo apt-get -y autoremove
sudo apt-get -y autoclean 
sudo apt-get clean

#This allows you to remove unwanted shite
echo "Are there any other applications you wish to remove(Y/n)"
read answer 
while [ $answer ==  Y ];
do
	echo "Please enter the name of the software you wish to remove"
	sudo apt-get -y remove --purge $software
	break
done

#This clears the cache and thumbnails and other junk
sudo rm -r .cache/*
sudo rm -r .thumbnails/*
sudo rm -r ~/.local/share/Trash
sudo rm -r ~/.nv/*
sudo rm -r ~/.local/share/recently-used.xbel
sudo rm -r /tmp/*
find ~/Downloads/* -mtime +1 -exec rm {} \; #Deletes content over 1 day old
history -cw && cat /dev/null/ > ~/.bash_history

#This could clean your Video folder and Picture folder based on a set time
TRASHCAN=~/.local/share/Trash/
find ~/Videos/* -mtime +30 -exec mv {} $TRASHCAN \; #Throws away month old content
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

#This tries to backup your system
host=$(hostname)
Mountpoint=$(lsblk |awk '{print $7}' | grep /run/media/$USER/*)
if [[ $Mountpoint != /run/media/$USER/* ]];
then
	read -p "Please enter a drive and hit enter"
	echo $(lsblk | awk '{print $1}')
	sleep 1 
	echo "Please select the device you wish to use"
	read device
	sudo mount $device /mnt
	sudo rsync -aAXv --delete --exclude=.cache --exclude=.thumbnails --exclude=Music --exclude=Wallpapers /home/$USER /mnt/$host-backups
else
	echo "Found a block device at designated coordinates, if this is the preferred
	device, try umounting it and then running this again."
fi

#Optional and prolly not needed
#sudo e4defrag / -c > fragmentation.log #Only to be used on HDD

#You should really reboot now!
sudo sync && systemctl reboot 
