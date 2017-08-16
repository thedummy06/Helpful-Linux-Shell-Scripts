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
sudo apt-get -y install psensor hardinfo lm-sensors
sudo apt-get -y install traceroute epiphany-browser
sudo apt-get -y install inxi iotop htop nmap
#Optional
#sudo apt-get -y install qupzilla
#sudo apt-get -y install midori
#sudo apt-get -y install rhythmbox
#sudo apt-get -y install gnome-tweak-tool
#sudo apt-get -y install pidgin
#sudo apt-get -y install parole
#sudo apt-get -y install banshee
#sudo apt-get -y install deluge
#sudo apt-get -y install qbittorrent
#sudo apt-get -y install simplescreenrecorder
#sudo apt-get -y install kdenlive
#sudo apt-get -y install pavucontrol
#sudo apt-get -y install chromium-browser
#sudo apt-get -y install zenmap

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
	sudo apt-get -y install supertuxkart
	sudo apt-get -y install gnome-mahjongg aisleriot ace-of-penguins 
	sudo apt-get -y install gnome-sudoku gnome-mines chromium-bsu supertux
fi 

#This will install themes
echo "Would you like a dark theme? (Y/n)"
read answer 
if [[ $answer == Y ]]; 
then
	sudo add-apt-repository -y ppa:noobslab/themes 
	sudo apt-add-repository -y ppa:numix/ppa
	sudo add-apt-repository -y ppa:noobslab/icons
	sudo add-apt-repository -y ppa:moka/stable
	sudo add-apt-repository -y ppa:noobslab/themes
	sudo add-apt-repository -y ppa:noobslab/themes
	sudo apt-get update
	sudo apt-get -y install mate-themes gtk2-engines-xfce gtk3-engines-xfce
	sudo apt-get -y install numix-icon-theme-circle
	sudo apt-get -y install emerald-icon-theme
	sudo apt-get -y install dalisha-icons
	sudo apt-get -y install moka-icon-theme
	sudo apt-get -y install faenza-icon-theme
	sudo apt-get -y install windos-10-themes
else
	echo "Guess not!"
fi

#System tweaks
sudo cp /etc/default/grub /etc/default/grub.bak
sudo sed -i -e '/GRUB_TIMEOUT=10/c\GRUB_TIMEOUT=3 ' /etc/default/grub
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
	sudo ./hostsman4ubuntu.sh
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
