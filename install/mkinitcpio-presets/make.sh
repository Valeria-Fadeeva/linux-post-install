#!/bin/bash

if [[ "$UID" != 0 ]]; then
    echo "USER NOT ROOT"
    sudo $0
    exit
else
    echo "USER IS ROOT"
fi

kver=$(ls /usr/lib/modules/ | grep "xanmod" | sort -V | tail -n 1)
if [[ -n "$kver" ]]; then
    cp -vf linux-xanmod-me.preset /etc/mkinitcpio.d/
    mkinitcpio -p linux-xanmod-me
fi

unset kver

kver=$(ls /usr/lib/modules/ | grep "cachyos-pds" | sort -V | tail -n 1)
if [[ -n "$kver" ]]; then
    cp -vf linux-cachyos-me.preset /etc/mkinitcpio.d/
    mkinitcpio -p linux-cachyos-me
fi

#cd /boot/efi/EFI/Linux
#cp -u $(ls) /boot/

update-grub
