#!/bin/bash

#This will ensure you do not have any common network issues
for c in computer; 
do ping -c4 google.com > /dev/null
if [ $? -eq 0 ]
then 
	echo "Connection successful!"
else
sudo mmcli nm enable false 
sudo nmcli nm enable true
sudo service network-manager restart
sudo ifconfig eth0 up
sudo dhclient eth0
fi
done

#This will update your system
sudo apt-get update 
sudo apt-get upgrade #Helps ensure  you get all the updates in linux mint.
sudo apt-get -y dist-upgrade 

#This will install your main apps for you 
sudo apt-get -y install thunderbird transmission vlc  
sudo apt-get -y install preload gnome-disk-utility xfburn 
sudo apt-get -y install file-roller gparted
sudo apt-get -y install psensor hardinfo lm-sensors 
sudo apt-get -y install hexchat bleachbit gedit bum
sudo apt-get -y install apparmor-profiles apparmor-utils nmap
sudo apt-get -y install traceroute gdebi chromium-browser   
sudo apt-get -y install synaptic software-properties-common inxi
sudo apt-get -y install ncdu gufw libreoffice
sudo apt-get -y install iotop htop handbrake
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

#This tries to install codecs
echo "This will install codecs." 
echo "These depend upon your environment."

echo "1 - ubuntu-restricted-extras"
echo "2 - xubuntu-restricted-extras"
echo "3 - lubuntu-restricted-extras"
echo "4 - kubuntu-restricted-extras"
echo "5 - if unsure hit this for now"

read operation;

case $operation in 
		1) sudo apt-get install ubuntu-restricted-extras ;;
		2) sudo apt-get install xubuntu-restricted-extras ;;
		3) sudo apt-get install lubuntu-restricted-extras ;;
		4) sudo apt-get install kubuntu-restricted-extras ;;
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
echo "Themes by ravefinity.com"
echo "Would you like a dark theme?"
read answer 
if [[ $answer == Y ]]; 
then
sudo apt-add-repository ppa:numix/ppa
sudo add-apt-repository ppa:noobslab/icons
sudo add-apt-repository ppa:moka/stable
sudo add-apt-repository ppa:noobslab/themes
sudo add-apt-repository ppa:noobslab/themes
sudo apt-get update
sudo apt-get install mate-themes gtk2-engines-xfce gtk3-engines-xfce
sudo apt-get install dorian-theme
sudo apt-get install numix-icon-theme-circle
sudo apt-get install delorean-dark
sudo apt-get install emerald-icon-theme
sudo apt-get install dalisha-icons
sudo apt-get install moka-icon-theme
sudo apt-get install faenza-icon-theme
fi

#This will optionally install pale moon browser
echo "Would you like to install a light weight browser? (Y/n)"
read answer
if [[ $answer == Y ]]:
then 
wget http://linux.palemoon.org/files/pminstaller/0.2.2/pminstaller-0.2.2.tar.bz2
sudo tar -xvjf pminstaller-0.2.2.tar.bz2
./pminstaller.sh
fi

#This sets your default editor in bashrc
export EDITOR=nano

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
echo "net.ipv4.tcp_challenge_ack_limit = 999999999" | sudo tee -a /etc/sysctl.conf #This is for older kernels but it's safest
sudo sysctl -p

#This activates the firewall
sudo ufw enable
#Optional but could be more secure
#sudo ufw deny ssh

#Hosts file to thwart adverts
echo "Would  you like to use a hosts file? (Y/n)"
read answer
if [[ $answer == Y ]];
then 
sudo ./hostsman4linux.sh
fi

#This installs and activates archey
sudo apt-get install scrot lsb-release
wget https://github.com/downloads/djmelik/archey/archey-0.2.8.deb
sudo dpkg -i archey-0.2.8.deb
echo "archey" | sudo tee -a /etc/bash.bashrc

#Optional, but it is highly recommended that you make a quick backup
#The backup directory can be found in your root folder, unless you specify #otherwise 
#cd /
#sudo mkdir backups
#sudo rsync -aAXv --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found"","/backups/*} / /backups
#Or for home folder only
#sudo rsync -aAXv /home/USER/ /backups

#Let's reboot
sudo shutdown -r now
