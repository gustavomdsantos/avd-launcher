#! /bin/bash

# Author: Gustavo Moraes <gustavosotnas1@gmail.com>
#
# This file is subject to the terms and conditions of the GNU General Public
# License. See the file COPYING in the main directory of this archive
# for more details.

yad --center --icons --window-icon="android" \
--item-width="150" --single-click --read-dir="./desktopfiles/" \
--width="340" --height="430" \
--title="Android Virtual Device Manager" \
--name="Android Virtual Device Manager" \
--button=About:"./avd-launcher-helper.sh about" \
--button="Close:1"; # Deve ser executado na pasta (...)'/usr/share/avd-launcher/'