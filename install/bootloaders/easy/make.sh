#!/bin/bash

pwd=$(dirname $0)

KERNEL_DIR="/efi/EFI/Linux"
CMDLINE=$(cat "$KERNEL_DIR/cmdline.txt" | sed "s/^[[:space:]]*//g" | sed "s/[[:space:]]*$//g")

# if [[ -z "$CMDLINE" ]]; then
#     echo -e "CMDLINE NOT FOUND\n"
#     exit
# else
#     echo "found: $CMDLINE" | column -t
# fi

manual_conf=$pwd'/manual.conf'

echo -n > $manual_conf

template_vmlinuz=$pwd'/preset/menuentry-vmlinuz.txt'

for i in $(ls -1 $KERNEL_DIR | grep 'linu' | grep '^vm');
do
    kernel=$i
    kernel_name=$(echo $kernel | sed "s/vmlinuz-//g")
    initramfs_tpl=$(echo "initramfs-$kernel" | sed "s/vmlinuz-//g")
    initramfs=$(echo "$initramfs_tpl.img")
    initramfs_fallback=$(echo "$initramfs_tpl-fallback.img")

    sed -e "s/{KERNEL_NAME}/$kernel_name/g" -e "s/{KERNEL}/$kernel/g" -e "s/{INITRAMFS}/$initramfs/g" -e "s/{INITRAMFS_FALLBACK}/$initramfs_fallback/g" -e "s/{CMDLINE}/$CMDLINE/g" $template_vmlinuz >> $manual_conf
done


template_efi=$pwd"/preset/menuentry-efi.txt"

for i in $(ls -1 /efi/EFI/Linux/ | grep 'linu' | grep -v 'fallback' | grep '\.efi$');
do
    kernel=$(echo $i | sed 's/\.efi//g')
    kernel_name=$kernel
    osname=$(lsinitrd "$KERNEL_DIR/$kernel.efi" 2>&1 | grep 'OS Release' | cut -d':' -f2 | sed 's/^[[:space:]]*//g' | cut -d' ' -f1)
    icon=$(lsinitrd "$KERNEL_DIR/$kernel.efi" 2>&1 | grep 'OS Release' | cut -d':' -f2 | sed 's/^[[:space:]]*//g' | cut -d' ' -f2 | sed 's/[\(\)]//g')

    sed -e "s/{OSNAME}/$osname/g" -e "s/{ICON}/$icon/g" -e "s/{KERNEL_NAME}/$kernel_name/g" -e "s/{KERNEL}/$kernel/g" $template_efi >> $manual_conf
done



template_end=$pwd'/preset/menu-end.txt'
cat $template_end >> $manual_conf

default='default_selection "lts"'

echo $default >> $manual_conf
