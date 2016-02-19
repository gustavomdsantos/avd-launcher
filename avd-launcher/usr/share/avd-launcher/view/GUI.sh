#! /bin/bash

import model.AppInfo='source ../model/AppInfo.sh';
import view.GUIDialogs='source ../view/GUIDialogs.sh';
import controller.GUIController='source ../controller/GUIController.sh';
import controller.SDKController='source ../controller/SDKController.sh';

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
	loadingAVD;

	mainMenu;
}

# Função que permite ao usuário escolher o AVD que deseja executar,
# de acordo com a lista de AVDs disponível.
# Saída:
#	$CHOSEN_AVD - o nome do AVD escolhido pelo usuário.
chooseAVD()
{
	controller.GUIController defineUserAVDChosen;
}

# Função que dá ao usuário um feedback do carregamento do AVD pelo SDK Emulator.
loadingAVD()
{
	controller.GUIController defineTimeShowingLoadingAVD | zenity --progress --title "`model.AppInfo getAppName`" \
	--pulsate --no-cancel --window-icon="android" \
	--text "Initializing Android SDK Emulator with the \"$CHOSEN_AVD\" AVD..." --auto-close; # Não foi usado o "yad" aqui porque ele tem bugs na barra de progresso no modo "pulsate"
}

# Exibe uma janela de menu com opções para manipulação do AVD.
# O menu é composto de ícones de funções tais como:
# "Instalar APK", "Desinstalar APK", "Upload" e "download" de arquivos do AVD,
# "Instalar aplicativos Google" e "Enviar comandos adb para o AVD".
mainMenu()
{
	return 0;
}

# Cria janela de apresentação e pede para o usuário colocar onde está
# localizada a pasta do Android SDK (apenas na primeira vez que o programa 
# é executado e o SDK não está na localização padrão ou foi movido de pasta).
# Retorna:
#	$sdk_path_tmp2 - suposta localização do Android SDK escolhida pelo usuário
inputAndroidSDKPath()
{
	yad --title "`model.AppInfo getAppName`" --form \
		--center --width=500 --image="android" --window-icon="android" \
		--text "`model.AppInfo getAppAbout`\n\n<b>AVD Launcher could not get the default Android SDK folder path.</b>\n" \
		--field 'Android SDK Path (this is needed only once)\:':DIR $HOME --separator="" --borders=5 \
		--button=About:"./GUIDialogs.sh displayAbout" --button=Cancel:"./GUIDialogs.sh displayCancel" --button=OK:0
}

# Cria janela de alerta e pede para o usuário colocar onde está localizada
# a pasta dos AVDs (apenas na primeira vez que o programa 
# é executado e os AVDs não estão na localização padrão ou foi movido de pasta).
# Retorna:
#	$AVDPath - suposta localização dos AVDs escolhida pelo usuário
inputAVDPath()
{
	yad --title "`model.AppInfo getAppName`" --form \
		--center --width=500 --image="help" --window-icon="android" \
		--text "<b>AVD Folder not found</b>\n\nCould not find the Android Virtual Devices (AVDs) folder. Normally, the AVDs are located in the <tt>~/.android/avd/</tt> folder." \
		--field 'Android AVDs Path\:':DIR $HOME --separator="" --borders=5 \
		--button=Cancel:"./GUIDialogs.sh displayCancel" --button=OK:0
}

# Cria uma janela pedindo para o usuário escolher o AVD desejado
# dentre os que estiverem na lista de AVDs.
# Parâmetros:
#	$2 - a lista de AVDs localizados para escolha (no formato "zenity/yad")
# Retorna:
#	$CHOSEN_AVD - o nome do AVD que o usuário escolheu
inputUserAVDChoice()
{
	echo "$2" | xargs \
	yad --title "`model.AppInfo getAppName`" --list \
		--center --width=350 --height=200 --image="android" --window-icon="android" \
		--text "Choose below one of the Android Virtual Devices (AVDs) to run:" \
		--radiolist --separator="" --column "Pick" --column "AVD" --print-column=2 --borders=5 \
		--button=About:"./GUIDialogs.sh displayAbout" \
		--button=Cancel:"./GUIDialogs.sh displayCancel" \
		--button=Launch:0;
}

### MAIN ####

case $1 in
	"start") start;;
	"inputAndroidSDKPath") inputAndroidSDKPath;;
	"inputAVDPath") inputAVDPath;;
	"inputUserAVDChoice") inputUserAVDChoice "$@";;
esac;