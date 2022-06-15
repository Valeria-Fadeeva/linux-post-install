#!/bin/bash

if [[ "$UID" != 0 ]]; then
    echo "USER NOT ROOT"
    sudo $0
    exit
else
    echo "USER IS ROOT"
fi

D=$(date +%Y.%m.%d-%H-%M-%S)

if [[ -d ../lera ]]; then
    mv /home/lera "/home/lera-$D"
    chown -R 1000:1000 "/home/lera-$D"

    echo -e "RSYNC"
    echo -e "Смена прав в каталоге /disk/system/system/lera\n"
    sudo chown -R lera:lera ../lera

    echo -e "Синхронизация ../lera/ /home/lera\n"
    rsync --verbose -aSH --stats --human-readable --ignore-errors --force ../lera/ /home/lera

    echo -e "Удаление .cache в локальном каталоге /home/lera\n"
    sudo rm -rf /home/lera/.cache

elif [[ -f ../lera.tbz ]]; then
    mv /home/lera "/home/lera-$D"
    chown -R 1000:1000 "/home/lera-$D"

    echo -e "UNTAR"
    tar -xjf ../lera.tbz -C /home/

fi

chown -R 1000:1000 "/home/lera"

echo -e "\n"
read -rsn1 -p"Press any key to exit";echo
