#!/bin/bash

if [[ "$UID" != 0 ]]; then
    echo "USER NOT ROOT"
    sudo $0
    exit
else
    echo "USER IS ROOT"
fi

pacman -Syu

pacman -S --needed --overwrite="*" $(cat pkgs.amd.txt)
#pacman -S --needed --overwrite="*" $(cat pkgs.nvidia.txt)
pacman -S --needed --overwrite="*" $(cat pkgs.base_desktop.txt)
pacman -S --needed --overwrite="*" $(cat pkgs.note.txt)

systemctl enable pacman-auto-update

pacman -S --needed --overwrite="*" $(cat pkgs.go.txt)
pacman -S --needed --overwrite="*" $(cat pkgs.python.txt)
pacman -S --needed --overwrite="*" $(cat pkgs.rust.txt)
pacman -S --needed --overwrite="*" $(cat pkgs.kotlin.txt)
pacman -S --needed --overwrite="*" $(cat pkgs.js.txt)
pacman -S --needed --overwrite="*" $(cat pkgs.php.txt)
pacman -S --needed --overwrite="*" $(cat pkgs.virt.txt)
pacman -S --needed --overwrite="*" $(cat pkgs.db.txt)
