#!/bin/bash

if [[ "$UID" != 0 ]]; then
    echo "USER NOT ROOT"
    sudo $0
    exit
else
    echo "USER IS ROOT"
fi

pacman -Rns micro

pamac install linux-xanmod linux-xanmod-headers

pamac install linux-cachyos-pds linux-cachyos-pds-headers linux-cachyos-pds-zfs

pamac install linux-cachyos-tt linux-cachyos-tt-headers linux-cachyos-tt-zfs
