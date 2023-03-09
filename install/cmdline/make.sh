#!/bin/bash

if [[ "$UID" != 0 ]]; then
    echo "USER NOT ROOT"
    sudo $0
    exit
else
    echo "USER IS ROOT"
fi

mkdir -p /efi/EFI/Linux

### CMDLINE

echo -e "/boot/cmdline.txt\n"
cat /boot/cmdline.txt

echo -e "\n"

echo -e "/proc/cmdline\n"
cat /proc/cmdline

echo -e "\n"

for i in $(cat /proc/cmdline);
do r=$(echo $i | grep "root=" | head -n 1);
    if [[ -n "$r" ]]; then
        cmdline_rootuuid=$(echo $r | sed s/"root="//g | sed s/"\""//g);
        break;
    fi;
done

fstab_rootuuid=$(cat /etc/fstab | grep "/ " | cut -d" " -f1)

blkid_rootuuid=$(blkid | grep root | cut -d" " -f2 | head -n 1 | sed -r 's/\"//g')

if [[ -n "$blkid_rootuuid" ]] || [[ -n "$fstab_rootuuid" ]] || [[ -n "$cmdline_rootuuid" ]]; then
    if [[ "$fstab_rootuuid" == "$cmdline_rootuuid" ]]; then
        ROOTUUID=$fstab_rootuuid
    elif [[ "$fstab_rootuuid" == "$blkid_rootuuid" ]]; then
        ROOTUUID=$fstab_rootuuid
    elif [[ "$cmdline_rootuuid" == "$blkid_rootuuid" ]]; then
        ROOTUUID=$cmdline_rootuuid
    fi
fi

if [[ -z "$ROOTUUID" ]]; then
    echo -e "ROOT UUID NOT FOUND\n"
    exit
else
    echo -e "blkid: $blkid_rootuuid" | column -t
    echo -e "fstab: $fstab_rootuuid" | column -t
    echo -e "cmdline: $cmdline_rootuuid" | column -t

    echo -e "found: $ROOTUUID" | column -t
fi

echo "$ROOTUUID" > cmd-uuid.txt

UUID="root=$(cat cmd-uuid.txt) rw rootflags=subvol=@"
SPLASH=$(cat cmd-splash.txt)

# VCard=$(lsmod | grep nvidia | head -n 1 | cut -d_ -f1)
# if [[ "$VCard" == "nvidia" ]]; then
#     VIDEO=$(cat cmd-video-nvidia.txt)
# else
#     VIDEO=$(cat cmd-video.txt)
# fi

VIDEO=$(cat cmd-video.txt)

END=$(cat cmd-end.txt)

echo "$UUID $SPLASH $VIDEO $END" > cmdline.txt
sed -i "s/  / /g" cmdline.txt
sed -i "s/\n//g" cmdline.txt

cp -vf cmdline.txt /boot/
cp -vf cmdline.txt /efi/EFI/Linux/
cp -vf cmdline.txt /etc/kernel/cmdline

echo -e "/boot/cmdline.txt\n"
cat /boot/cmdline.txt
