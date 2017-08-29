#!/bin/bash

#This will give useful information about your system
mkdir Sysinfo
cd /Sysinfo
df -h >> analysis.txt
free -h >> analysis.txt
ifconfig -a >> analysis.txt
sudo ps aux >> analysis.txt
sudo dmesg >> dmesg.txt
sudo dmidecode >> hardware.txt
journalctl -a >> journallog.txt 
systemd-analyze >> boot-check.txt
systemd-analyze blame >> boot-check.txt
systemctl status >> systemdiagnostics.txt
systemctl --failed >> systemdiagnostics.txt
lspci >> hardware.txt
lsusb >> hardware.txt
sudo lshw >> hardware.txt
cd
