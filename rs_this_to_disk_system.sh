#!/bin/bash

rsync -verbose -aSH --stats --human-readable --delete --delete-after --ignore-errors --force ./ /disk/system/

echo -e "\n"
read -rsn1 -p"Press any key to exit";echo
