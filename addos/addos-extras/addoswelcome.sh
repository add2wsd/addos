#!/bin/bash
echo "welcome to addos"
echo "if you want later configs updtae scripts will be availible in releases"
read -n 1 -s -r -p "Press any key to continue..."

#pickup DE and mod
if [ -f /phase4/gnome.txt ];
then
	echo "gnome install"
else
	echo "gnome not configering"
fi

if [ -f /phase4/hypr.txt ];
then
	clear
	user=$(dialog --inputbox --output-fd 1 "username:" 10 40)
	echo "hypr configs"
	cd /home/"$user"/.config
	rm -r hypr
	cd /hyprland-config-files
	cp -r /hypr /home/"$user"/.config/hyprs
	cd #waybar dir
	rm -r #waybar config
	cd /hyprland-config-files
	cp -r /waybar #waybar dir
	cd
else
	echo "hypr not configering"
fi

if [ -f /phase4/gnome.txt ];
then
	clear
	user=$(dialog --inputbox --output-fd 1 "username:" 10 40)
	echo "gnome config"
else
	echo "hypr not configering"
fi


