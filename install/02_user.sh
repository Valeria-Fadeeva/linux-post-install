#!/bin/bash

cd "$(dirname $0)"

mkdir -p $HOME/.config/
cp --verbose --recursive --force --remove-destination --no-dereference --preserve=links ./root/.config/mc $HOME/.config/

mkdir -p $HOME/.local/share/kxmlgui5/dolphin/
cp --verbose --force --remove-destination --no-dereference --preserve=links ./user/.local/share/kxmlgui5/dolphin/dolphinui.rc $HOME/.local/share/kxmlgui5/dolphin/
