#! /bin/bash

import model.AndroidSDK='source ../model/AndroidSDK.sh';
import model.AppInfo='source ../model/AppInfo.sh';
import view.GUI='source ../view/GUI.sh';
import view.GUIDialogs='source ../view/GUIDialogs.sh';
import controller.SDKController='source ../controller/SDKController.sh';

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

# Função que define o caminho do diretório onde os AVDs estão instalados.
# É chamada APENAS na primeira vez que o programa é executado E os AVDs
# não estão na localização padrão OU foi movido de pasta.
defineAVDPath()
{
	false; # Para entrar no while
	while [ $? -ne 0 ] # Enquanto a saída do último comando não for igual a ZERO
	do
		if ! model.AVD setFolderPath "`view.GUI inputAVDPath`"
		then
			view.GUIDialogs displayInvalidFolder;
			false; # Faz o while ter +1 iteração (não pode ser return $FALSE!)
		else
			true; # Faz o while finalizar
		fi
	done
}

# Função que faz o procedimento completo de listagem de AVDs, obtenção da
# escolha do usuário pro AVD desejado e a execução do SDK Emulator (Launching).
defineUserAVDChosen()
{
	local AVDS_LIST="`controller.SDKController listInstalledAVDs`"; # Lista AVDs
	false; # Para entrar no while
	while [ $? -ne 0 ] # Enquanto a saída do último comando não for igual a ZERO
	do
		CHOSEN_AVD=$(view.GUI inputUserAVDChoice "$AVDS_LIST"); #Variável GLOBAL
		if [ "$?" != "1" ] # Se o usuário não quer sair do programa
		then
			# Executa o Android SDK Emulator com o AVD escolhido 
			# em background, "&" cria thread pra função 'runAndroidSDKEmulator'.
			controller.SDKController runAndroidSDKEmulator "$CHOSEN_AVD" & 
			true; # Sai do while
		else # $? == 1
			false; # Faz o while ter mais um loop
		fi
	done
}

# Função que cria uma janela de carregamento pulsante para dar "feedback" ao usuário de que o emulador do Android SDK está inicializando.
# Dependências:
#	$CHOSEN_AVD (variável GLOBAL) - o AVD que está sendo inicializado
defineTimeShowingLoadingAVD()
{
	local is_emulator_window_opened="false" is_loading_window_opened="false" nameAVD="${CHOSEN_AVD:0:20}"; # Flags para o while
	
	while [ "$is_loading_window_opened" != "true" ] # enquanto o vmctrl NÃO detectar a janela de carregamento do AVD Launcher
	do
		wmctrl -r "`model.AppInfo getAppName`" -b toggle,above &>/dev/null; # Deixa a janela de progresso do zenity "always-on-top" (vmctrl busca o nome da janela aberta)
		if [ "$?" == "0" ] # Se a janela procurada está aberta
		then
			is_loading_window_opened="true"; # sai do while
		else
			sleep 0.5; # não pode ser um tempo de sleep pequeno demais, pois o comando `wmctrl` consome CPU
		fi
	done

	while [ "$is_emulator_window_opened" != "true" ] # enquanto o vmctrl NÃO detectar a janela com o nome do AVD
	do
		wmctrl -l | grep "$nameAVD"; # Lista todas as janelas abertas no computador e tenta filtar a janela cujo nome é o nome do AVD escolhido
		if [ "$?" == "0" ] # Se a janela procurada está aberta
		then
			is_emulator_window_opened="true"; # sai do while para fechar a janela de progresso
		else
			sleep 0.5; # não pode ser um tempo de sleep pequeno demais, pois o comando `wmctrl | grep` consome CPU
		fi
	done

	echo 100; # Fecha o zenity (100% de progresso)
}

# Função que determina se o aplicativo deve ser finalizado a pedido do usuário.
# É executada quando o usuário abre a janela "Cancel" no aplicativo.
# Parâmetros:
# 	$1 - último EXIT CODE executado (no caso, apenas o yad no "displayCancel")
onClickCancelButton()
{
	if [ "$1" == "0" ] # Se o usuário quer terminar tudo (apertou o botão "Yes")
	then
		killall yad avd-launcher xargs; # Mata processos (gera RETURN CODE 143)
	fi
	return 0; # Sai
}

### MAIN ####

case $1 in
	"verifyGUI") verifyGUI;;
	"defineAndroidSDKPath") defineAndroidSDKPath;;
	"defineAVDPath") defineAVDPath;;
	"defineUserAVDChosen") defineUserAVDChosen;;
	"defineTimeShowingLoadingAVD") defineTimeShowingLoadingAVD;;
	"onClickCancelButton") onClickCancelButton "$2";;
esac;