#!bin/bash

echo "Entering chroot"
echo "Next stage started for addos"
sleep 4

#locale-gen

echo "Pick your contry these must be the same formating"
ls /usr/share/zoneinfo/
read region

echo "Pick your timene"
ls /usr/share/zoneinfo/$region
read city

ln -sf /usr/share/zoneinfo/$region/$city
sleep 2
hwclock --systohc

#local-gen
printf "What is your UTF-8 eg en_CA.UTF-8"
read UTF8

cd /etc/
sleep 3
cd /etc/
rm locale.gen
cd /root
echo "$UTF8" >> /etc/locale.gen
cat /etc/locale.gen
