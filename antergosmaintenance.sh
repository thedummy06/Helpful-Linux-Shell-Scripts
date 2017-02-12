#!/bin/bash

#This will try to ensure you have a strong network connection
for c in computer;
do 
sudo ping -c4 google.com 
if [ $? -eq 0 ]
then 
	echo "Connection successful"
else
sudo systemctl stop NetworkManager.service
sudo systemctl disable NetworkManager.service
sudo systemctl enable NetworkManager.service
sudo systemctl start NetworkManager.service
sudo ifconfig up $interfacename
sudo dhclient -r $interfacename && sudo dhclient $interfacename
fi
done

#This will give useful system information for troubleshooting certain issues
mkdir troubleshooting
cd troubleshooting
df -h >> analysis.txt
free -h >> analysis.txt
uname -a >> analysis.txt
sudo blkid >> analysis.txt
lsblk >> analysis.txt
lsb_release -a >> analysis.txt
sudo ps aux >> analysis.txt
ifconfig >> analysis.txt
Xorg -version >> analysis.txt
ldd --version >> analysis.txt
dmesg >> dmesg.txt
journalctl -a >> journald.txt #These are logs of important system events
systemd-analyze >> boottimercheck.txt #Guages length of time during boot
systemd-analyze blame >> boottimercheck.txt #Shows service loading times
sudo lshw >> hardware.txt
sudo lspci >> lspci.txt
sudo lsusb >> lsusb.txt
cat /proc/cpuinfo >> cpuinfo.txt
#sudo hdparm -tT /drive/name >> diskspeed.txt #Measures disk speed
cd

#This will reload the firewall to ensure it's enabled
sudo systemctl disable ufw
sudo systemctl enable ufw 
sudo ufw enable

#This will clean the cache
sudo rm -r .cache/*
sudo rm -r .thumbnails/*
sudo rm -r ~/.local/share/Trash

#This helps get rid of old archived log entries
sudo journalctl --vacuum-size=50M

#This will remove orphan packages from pacman 
sudo pacman -Rs $(pacman -Qqdt)

#Optional This will remove the pamac cached applications and older versions
echo "You rarely should ever do this"
echo "Do you want to remove the package cache from pamac? (Y/n)"
read answer 
if [[ $answer == Y ]];
then 
sudo pacman -Sc
fi

#This will ensure you are up to date and running fastest mirrors 
sudo rankmirrors -n /etc/pacman.d/antergos-mirrorlist
sudo pacman-optimize && sync
sudo pacman -Syyu

#Incase of new grub in antergos
sudo grub-mkconfig -o /boot/grub/grub.cfg

#This will set up screenfetch
sudo pacman -S screenfetch
sudo cp /etc/bash.bashrc /etc/bash.bashrc.bak
echo "screenfetch" | sudo tee -a /etc/bash.bashrc

#This updates the hosts file:Optional
#sudo ./hostsman4linux.sh

#This will help with configuration file mismatches
sudo etc-update

#This runs a disk checkup and attempts to fix filesystem
sudo touch /forcefsck 

#You can run bleachbit
echo "You may wish to run bleachbit for other trash and unneeded locales"
echo "Run bleachbit? (Y/n)"
read answer 
if [[ $answer == Y ]]; 
then bleachbit
fi

#This refreshes systemd in case of new or failed units
sudo systemctl daemon-reload

#This aids in diagnosing systemd specific issues
systemctl status >> systemddiagnostics.txt
systemctl >> systemddiagnostics.txt
systemctl --failed >> systemddiagnostics.txt

#Sometimes it's good to check for and remove broken symlinks
find -xtype l -delete

#This will reboot the system
sudo systemctl reboot
