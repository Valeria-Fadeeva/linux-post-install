#!/bin/bash

cd "$(dirname $0)"

if [[ "$UID" != 0 ]]; then
    echo "USER NOT ROOT"
    sudo $0
    exit
else
    echo "USER IS ROOT"
fi

pacman --needed -S mc

cd root && cp --verbose --force --remove-destination --no-dereference --preserve=links --recursive . $HOME && cd ..

