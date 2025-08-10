#!/bin/bash
echo "virt manager install and setup"
sleep 5
clear
#install virt manager and related pkgs
echo "gemu and virt manager install"
sleep 4
sudo pacman -S qemu virt-manager virt-viewer dnsmasq vde2 bridge-utils openbsd-netcat
clear
#add ufw rules
echo "ufw rule change"
sleep 4
sudo ufw disable
sudo ufw allow in on virbr0 from any to any
sudo ufw allow out on virbr0 from any to any
sudo ufw reload
sudo ufw enable
clear
#change system rules
echo "changeing system rules"
sleep 4
sudo systemctl enable libvirtd --now
sudo usermod -a -G libvirt,libvirt-qemu,kvm $USER
clear
#exit mesage
echo "this script has fineshed other scripts may run after this one"
sleep 4
