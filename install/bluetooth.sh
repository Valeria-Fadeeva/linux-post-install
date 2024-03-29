#!/bin/bash

if [[ "$UID" != 0 ]]; then
    echo "USER NOT ROOT"
    sudo $0
    exit
else
    echo "USER IS ROOT"
fi

pacman -S --needed bluez bluez-utils bluedevil

systemctl enable bluetooth
systemctl start bluetooth
