#!/bin/bash

#This will ensure you do not have any common network issues
for c in computer; 
do ping -c4 google.com > /dev/null
if [ $? -eq 0 ]
then 
	echo "Connection successful!"
else
ifconfig >> ifconfig.txt
sudo nmcli nm enable false 
sudo nmcli nm enable true
sudo /etc/init.d/network-manager restart
sudo ifconfig up $interfacename #Refer to ifconfig.txt
sudo dhclient -r $interfacename && sudo dhclient $interfacename
fi
done

#This will update the system
sudo apt-get update 
sudo apt-get -y upgrade
sudo apt-get -y dist-upgrade

#This will install your main apps for you
sudo apt-get -y install transmission thunderbird libreoffice
sudo apt-get -y install gnome-disk-utility xfburn
sudo apt-get -y install file-roller gparted vlc
sudo apt-get -y install psensor hardinfo lm-sensors 
sudo apt-get -y install hexchat bleachbit gedit 
sudo apt-get -y install apparmor-profiles apparmor-utils 
sudo apt-get -y install traceroute gdebi epiphany-browser
sudo apt-get -y install synaptic gufw htop
sudo apt-get -y install ncdu software-properties-common
sudo apt-get -y install bodhi-online-media bum
sudo apt-get -y install moksha-clipboard chromium-browser
sudo apt-get -y install qalculate iotop handbrake
sudo apt-get -y install exterminator inxi nmap
sudo apt-get -y install bodhi-backgrounds-pack
#Optional extra software
#sudo apt-get install epiphany-browser
#sudo apt-get install firefox
#sudo apt-get install pidgin
#sudo apt-get install rhythmbox
#sudo apt-get install deluge
#sudo apt-get install qbittorrent
#sudo apt-get install parole
#sudo apt-get install simplescreenrecorder
#sudo apt-get install kdenlive
#sudo apt-get install pavucontrol
#sudo apt-get install preload
#sudo apt-get install ubuntu-restricted-extras ##Only necessary in version 4.0 & higher

#This will install a game or two if you like
echo "Do you wish to install a game(s)? (Y/n)"
read answer
if [[ $answer == Y ]];
then 
#sudo apt-get install supertuxkart #Newer versions are intense on resources
sudo apt-get install ace-of-penguins gnome-mines gnome-sudoku
sudo apt-get install chromium-bsu gnome-mahjongg aisleriot
else
echo "OK!" 
fi 

#This will install themes
echo "Would you like some cool themes? (Y/n)"
read answer 
if [[ $answer == Y ]];
then
sudo add-apt-repository ppa:noobslab/themes
sudo add-apt-repository ppa:noobslab/themes
sudo apt-add-repository ppa:numix/ppa
sudo add-apt-repository ppa:noobslab/icons
sudo add-apt-repository ppa:noobslab/icons
sudo add-apt-repository ppa:moka/stable
sudo apt-get update 
sudo apt-get install mate-themes gtk2-engines-xfce gtk3-engines-xfce
sudo apt-get install bodhi-theme-moksha-green 
sudo apt-get install bodhi-theme-e17-magic-bodhi
sudo apt-get install bodhi-theme-e17-sirius
sudo apt-get install bodhi-theme-e17-rednight
sudo apt-get install bodhi-theme-e17-genesis
sudo apt-get install bodhi-theme-e17-mystery
sudo apt-get install bodhi-theme-e17-egypt
sudo apt-get install bodhi-gtk-black-out
sudo apt-get install dalisha-icons
sudo apt-get install moka-icon-theme
sudo apt-get install emerald-icon-theme
sudo apt-get install numix-icon-theme-circle
sudo apt-get install dorian-theme
sudo apt-get install delorean-dark
sudo apt-get install faenza-icon-theme
else 
echo "Guess not!"
fi

#This will install pale moon
#wget http://linux.palemoon.org/files/pminstaller/0.2.2/pminstaller-0.2.2.tar.bz2
#sudo tar -xvjf pminstaller-0.2.2.tar.bz2
#./pminstaller.sh

#exports the chosen editor to bashrc
echo "export EDITOR=nano" | sudo tee -a /etc/bash.bashrc

#These are system tweaks
sudo cp /etc/default/grub /etc/default/grub.bak
sudo sed -i -e '/GRUB_TIMEOUT=10/c\GRUB_TIMEOUT=5 '/etc/default/grub
sudo update-grub2

#Tweaks the sysctl.conf file
sudo cp /etc/sysctl.conf /etc/sysctl.conf.bak
echo "# Reduces the swap" | sudo tee -a /etc/sysctl.conf
echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.conf
echo "# Improve cache management" | sudo tee -a /etc/sysctl.conf
echo "vm.vfs_cache_pressure=50" | sudo tee -a /etc/sysctl.conf
echo "net.ipv4.tcp_challenge_ack_limit = 999999999" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

#This should improve performance on SOME mechanical drives 
sudo hdparm -W 1 /drive/name


#This part activates the uncomplicated firewall on your system
sudo ufw enable
sudo ufw deny telnet
sudo ufw allow 51413/tcp
#Optional
#sudo ufw deny ssh #ssh is a secure shell protocol that allows you to log into and interact with multiple clients

#I can prepare a simple hosts file if you like
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
#sudo mkdir backups
#sudo rsync -aAXv --exclude=dev --exclude=proc --exclude=sys --exclude=tmp --exclude=run --exclude=mnt --exclude=media --exclude=lost+found --exclude=backups --exclude=var/cache/pacman/pkg / /backups
#Or for home folder only
#sudo rsync -aAXv /home/$USER/ /backups

#Now would be a great time to reboot
sudo sync && sudo systemctl reboot
