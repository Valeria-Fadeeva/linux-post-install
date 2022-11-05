#!/bin/bash

cd "$(dirname $0)"

cp --verbose --recursive --force --remove-destination --no-dereference --preserve=links ./root/.config/mc $HOME/.config/

