#!/bin/bash

cd "$(dirname $0)"

cp --verbose --recursive --force --remove-destination --no-dereference --preserve=links ./root/.config/mc $HOME/.config/
cp --verbose --force --remove-destination --no-dereference --preserve=links ./user/.local/share/kxmlgui5/dolphin/dolphinui.rc $HOME/.local/share/kxmlgui5/dolphin/

