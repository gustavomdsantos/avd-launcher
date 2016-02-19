#! /bin/bash

import model.AndroidSDK='source ../model/AndroidSDK.sh';
import model.AVD='source ../model/AVD.sh';
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

# Verifica se a pasta onde estão os AVDs (Android Virtual Device) está definida.
verifyAVDPath()
{
	if ! model.AVD getFolderPath >/dev/null # Se não se sabe onde está os AVDs
	then
		if model.AVD setDefaultFolderPath
		then
			return $TRUE; # Os AVDs estão na localização default no Linux
		else # Os AVDs não estão na localização default
			controller.GUIController defineAVDPath; #Usuário define a pasta AVDs
		fi
	else # A localização dos AVDs já foi setada anteriormente
		return $TRUE;
	fi
}

# Cria um array do nome dos AVDs para o usuário escolher, 
# sendo o primeiro AVD listado a opção marcada por "default" na lista.
# Retorna:
#	$AVDS_LIST - string com o "esqueleto" da lista dos AVDs localizados 
# 				 para execução no formato de checklist do "zenity/YAD", exemplo: 
# 	"TRUE Android_Wear_Round_API_20 FALSE Nexus_6_API_21 FALSE Nexus_S_API_19"
listInstalledAVDs()
{
	shopt -s nullglob;
	local installed_AVDs=("`model.AVD getFolderPath`"/*.ini); # Se tiver nome de arquivo com "espaço", vai dar problema!
	shopt -u nullglob; # Turn off to it doesn't interfere with anything later
	#echo "${installed_AVDs[@]}"; # Aspas para evitar nomes de arquivo quebrados

	local AVDS_LIST; # Var que terá o resultado do array para string do YAD
	for f in "${installed_AVDs[@]}"
	do
		if [ "$f" == "${installed_AVDs[0]}" ]
		then
			AVDS_LIST="${AVDS_LIST}TRUE "; # Palavra-chave do "yad" para marcar na lista (um "radio button")
		else
			AVDS_LIST="${AVDS_LIST}FALSE "; # Palavra-chave do "yad" para NÃO marcar na lista
		fi
		AVDS_LIST="${AVDS_LIST}`basename "$f" .ini` "; # Imprime o nome do arquivo sem a extensão dele (sufixo)
	done
	return_str "$AVDS_LIST";
}

# Chamada o emulador do Android SDK para executar o AVD desejado pelo usuário.
# Esta função é sempre executada em BACKGROUND pelo 'defineUserAVDChosen'.
# Parâmetros:
#	$1 - o nome do Android Virtual Device (AVD) escolhido pelo usuário
runAndroidSDKEmulator()
{
	echo -e "\n[Thread] Aqui será executado o AVD: $1";
}

### MAIN ####

case $1 in
	"verifySDKPath") verifySDKPath;;
	"verifyAVDPath") verifyAVDPath;;
	"listInstalledAVDs") listInstalledAVDs;;
	"runAndroidSDKEmulator") runAndroidSDKEmulator "$2";;
esac;