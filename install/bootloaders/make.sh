#!/bin/bash

if [[ "$UID" != 0 ]]; then
    echo "USER NOT ROOT"
    sudo $0
    exit
else
    echo "USER IS ROOT"
fi

mkdir -p /boot/efi/EFI/Linux

### BOOTLOADERS

pacman --needed -S refind

rm -f /boot/refind_linux.conf

refind-install
bootctl install

cp -vf /boot/refind_linux.conf /boot/efi/EFI/Linux/

cp --verbose --recursive --force --remove-destination --no-dereference --preserve=links loader.conf /boot/efi/loader/
cp --verbose --recursive --force --remove-destination --no-dereference --preserve=links refind_entries.conf /boot/efi/loader/entries/
cp --verbose --recursive --force --remove-destination --no-dereference --preserve=links refind.conf /boot/efi/EFI/refind/

rm -rf /boot/efi/EFI/refind/icons-backup

cp -vrf memtest /boot/efi/EFI/

bash preset.sh

cd ../../linux-boot-efi
bash install_all.sh
