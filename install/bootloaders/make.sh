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
bootctl install

cp -vf /boot/refind_linux.conf /efi/EFI/Linux/

cp --verbose --recursive --force --remove-destination --no-dereference --preserve=links loader.conf /efi/loader/
cp --verbose --recursive --force --remove-destination --no-dereference --preserve=links refind_entries.conf /efi/loader/entries/
cp --verbose --recursive --force --remove-destination --no-dereference --preserve=links refind.conf /efi/EFI/refind/

rm -rf /efi/EFI/refind/icons-backup

cp -vrf memtest /efi/EFI/

bash preset.sh

cd ../../../linux-boot-efi
bash install_all.sh
