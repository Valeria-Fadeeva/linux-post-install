#!/bin/bash

if [[ "$UID" != 0 ]]; then
    echo "USER NOT ROOT"
    sudo $0
    exit
else
    echo "USER IS ROOT"
fi

bash bootloaders/easy/make.sh

cp -vf bootloaders/easy/manual.conf /efi/EFI/refind/
cp -vf bootloaders/easy/manual.conf /efi/EFI/boot/

rm -f bootloaders/easy/manual.conf
