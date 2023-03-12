#!/bin/bash

if [[ "$UID" != 0 ]]; then
    echo "USER NOT ROOT"
    sudo $0
    exit
else
    echo "USER IS ROOT"
fi


cmdline=$(sed -e 's/^[[:space:]]//g' -e 's/[[:space:]]$//g' /etc/kernel/cmdline)
kernel_dir="/efi/EFI/Linux"

for i in $(ls -1 /usr/lib/modules);
do
    kver=$i
    if [ -f /usr/lib/modules/$i/pkgbase ]; then
        name=$(cat /usr/lib/modules/$i/pkgbase)
        filename="$name.efi"
        echo "$kver $name $filename"
        dracut --force --no-hostonly --kernel-cmdline="$cmdline" --uefi --kver "$kver" --uefi-stub "/usr/lib/systemd/boot/efi/linuxx64.efi.stub" "$kernel_dir/$filename"
    fi
done
