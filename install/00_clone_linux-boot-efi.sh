#!/bin/bash

cd ../..

git clone https://github.com/Valeria-Fadeeva/linux-boot-efi.git
if [[ "$?" != 0 ]]; then
    if [[ -d "linux-boot-efi" ]]; then
        echo $(pwd)
        cd linux-boot-efi
        echo $(pwd)
        git reset --hard HEAD
        git pull
        bash ./install_all.sh
    fi
else
    echo $(pwd)
    cd linux-boot-efi
    echo $(pwd)
    bash ./install_all.sh
fi
