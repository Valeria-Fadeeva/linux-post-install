#!/bin/bash

if [[ "$UID" != 0 ]]; then
    echo "USER NOT ROOT"
    sudo $0
    exit
else
    echo "USER IS ROOT"
fi

mkdir -p /efi/EFI/Linux

### BOOTLOADERS

pacman --needed -S refind

rm -f /boot/refind_linux.conf

refind-install

bootnum=$(efibootmgr | grep "\\\EFI\\\BOOT\\\BOOTX64.EFI" | cut -d'*' -f1 | sed 's/Boot//g')
if [[ -n "$bootnum" ]]; then
    efibootmgr -B -b $bootnum
else
    bootnum=$(efibootmgr | grep "\\\EFI\\\boot\\\bootx64.EFI" | cut -d'*' -f1 | sed 's/Boot//g')
    if [[ -n "$bootnum" ]]; then
        efibootmgr -B -b $bootnum
    fi
fi
unset bootnum


bootnum=$(efibootmgr | grep "\\\EFI\\\SYSTEMD\\\SYSTEMD-BOOTX64.EFI" | cut -d'*' -f1 | sed 's/Boot//g')
if [[ -n "$bootnum" ]]; then
    bootctl remove
else
    bootnum=$(efibootmgr | grep "\\\EFI\\\systemd\\\systemd-bootx64.efi" | cut -d'*' -f1 | sed 's/Boot//g')
    if [[ -n "$bootnum" ]]; then
        bootctl remove
    fi
fi
unset bootnum


bootnum=$(efibootmgr | grep "\\\EFI\\\REFIND\\\REFIND_X64.EFI" | cut -d'*' -f1 | sed 's/Boot//g')
if [[ -n "$bootnum" ]]; then
    efibootmgr -n $bootnum
else
    bootnum=$(efibootmgr | grep "\\\EFI\\\refind\\\refind_x64.efi" | cut -d'*' -f1 | sed 's/Boot//g')
    if [[ -n "$bootnum" ]]; then
        efibootmgr -n $bootnum
    fi
fi

unset bootnum


cp -vf /boot/refind_linux.conf /efi/EFI/Linux/


cp --verbose --recursive --force --remove-destination --no-dereference --preserve=links refind.conf /efi/EFI/refind/

rm -rf /efi/EFI/refind/icons-backup

cp -vrf memtest /efi/EFI/

#bootctl install
#cp --verbose --recursive --force --remove-destination --no-dereference --preserve=links loader.conf /efi/loader/
#cp --verbose --recursive --force --remove-destination --no-dereference --preserve=links refind_entries.conf /efi/loader/entries/

bash preset.sh

cd ../../../linux-boot-efi
bash install_all.sh
