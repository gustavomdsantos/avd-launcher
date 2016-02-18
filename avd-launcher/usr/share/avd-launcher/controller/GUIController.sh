#! /bin/bash

import view.GUI='source ../view/GUI.sh';

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
	# false; # Para entrar no while
	# while [ $? -ne 0 ] # Enquanto a saída do último comando não for igual a ZERO (return =! 0)
	# do
		view.GUI inputAndroidSDKPath;
	# done
}

### MAIN ####

case $1 in
	"verifyGUI") verifyGUI;;
	"defineAndroidSDKPath") defineAndroidSDKPath;;
esac;