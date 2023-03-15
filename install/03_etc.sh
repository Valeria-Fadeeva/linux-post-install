#!/bin/bash

if [[ "$UID" != 0 ]]; then
    echo "USER NOT ROOT"
    sudo $0
    exit
else
    echo "USER IS ROOT"
fi

pacman --needed -S gnome-keyring

cp -vrf etc/pam.d/* /etc/pam.d/

#cp -vrf etc/sudoers.d/* /etc/sudoers.d/

cp -vf etc/sddm.conf /etc/
cp -vf etc/vconsole.conf /etc/

cp -vf etc/pamac.conf /etc/

chown -R sddm:sddm /var/lib/sddm/.config

systemctl enable sshd
systemctl start sshd

mkdir -p /etc/xdg/reflector/

cp -vf etc/xdg/reflector/reflector.conf /etc/xdg/reflector/

cp -vf etc/reflector-simple.conf /etc/

systemctl enable reflector
systemctl restart reflector &