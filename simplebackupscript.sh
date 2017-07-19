#!/bin/bash
sudo mv Wallpapers /tmp 
sudo rm -r .cache/*
sudo rm  -r .thumbnails/*
sudo rm -r ~/.local/share/Trash
#sudo pacman -Sc
history -c
cd / 
sudo rsync -aAXv --exclude=dev --exclude=proc --exclude=Backup --exclude=sys --exclude=tmp --exclude=run --exclude=mnt --exclude=media --exclude=lost+found / /Backup
cd tmp 
sudo mv Wallpapers /home/$USER/
