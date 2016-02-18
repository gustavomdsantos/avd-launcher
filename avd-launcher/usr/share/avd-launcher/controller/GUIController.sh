#! /bin/bash

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

### MAIN ####

case $1 in
	"verifyGUI") verifyGUI;;
esac;