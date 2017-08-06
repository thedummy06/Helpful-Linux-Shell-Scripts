# Beginner-linux-scripts
These are scripts for beginners to linux, to help setup their systems.
You might have to type sudo chmod +x to make them executable on your system.
When you are ready to use one of these scripts just call it in the terminal or commandline as
./scriptname.sh as for the hosts file updater, right now the simplest way to get it to work is to run it as
sudo ./hostsman4linux.sh and the same goes for the manjaro version. 
The main difference between the two is the use of systemd as an init meaning that it loads everything on your system.
Debian is not included specifically(yet), but many of the ubuntu commands will still work, it's just that some services require the use of /etc/init.d which is like running systemctl which is commonly used, but different. 
Many distros are going towards systemd now, so soon everything will be universal.
I've included a simple set of instructions should you need them. Manjaro scripts can be tweaked and used within antergos, or other arch based systems. I had trouble with the theming and the way my graphics card handled manjaro on one machine, so I used antergos and most of the problems went away. Turns out qt4 does have some nasty side effects on chromium though. If you want everything to run smoothly I'd suggest a different browser right now if you have certain, shitty nvidia graphics cards.
         

