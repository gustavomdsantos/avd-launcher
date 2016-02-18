#! /bin/bash

import model.AppInfo='source ../model/AppInfo.sh';

# "Classe" que contém o código das janelas de diálogo do AVD Launcher. 
#
# Author: Gustavo Moraes <gustavosotnas1@gmail.com>
#
# This file is subject to the terms and conditions of the GNU General Public
# License. See the file COPYING in the main directory of this archive
# for more details.

# Função que exibe uma janela informando que o caminho do diretório é inválido.
displayInvalidFolder()
{
	yad --title "`model.AppInfo getAppName`" --error \
	--center --width=350 --image="error" --window-icon="android" \
	--text "<big><b>Invalid folder, try again.</b></big>" --text-align=center \
	--button="OK:0";
}

### MAIN ####

case $1 in
	"displayInvalidFolder") displayInvalidFolder;;
esac;