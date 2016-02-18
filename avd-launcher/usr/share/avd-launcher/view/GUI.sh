#! /bin/bash

import model.AppInfo='source ../model/AppInfo.sh';

# "Classe" que contém o código das janelas das principais funcionalidades 
#
# Author: Gustavo Moraes <gustavosotnas1@gmail.com>
#
# This file is subject to the terms and conditions of the GNU General Public
# License. See the file COPYING in the main directory of this archive
# for more details.

# Função principal do programa, implenta os passos das atividades de execução
# (algoritmo) tal qual no Diagrama de Atividade do AVD Launcher.
start()
{
	echo "Começou o `model.AppInfo getAppName`.";
}

### MAIN ####

case $1 in
	"start") start;;
esac;