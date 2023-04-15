#!/bin/bash

if [[ "$UID" != 0 ]]; then
    echo "USER NOT ROOT"
    sudo $0
    exit
else
    echo "USER IS ROOT"
fi

ESP_PATH=$(bootctl --print-esp-path)
ESP_PATH="/efi"
cmdline=$(sed -e 's/^[[:space:]]//g' -e 's/[[:space:]]$//g' /etc/kernel/cmdline)
kernel_dir="$ESP_PATH/EFI/Linux"

for i in $(ls -1 /usr/lib/modules);
do
    kver=$i
    if [ -f /usr/lib/modules/$i/pkgbase ] && [ -f /usr/lib/modules/$i/vmlinuz ]; then
        name=$(cat /usr/lib/modules/$i/pkgbase)
        echo "$name $kver"
        sleep 5
        cp -vrf /usr/lib/modules/$i/vmlinuz "$kernel_dir/vmlinuz-$name"
        sleep 5
        dracut --force --hostonly --kver "$kver" --kernel-cmdline="$cmdline" "$kernel_dir/initramfs-$name.img"
        sleep 5
        dracut --force --no-hostonly --kver "$kver" --kernel-cmdline="$cmdline" "$kernel_dir/initramfs-$name-fallback.img"
        sleep 5
        dracut --force --hostonly --kver "$kver" --kernel-cmdline="$cmdline" --uefi --uefi-stub "/usr/lib/systemd/boot/efi/linuxx64.efi.stub" "$kernel_dir/$name.efi"
        sleep 5
        dracut --force --no-hostonly --kver "$kver" --kernel-cmdline="$cmdline" --uefi --uefi-stub "/usr/lib/systemd/boot/efi/linuxx64.efi.stub" "$kernel_dir/$name-fallback.efi"
    fi
done
