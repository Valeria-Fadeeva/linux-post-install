#!/bin/bash

cd ../..

git clone https://github.com/Valeria-Fadeeva/linux-boot-efi.git
if [[ "$?" != 0 ]]; then
    if [[ -d "linux-boot-efi" ]]; then
        cd linux-boot-efi
        git pull
        bash install_all.sh
    fi
else
    cd linux-boot-efi
    bash install_all.sh
fi




