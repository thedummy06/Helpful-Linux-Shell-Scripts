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
sudo ifconfig up eth0
sudo dhclient eth0
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
tail /var/log/dmesg >> dmesg.txt
tail /var/log/syslog >> syslog.txt
journalctl -a >> journald.txt #These are logs of important system events
systemd-analyze >> boottimercheck.txt #Guages length of time during boot
systemd-analyze blame >> boottimercheck.txt #Shows service loading times
sudo lshw >> hardware.txt
sudo lspci >> lspci.txt
sudo lsusb >> lsusb.txt
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
sudo journalctl --vacuum-size=100M

#This will remove orphan packages from pacman 
#sudo pacman -Rs $(pacman -Qqdt)

#Optional This will remove the pamac cached applications and older versions
echo "You rarely should ever do this"
echo "Do you want to remove the package cache from pamac? (Y/n)"
read answer 
if [[ $answer == Y ]];
then 
sudo pacman -Sc
fi

#This will ensure you are up to date and running fastest mirrors 
sudo pacman-mirrors -g
sudo pacman-optimize && sync
sudo pacman -Syyu

#This will set up screenfetch
sudo pacman -S screenfetch
sudo cp /etc/bash.bashrc /etc/bash.bashrc.bak
echo "screenfetch" | sudo tee -a /etc/bash.bashrc

#This updates the hosts file:Optional
#sudo ./hostsman4linux.sh

#Probably totally unnecessary, but I found if you remove a kernel the image still shows in bootloader.
sudo update-grub

#This tries to create a preset of your kernel(s) for faster access of the needed modules.
sudo mkinitcpio -p linux* #better to do it here after all the updates.

#This will help with configuration file mismatches
sudo etc-update

#This adds screen fetch to the new bash.bashrc file
echo "screenfetch" | sudo tee -a /etc/bash.bashrc #Sometimes updating and running etc-update could change this so...

#This runs a disk checkup and attempts to fix filesystem
sudo touch /forcefsck #Only really useful if you're sure of filesystem corruption, but doesn't hurt once a month or so.

#You can run bleachbit
echo "You may wish to run bleachbit for other trash and unneeded locales"
echo "Run bleachbit? (Y/n)"
read answer 
if [[ $answer == Y ]]; 
then bleachbit
fi

#This refreshes systemd in case of new or failed units
sudo systemctl daemon-reload #If you're loading new units or having trouble with systemd, this might help.

#This aids in diagnosing systemd specific issues
systemctl status >> systemdstat.txt
systemctl >> systemddiagnostics.txt
systemctl --failed >> systemdfailed.txt

#Sometimes it's good to check for and remove broken symlinks
find -xtype l -delete

#This will reboot the system
sudo systemctl reboot
