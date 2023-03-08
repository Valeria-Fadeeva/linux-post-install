#!/bin/bash

cd "$(dirname $0)"

mkdir -p $HOME/.config/
cd root && cp --verbose --force --remove-destination --no-dereference --preserve=links --recursive . $HOME && cd ..

cd user && cp --verbose --force --remove-destination --no-dereference --preserve=links --recursive . $HOME && cd ..
