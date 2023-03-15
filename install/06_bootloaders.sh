#!/bin/bash

if [[ "$UID" != 0 ]]; then
    echo "USER NOT ROOT"
    sudo $0
    exit
else
    echo "USER IS ROOT"
fi

### BOOTLOADERS

mkdir -p /efi/EFI/Linux

pacman --needed -S refind

rm -f /boot/refind_linux.conf

refind-install


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


efiid=$(cat /etc/fstab | grep efi | cut -d'=' -f2 | cut -d' ' -f1)
blkpart=$(blkid | grep $efiid)
strlen=${#blkpart}
lastelemlen=38
ind=$(echo $strlen-$lastelemlen | bc)
UUID=$(echo ${blkpart:$ind:$lastelemlen} | sed 's/"//g')
bootnum=$(efibootmgr | grep $UUID | grep "BOOTX64.EFI" | head -n 1 | cut -d'*' -f1 | sed 's/Boot//g')
if [[ -n "$bootnum" ]]; then
    efibootmgr -B -b $bootnum
else
    bootnum=$(efibootmgr | grep $UUID | grep "bootx64.efi" | head -n 1 | cut -d'*' -f1 | sed 's/Boot//g')
    if [[ -n "$bootnum" ]]; then
        efibootmgr -B -b $bootnum
    fi
fi
unset bootnum


bootnum=$(efibootmgr | grep $UUID | grep "SYSTEMD-BOOTX64.EFI" | head -n 1 | cut -d'*' -f1 | sed 's/Boot//g')
if [[ -n "$bootnum" ]]; then
    efibootmgr -B -b $bootnum
else
    bootnum=$(efibootmgr | grep $UUID | grep "systemd-bootx64.efi" | head -n 1 | cut -d'*' -f1 | sed 's/Boot//g')
    if [[ -n "$bootnum" ]]; then
        efibootmgr -B -b $bootnum
    fi
fi
unset bootnum


bootnum=$(efibootmgr | grep $UUID | grep "GRUBX64.EFI" | head -n 1 | cut -d'*' -f1 | sed 's/Boot//g')
if [[ -n "$bootnum" ]]; then
    efibootmgr -B -b $bootnum
else
    bootnum=$(efibootmgr | grep $UUID | grep "grubx64.efi" | head -n 1 | cut -d'*' -f1 | sed 's/Boot//g')
    if [[ -n "$bootnum" ]]; then
        efibootmgr -B -b $bootnum
    fi
fi
unset bootnum


cp -vrf bootloaders/memtest /efi/EFI/
cp -vf /boot/refind_linux.conf /efi/EFI/Linux/
rm -vrf /efi/EFI/refind/icons-backup

mkdir -p /efi/EFI/refind_hard
cp -vrf /efi/EFI/refind/* /efi/EFI/refind_hard
rm -f /efi/EFI/refind_hard/manual.conf

cp -vf bootloaders/easy/refind.conf /efi/EFI/refind/
cp -vf bootloaders/hard/refind.conf /efi/EFI/refind_hard/

bash bootloaders/easy/make.sh

cp -vf bootloaders/easy/manual.conf /efi/EFI/refind/

rm -f bootloaders/easy/manual.conf

bash ../../linux-boot-efi/install_all.sh

cp -vrf /efi/EFI/refind/themes /efi/EFI/refind_hard/

mkdir -p /efi/EFI/boot
cp -vrf /efi/EFI/refind/* /efi/EFI/boot
mv -vf /efi/EFI/boot/refind_x64.efi /efi/EFI/boot/bootx64.efi
