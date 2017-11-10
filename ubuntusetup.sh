#!/bin/bash

#This sets your default editor in bashrc
echo "export EDITOR=nano" | sudo tee -a /etc/bash.bashrc

#This activates the firewall
sudo systemctl enable ufw
sudo ufw enable
#sudo ufw deny telnet
#sudo ufw deny ssh

ip addr >> networkconfig.log

#This will ensure you do not have any common network issues
for c in computer; 
do 
	ping -c4 google.com > /dev/null
	if [ $? -eq 0 ]
	then 
		echo "Connection successful!"
	else
		interface=$(ip -o -4 route show to default | awk '{print $5}')
		sudo dhclient -v -r && sudo dhclient
		sudo mmcli nm enable false 
		sudo nmcli nm enable true
		sudo /etc/init.d/ network-manager restart
		sudo ifconfig $interface up #Refer to networkconfig.log
	fi
done

#This disables ipv6
echo "Sometimes ipv6 can cause network issues. Would you like to disable it?(Y/n)"
read answer 
if [[ $answer == Y ]];
then
	sudo cp /etc/default/grub /etc/default/grub.bak
	sudo sed -i -e 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="ipv6.disable=1"/g' /etc/default/grub
	sudo update-grub2
else
	echo "Okay!"
fi

#This will update your system
sudo apt-get update 
sudo apt-get -y upgrade
sudo apt-get -y dist-upgrade 

read -p "Press Enter to continue."

#This will install your main apps for you   
sudo apt-get -y install gparted bleachbit ncdu gufw inxi iotop rkhunter xsensors hardinfo lm-sensors traceroute nmap htop
#Optional
#sudo apt-get -y install clamav
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
#sudo apt-get -y install epiphany-browser

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

#Optional ligthweight web browser alternative
echo "Would you like to install a good firefox alternative? (Y/n)"
read answer
if [[ answer == Y ]];
then
	wget https://linux.palemoon.org/datastore/release/pminstaller-0.2.3.tar.bz2
	tar -xvjf pminstaller-0.2.3.tar.bz2
	./pminstaller.sh
else 
	echo "Pale Moon is private and secure."
fi 

#Optional from askubuntu.com method to install google-chrome
cd /tmp
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
sudo apt-get -f install

#Optional
echo "Would you like to install games? (Y/n)" 
read Answer
if [[ $Answer == Y ]];
then 
	sudo apt-get -y install supertuxkart gnome-mahjongg aisleriot ace-of-penguins gnome-sudoku gnome-mines chromium-bsu supertux
else
	echo "Moving on!"
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
	sudo apt-get update
	sudo apt-get -y install mate-themes gtk2-engines-xfce gtk3-engines-xfce numix-icon-theme-circle emerald-icon-theme moka-icon-theme windows-10-themes dalisha-icons faenza-icon-theme
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

#Hosts file to block adverts
echo "Would  you like to use a hosts file? (Y/n)"
read answer
if [[ $answer == Y ]];
then 
	sudo ./hostsman4ubuntu.sh
else 
	echo "Maybe later!"
fi

#Optional, but it is highly recommended that you make a quick backup
echo "Would you like to make a backup? (Y/n)"
read answer
if [[ $answer == Y ]];
then 
	sudo rsync -aAXv --exclude=dev --exclude=proc --exclude=Backups --exclude=Music --exclude=sys --exclude=tmp --exclude=run --exclude=mnt --exclude=media --exclude=lost+found / /Backups
else 
	echo "It is a good idea to create a backup after such changes, maybe later."
fi

#This adds a few aliases to bashrc
echo "Aliases are shortcuts to commonly used commands."
echo "would you like to add some aliases?(Y/n)"
read answer 

if [[ $answer == Y ]];
then 
	sudo cp ~/.bashrc ~/.bashrc.bak
	echo "#Alias to update the system" >> ~/.bashrc
	echo 'alias update="sudo apt-get update && sudo apt-get -y dist-upgrade"' >> ~/.bashrc
	echo "#Alias to clean the apt cache" >> ~/.bashrc
	echo 'alias apt clean="sudo apt-get autoremove && sudo apt-get autoclean && sudo apt-get clean"' >> ~/.bashrc
fi

#Let's reboot
sudo sync && sudo systemctl reboot
