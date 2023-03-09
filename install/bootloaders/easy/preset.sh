#!/bin/bash

if [[ "$UID" != 0 ]]; then
    echo "USER NOT ROOT"
    sudo $0
    exit
else
    echo "USER IS ROOT"
fi

CMDLINE=$(cat ../cmdline/cmdline.txt | sed "s/\n//g")

if [[ -z "$CMDLINE" ]]; then
    echo -e "CMDLINE NOT FOUND\n"
    exit
else
    echo -e "found: $CMDLINE" | column -t
fi

cat easy/manual.conf.preset | sed "s/{CMDLINE}/$CMDLINE/g" > easy/manual.conf

cp -vf easy/manual.conf /efi/EFI/refind/
