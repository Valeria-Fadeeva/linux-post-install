#!/bin/bash

if [[ "$UID" != 0 ]]; then
    echo "USER NOT ROOT"
    sudo $0
    exit
else
    echo "USER IS ROOT"
fi

pacman --needed -S linux$(uname -r | sed s/"\."/""/g | cut -c1-3)-headers

pacman --needed -S mkinitcpio mkinitcpio-busybox mkinitcpio-firmware mkinitcpio-netconf mkinitcpio-nfs-utils mkinitcpio-systemd-tool

cd mkinitcpio-presets

list=$(ls -1)

for i in $list
do
    KNAME=$(echo "$i" | sed -e 's/linux-//g' | sed -e 's/.preset//g')
    KVER=$(ls /usr/lib/modules/ | grep "$KNAME" | sort -V | tail -n 1)
    if [[ -n "$KVER" ]]; then
        cp -vf "linux-$KNAME.preset" /etc/mkinitcpio.d/
        mkinitcpio -p "linux-$KNAME"
    fi

    unset KVER
done
