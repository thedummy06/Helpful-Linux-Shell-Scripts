#!/bin/bash

#This sets your default editor in bashrc
echo "export EDITOR=nano" | sudo tee -a /etc/bash.bashrc

#This activates the firewall
sudo ufw enable
#sudo ufw deny telnet
#sudo ufw deny ssh

#This will ensure you do not have any common network issues
for c in computer; 
do 
	ping -c4 google.com > /dev/null
	if [ $? -eq 0 ]
	then 
		echo "Connection successful!"
	else
		ifconfig >> ifconfig.txt
		sudo dhclient -v -r && sudo dhclient
		sudo mmcli nm enable false 
		sudo nmcli nm enable true
		sudo /etc/init.d/ network-manager restart
		sudo ifconfig $interfacename up #Refer to ifconfig.txt
	fi
done

#This will update your system
sudo apt-get update 
sudo apt-get -y upgrade
sudo apt-get -y dist-upgrade 

#This will install your main apps for you   
sudo apt-get -y install gparted bleachbit ncdu gufw
sudo apt-get -y install psensor hardinfo lm-sensors epiphany-browser
sudo apt-get -y install apparmor-profiles apparmor-utils traceroute  
sudo apt-get -y install inxi iotop htop nmap
#Optional
#sudo apt-get install qupzilla
#sudo apt-get install midori
#sudo apt-get install rhythmbox
#sudo apt-get install gnome-tweak-tool
#sudo apt-get install pidgin
#sudo apt-get install parole
#sudo apt-get install banshee
#sudo apt-get install deluge
#sudo apt-get install qbittorrent
#sudo apt-get install simplescreenrecorder
#sudo apt-get install kdenlive
#sudo apt-get install pavucontrol
#sudo apt-get install chromium-browser
#sudo apt-get install zenmap

#This tries to install codecs
echo "This will install codecs." 
echo "These depend upon your environment."

echo "1 - ubuntu-restricted-extras"
echo "2 - xubuntu-restricted-extras"
echo "3 - lubuntu-restricted-extras"
echo "4 - kubuntu-restricted-extras"
echo "5 - exit"

read operation;

case $operation in 
		1) sudo apt-get -y install ubuntu-restricted-extras ;;
		2) sudo apt-get -y install xubuntu-restricted-extras ;;
		3) sudo apt-get -y install lubuntu-restricted-extras ;;
		4) sudo apt-get -y install kubuntu-restricted-extras ;;
		5) echo "Moving on!"
esac

#Optional
echo "Would you like to install games? (Y/n)" 
read Answer
if [[ $Answer == Y ]];
then 
	#sudo apt-get -y install supertuxkart
	sudo apt-get -y install gnome-mahjongg aisleriot ace-of-penguins 
	sudo apt-get -y install gnome-sudoku gnome-mines chromium-bsu supertux
fi 

#This will install themes
echo "Would you like a dark theme? (Y/n)"
read answer 
if [[ $answer == Y ]]; 
then
	sudo add-apt-repository ppa:noobslab/themes 
	sudo apt-add-repository ppa:numix/ppa
	sudo add-apt-repository ppa:noobslab/icons
	sudo add-apt-repository ppa:moka/stable
	sudo add-apt-repository ppa:noobslab/themes
	sudo add-apt-repository ppa:noobslab/themes
	sudo apt-get update
	sudo apt-get install mate-themes gtk2-engines-xfce gtk3-engines-xfce
	sudo apt-get install numix-icon-theme-circle
	sudo apt-get install emerald-icon-theme
	sudo apt-get install dalisha-icons
	sudo apt-get install moka-icon-theme
	sudo apt-get install faenza-icon-theme
	sudo apt-get install windos-10-themes
else
	echo "Guess not!"
fi

#System tweaks
sudo cp /etc/default/grub /etc/default/grub.bak
sudo sed -i -e '/GRUB_TIMEOUT=10/c\GRUB_TIMEOUT=5 ' /etc/default/grub
sudo update-grub2

#Tweaks the sysctl config file
sudo cp /etc/sysctl.conf /etc/sysctl.conf.bak
echo "# Reduces the swap" | sudo tee -a /etc/sysctl.conf
echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.conf
echo "# Improve cache management" | sudo tee -a /etc/sysctl.conf
echo "vm.vfs_cache_pressure=50" | sudo tee -a /etc/sysctl.conf
echo "#tcp flaw workaround" | sudo tee -a /etc/sysctl.conf
echo "net.ipv4.tcp_challenge_ack_limit = 999999999" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

#This should improve performance on some mechanical drives
echo "Would you like to increase HDD performance? (Y/n)"
read answer
if [[ $answer == Y ]];
then 
    echo "Please enter your drive name"
    read drive
	sudo hdparm -W 1 $drive
else 
	echo "Write-back caching improves hard drive performance."
fi

#Hosts file to thwart adverts
echo "Would  you like to use a hosts file? (Y/n)"
read answer
if [[ $answer == Y ]];
then 
	sudo ./hostsman4linux.sh
else 
	echo "Maybe later!"
fi

#Optional, but it is highly recommended that you make a quick backup
#The backup directory can be found in your root folder, unless you specify #otherwise
#cd /
#sudo mkdir Backup
#sudo rsync -aAXv --exclude=dev --exclude=Backup --exclude=proc --exclude=sys --exclude=tmp --exclude=run --exclude=mnt --exclude=media --exclude=lost+found --exclude=var/cache/pacman/pkg / /Backup
#Or for home folder only
#sudo rsync -aAXv /home/$USER/ ~/Backup

#Let's reboot
sudo sync && sudo systemctl reboot
