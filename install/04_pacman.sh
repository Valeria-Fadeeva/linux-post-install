#!/bin/bash

if [[ "$UID" != 0 ]]; then
    echo "USER NOT ROOT"
    sudo $0
    exit
else
    echo "USER IS ROOT"
fi

# EndeavourOS Linux

sudo pacman-key --recv-keys 003DB8B0CB23504F
sudo pacman-key --lsign-key 003DB8B0CB23504F

pacman -U repo/endeavouros/*.zst

ch=$(grep /etc/pacman.conf -e "\[endeavouros\]")
if [[ -z "$ch" ]]; then
    echo -e "[endeavouros]\nSigLevel = PackageRequired\nInclude = /etc/pacman.d/endeavouros-mirrorlist\n\n" >> /etc/pacman.conf;
fi
unset ch

# ARCO Linux

#Erik key
sudo pacman-key --recv-keys 74F5DE85A506BF64
sudo pacman-key --lsign-key 74F5DE85A506BF64

#Marco key
sudo pacman-key --recv-keys F1ABB772CE9F7FC0
sudo pacman-key --lsign-key F1ABB772CE9F7FC0

#John key
sudo pacman-key --recv-keys 4B1B49F7186D8731
sudo pacman-key --lsign-key 4B1B49F7186D8731

#Stephen key
sudo pacman-key --recv-keys 02D507C6EFB8CEAA
sudo pacman-key --lsign-key 02D507C6EFB8CEAA

#Brad Heffernan
sudo pacman-key --recv-keys 18064BF445855549
sudo pacman-key --lsign-key 18064BF445855549

#Raniel Laguna
sudo pacman-key --recv-keys 7EC1A5550718AB89
sudo pacman-key --lsign-key 7EC1A5550718AB89

pacman -U repo/arcolinux/*.zst

ch=$(grep /etc/pacman.conf -e "\[arcolinux_repo\]")
if [[ -z "$ch" ]]; then
    echo -e "[arcolinux_repo]\nSigLevel = Required DatabaseOptional\nInclude = /etc/pacman.d/arcolinux-mirrorlist\n\n" >> /etc/pacman.conf;
fi
unset ch

ch=$(grep /etc/pacman.conf -e "\[arcolinux_repo_xlarge\]")
if [[ -z "$ch" ]]; then
    echo -e "[arcolinux_repo_xlarge]\nSigLevel = Required DatabaseOptional\nInclude = /etc/pacman.d/arcolinux-mirrorlist\n\n" >> /etc/pacman.conf;
fi
unset ch

ch=$(grep /etc/pacman.conf -e "\[arcolinux_repo_3party\]")
if [[ -z "$ch" ]]; then
    echo -e "[arcolinux_repo_3party]\nSigLevel = Required DatabaseOptional\nInclude = /etc/pacman.d/arcolinux-mirrorlist\n\n" >> /etc/pacman.conf;
fi
unset ch

# Garuda Linux

pacman-key --recv-key FBA220DFC880C036 --keyserver keyserver.ubuntu.com
pacman-key --lsign-key FBA220DFC880C036

pacman -U repo/chaotic/*.zst

pacman --needed -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'

ch=$(grep /etc/pacman.conf -e "\[garuda\]")
if [[ -z "$ch" ]]; then
    echo -e "[garuda]\nInclude = /etc/pacman.d/chaotic-mirrorlist\n\n" >> /etc/pacman.conf;
fi
unset ch

ch=$(grep /etc/pacman.conf -e "\[chaotic-aur\]")
if [[ -z "$ch" ]]; then
    echo -e "[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist\n\n" >> /etc/pacman.conf;
fi
unset ch

# Cachyos Linux

pacman-key --recv-keys F3B607488DB35A47 --keyserver keyserver.ubuntu.com
pacman-key --lsign-key F3B607488DB35A47

pacman -U repo/cachyos/*.zst

#pacman -U 'https://mirror.cachyos.org/repo/x86_64/cachyos/cachyos-keyring-2-1-any.pkg.tar.zst' 'https://mirror.cachyos.org/repo/x86_64/cachyos/cachyos-mirrorlist-17-1-any.pkg.tar.zst' 'https://mirror.cachyos.org/repo/x86_64/cachyos/cachyos-v3-mirrorlist-17-1-any.pkg.tar.zst' 'https://mirror.cachyos.org/repo/x86_64/cachyos/cachyos-v4-mirrorlist-5-1-any.pkg.tar.zst'
#'https://mirror.cachyos.org/repo/x86_64/cachyos/pacman-6.0.2-10-x86_64.pkg.tar.zst'

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

ch=$(grep /etc/pacman.conf -e "\[cachyos\]")
if [[ -z "$ch" ]]; then
    echo -e "[cachyos]\nInclude = /etc/pacman.d/cachyos-mirrorlist\n\n" >> /etc/pacman.conf;
fi
unset ch

pacman -Sy
pacman -S mc --needed
pacman -S terminus-font --needed
pacman -S yay --needed
pacman -S kdeplasma-addons --needed

#user=$(cat /etc/passwd | grep 1000 | cut -d: -f1)
user=$(who | head -n 1 | cut -d' ' -f1)

su - $user -c "yay -S --quiet --needed --noconfirm pamac-all"
pamac checkupdates>/dev/null
