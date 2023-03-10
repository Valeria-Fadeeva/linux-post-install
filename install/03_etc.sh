#!/bin/bash

if [[ "$UID" != 0 ]]; then
    echo "USER NOT ROOT"
    sudo $0
    exit
else
    echo "USER IS ROOT"
fi

cd ./etc

pacman --needed -S gnome-keyring

cp -vrf pam.d/* /etc/pam.d/

#cp -vrf sudoers.d/* /etc/sudoers.d/

cp -vf /etc/mkinitcpio.conf /etc/mkinitcpio.conf.bak
cp -vf mkinitcpio.conf /etc/
cp -vf sddm.conf /etc/
cp -vf vconsole.conf /etc/

cp -vf pamac.conf /etc/

chown -R sddm:sddm /var/lib/sddm/.config

systemctl enable sshd
systemctl start sshd

mkdir -p /etc/xdg/reflector/

cp -vf xdg/reflector/reflector.conf /etc/xdg/reflector/

cp -vf reflector-simple.conf /etc/

systemctl enable reflector
systemctl restart reflector &