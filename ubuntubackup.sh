#!/bin/bash
sudo apt-get autoremove && sudo apt-get autoclean && sudo apt-get clean
sudo rm -r .cache/*
sudo rm  -r .thumbnails/*
sudo rm -r ~/.local/share/Trash
history -c
cd / 
sudo rsync -aAXv --exclude=dev --exclude=proc --exclude=Backup --exclude=Music --exclude=sys --exclude=tmp --exclude=run --exclude=mnt --exclude=media --exclude=lost+found / /Backup

