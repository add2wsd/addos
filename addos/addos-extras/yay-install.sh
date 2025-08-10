#!/bin/bash
#yay explenation
echo "yay is a aur handaler and works like pacman but for the aur its recomended to take a moment to understand and use it safly (if you understand yay please continue)"

#normal yay install
echo "yay installing"
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si

