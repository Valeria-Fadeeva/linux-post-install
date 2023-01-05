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
    cp -vf linux-xanmod.preset /etc/mkinitcpio.d/
    mkinitcpio -p linux-xanmod
fi

unset kver

kver=$(ls /usr/lib/modules/ | grep "cachyos-pds" | sort -V | tail -n 1)
if [[ -n "$kver" ]]; then
    cp -vf linux-cachyos-pds.preset /etc/mkinitcpio.d/
    mkinitcpio -p linux-cachyos-pds
fi

#cd /boot/efi/EFI/Linux
#cp -u $(ls) /boot/

update-grub
