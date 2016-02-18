#! /bin/bash

import model.AndroidSDK='source ../model/AndroidSDK.sh';
import controller.GUIController='source ../controller/GUIController.sh'

# "Classe" que controla ações com o Android SDK no AVD Launcher.
#
# Author: Gustavo Moraes <gustavosotnas1@gmail.com>
#
# This file is subject to the terms and conditions of the GNU General Public
# License. See the file COPYING in the main directory of this archive
# for more details.

# Verifica se a pasta onde está localizada o Android SDK está definida.
verifySDKPath()
{
	if ! model.AndroidSDK getFolderPath >/dev/null # Se não sabe onde está o SDK
	then
		if model.AndroidSDK setDefaultFolderPath
		then
			return $TRUE; # O Android SDK está na localização default no Linux
		else # O SDK não está na localização default
			controller.GUIController defineAndroidSDKPath; #Usuário define o SDK
		fi
	else # A localização do SDK já foi setada anteriormente
		return $TRUE;
	fi
}

verifyAVDPath()
{
	return 0;
}

### MAIN ####

case $1 in
	"verifySDKPath") verifySDKPath;;
	"verifyAVDPath") verifyAVDPath;;
esac;