#!/bin/bash

if [[ "$UID" != 0 ]]; then
    echo "USER NOT ROOT"
    sudo $0
    exit
else
    echo "USER IS ROOT"
fi

pacman -Rns micro

pamac install linux-xanmod-edge linux-xanmod-edge-headers
