#!/bin/bash

#This will ensure you have a network connection.
for c in computer; 
do ping -c4 google.com > /dev/null
if [ $? -eq 0 ]
then 
	echo "Connection successful!"
else
sudo nmcli nm enable false 
sudo nmcli nm enable true
sudo service network-manager restart
sudo ifconfig eth0 up
sudo dhclient eth0
fi
done

#This will update the system
sudo apt-get update 
sudo apt-get upgrade
sudo apt-get -y dist-upgrade

#This will install your main apps for you
sudo apt-get -y install transmission thunderbird libreoffice
sudo apt-get -y install preload gnome-disk-utility xfburn 
sudo apt-get -y install file-roller gparted vlc
sudo apt-get -y install psensor hardinfo lm-sensors 
sudo apt-get -y install hexchat bleachbit gedit 
sudo apt-get -y install apparmor-profiles apparmor-utils 
sudo apt-get -y install traceroute gdebi chromium-browser
sudo apt-get -y install synaptic gufw htop
sudo apt-get -y install ncdu software-properties-common
sudo apt-get -y install bodhi-online-media bum
sudo apt-get -y install moksha-clipboard
sudo apt-get -y install qalculate iotop handbrake
sudo apt-get -y install exterminator inxi nmap
sudo apt-get -y install bodhi-backgrounds-pack
sudo apt-get install qupzilla
#Optional extra software
#sudo apt-get install bodhi-apppack
#sudo apt-get install firefox
#sudo apt-get install pidgin
#sudo apt-get install rhythmbox
#sudo apt-get install deluge
#sudo apt-get install qbittorrent
#sudo apt-get install parole
#sudo apt-get install simplescreenrecorder
#sudo apt-get install kdenlive
#sudo apt-get install pavucontrol
#sudo apt-get install ubuntu-restricted-extras ##Only necessary in version 4.0


#This will install a game or two if you like
echo "Do you wish to install a game(s)? (Y/n)"
read answer
if [[ $answer == Y ]];
then 
#sudo apt-get install supertuxkart #Newer versions are intense on resources
sudo apt-get install ace-of-penguins gnome-mines gnome-sudoku
sudo apt-get install chromium-bsu gnome-mahjongg aisleriot 
fi 

#This will install themes
echo "Themes by ravefinity.com"
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
sudo apt-get install dalisha-icons
sudo apt-get install moka-icon-theme
sudo apt-get install emerald-icon-theme
sudo apt-get install numix-icon-theme-circle
sudo apt-get install dorian-theme
sudo apt-get install delorean-dark
sudo apt-get install faenza-icon-theme
fi

#exports the chosen editor to bashrc
export EDITOR=nano

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

#This part activates the uncomplicated firewall on your system
sudo ufw enable
#Optional
#sudo ufw deny ssh

#I can prepare a simple hosts file if you like
echo "Would  you like to use a hosts file? (Y/n)"
read answer
if [[ $answer == Y ]];
then 
sudo ./hostsman4linux.sh
fi

#Optional, but it is highly recommended that you make a quick backup
#The backup directory can be found in your root folder, unless you specify #otherwise
#cd /
#sudo tar -cvpzf backup.tgz --exclude=dev --exclude=proc --exclude=sys --exclude=tmp --exclude=run --exclude=mnt --exclude=media --exclude=lost+found --exclude=backup.tgz
#Or for home folder only
#sudo tar -cvpzf backuphome.tgz /home/$USER/ 

#This installs and activates archey
sudo apt-get install scrot lsb-release
wget https://github.com/downloads/djmelik/archey/archey-0.2.8.deb
sudo dpkg -i archey-0.2.8.deb
echo "archey" | sudo tee -a /etc/bash.bashrc

#Now would be a great time to reboot
sudo shutdown -r now
