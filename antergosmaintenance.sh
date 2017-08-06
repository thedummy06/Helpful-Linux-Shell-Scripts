#!/bin/bash

#This refreshes systemd in case of new or failed units
sudo systemctl daemon-reload

#This will give useful information about your system
df -h >> analysis.txt
free -h >> analysis.txt
sudo dmesg >> dmesg.txt
journalctl -a >> journallog.txt 
systemd-analyze >> boot-check.txt
systemd-analyze blame >> boot-check.txt
systemctl status && systemctl --failed >> systemddiagnostic.txt
hostnamectl >> hostname.log
sudo ps aux >> analysis.txt

#This will reload the firewall to ensure it's enabled
sudo ufw reload 

#This will clean the cache
sudo rm -r .cache/*
sudo rm -r .thumbnails/* 
sudo rm -r ~/.local/share/Trash
history -c

#This helps get rid of old archived log entries
sudo journalctl --vacuum-size=25M

#This will remove orphan packages from pacman 
sudo pacman -Rs --noconfirm $(pacman -Qqdt)

#Optional This will remove the pamac cached applications and older versions
sudo pacman -Sc --noconfirm

#This will ensure you are up to date and running fastest mirrors 
sudo reflector -l 50 -f 20 --save /tmp/mirrorlist.new && rankmirrors -n 0 /tmp/mirrorlist.new > /tmp/mirrorlist && sudo cp /tmp/mirrorlist /etc/pacman.d
sudo rankmirrors -n 0 /etc/pacman.d/antergos-mirrorlist > /tmp/antergos-mirrorlist && sudo cp /tmp/antergos-mirrorlist /etc/pacman.d
sudo pacman -Syuw --noconfirm

#This refreshes index cache
sudo updatedb && sudo mandb 

#update the grub 
sudo grub-mkconfig -o /boot/grub/grub.cfg 

#This runs a disk checkup and attempts to fix filesystem
sudo touch /forcefsck 

#Sometimes it's good to check for and remove broken symlinks
find -xtype l -delete

#This will make a backup of your system
echo "Would you like to make a backup? (Y/n)"
read answer
if [[ $answer == Y ]];
then 
  sudo rsync -aAXv --exclude=dev --exclude=proc --exclude=Backup --exclude=Music --exclude=sys --exclude=tmp --exclude=run --exclude=mnt --exclude=media --exclude=lost+found / /Backup
else 
  echo "It is a good idea to create a backup after such changes, maybe later."
fi

#This will reboot the system
sudo systemctl reboot
