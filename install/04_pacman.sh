#!/bin/bash

if [[ "$UID" != 0 ]]; then
    echo "USER NOT ROOT"
    sudo $0
    exit
else
    echo "USER IS ROOT"
fi


pacman-key --recv-key FBA220DFC880C036 --keyserver keyserver.ubuntu.com
pacman-key --lsign-key FBA220DFC880C036
pacman --needed -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'

ch=$(grep /etc/pacman.conf -e "chaotic-aur")
if [[ -z "$ch" ]]; then
    echo -e "[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist\n" >> /etc/pacman.conf;
fi

unset ch


pacman-key --recv-keys F3B607488DB35A47 --keyserver keyserver.ubuntu.com
pacman-key --lsign-key F3B607488DB35A47
pacman -U 'https://mirror.cachyos.org/repo/x86_64/cachyos/cachyos-keyring-2-1-any.pkg.tar.zst' 'https://mirror.cachyos.org/repo/x86_64/cachyos/cachyos-mirrorlist-14-1-any.pkg.tar.zst' 'https://mirror.cachyos.org/repo/x86_64/cachyos/cachyos-v3-mirrorlist-14-1-any.pkg.tar.zst' 'https://mirror.cachyos.org/repo/x86_64/cachyos/cachyos-v4-mirrorlist-2-1-any.pkg.tar.zst' 'https://mirror.cachyos.org/repo/x86_64/cachyos/pacman-6.0.2-10-x86_64.pkg.tar.zst'

#Check support by the following the command
#/lib/ld-linux-x86-64.so.2 --help
# cachyos repos
## Only add if your CPU does support x86-64-v4 architecture
#[cachyos-v4]
#Include = /etc/pacman.d/cachyos-v4-mirrorlist
## Only add if your CPU does v3 architecture
#[cachyos-v3]
#Include = /etc/pacman.d/cachyos-v3-mirrorlist
#[cachyos]
#Include = /etc/pacman.d/cachyos-mirrorlist

ch=$(grep /etc/pacman.conf -e "cachyos")
if [[ -z "$ch" ]]; then
    echo -e "[cachyos]\nInclude = Include = /etc/pacman.d/cachyos-mirrorlist\n" >> /etc/pacman.conf;
fi

pacman -Sy
pacman -S --needed pamac-aur
pamac checkupdates>/dev/null
