#! /bin/bash

import model.AppInfo='source ../model/AppInfo.sh';
import controller.GUIController='source ../controller/GUIController.sh'

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
	controller.GUIController verifyGUI;
	controller.SDKController verifySDKPath;
	controller.SDKController verifyAVDPath;

	chooseAVD;
	mainMenu;
}

# Função que permite ao usuário escolher o AVD que deseja executar,
# de acordo com a lista de AVDs disponível.
# Saída:
#	$CHOSEN_AVD - o nome do AVD escolhido pelo usuário.
chooseAVD()
{

}

mainMenu()
{
	
}

### MAIN ####

case $1 in
	"start") start;;
esac;