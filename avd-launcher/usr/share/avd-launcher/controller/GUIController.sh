#! /bin/bash

import model.AndroidSDK='source ../model/AndroidSDK.sh';
import view.GUI='source ../view/GUI.sh';
import view.GUIDialogs='source ../view/GUIDialogs.sh';

# "Classe" que controla o comportamento da view.GUI
#
# Author: Gustavo Moraes <gustavosotnas1@gmail.com>
#
# This file is subject to the terms and conditions of the GNU General Public
# License. See the file COPYING in the main directory of this archive
# for more details.

# Função que verifica se o programa está sendo executado em interface gráfica.
# Parâmetros:
#	$DISPLAY (variável de ambiente) - O número do monitor para o X Window System
verifyGUI()
{
	if [ -n "$DISPLAY" ]
	then # Está sendo executado em interface gráfica
		return $TRUE;
	else # O script está sendo executado em interface de texto
		>&2 echo "This program needs to be run in GUI mode.";
		exit $FALSE;
	fi
}

# Função que define o caminho do diretório onde o Android SDK está instalado.
# É chamada APENAS na primeira vez que o programa é executado E o Android SDK
# não está na localização padrão OU foi movido de pasta.
defineAndroidSDKPath()
{
	false; # Para entrar no while
	while [ $? -ne 0 ] # Enquanto a saída do último comando não for igual a ZERO
	do
		if ! model.AndroidSDK setFolderPath "`view.GUI inputAndroidSDKPath`"
		then
			view.GUIDialogs displayInvalidFolder;
			false; # Faz o while ter +1 iteração (não pode ser return $FALSE!)
		else
			true; # Faz o while finalizar
		fi
	done
}

# Função que determina se o aplicativo deve ser finalizado a pedido do usuário.
# É executada quando o usuário abre a janela "Cancel" no aplicativo.
# Parâmetros:
# 	$1 - último EXIT CODE executado (no caso, apenas o yad no "displayCancel")
onClickCancelButton()
{
	if [ "$1" == "0" ] # Se o usuário quer terminar tudo (apertou o botão "Yes")
	then
		killall yad avd-launcher; # Mata processos pais (gera o RETURN CODE 143)
	fi
	return 0; # Sai
}

### MAIN ####

case $1 in
	"verifyGUI") verifyGUI;;
	"defineAndroidSDKPath") defineAndroidSDKPath;;
	"onClickCancelButton") onClickCancelButton "$2";;
esac;