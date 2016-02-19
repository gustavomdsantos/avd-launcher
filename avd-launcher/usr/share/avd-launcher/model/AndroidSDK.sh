#! /bin/bash

# "Classe" que contêm informações sobre o Android SDK.
#
# Author: Gustavo Moraes <gustavosotnas1@gmail.com>
#
# This file is subject to the terms and conditions of the GNU General Public
# License. See the file COPYING in the main directory of this archive
# for more details.

# Seta variáveis de "classe" privadas, inacessível para outros .sh
# Parâmetros:
# 	$1 - nome da função da "classe" pública (get / set) a ser executada
fields()
{
	local CONFIG_FILE_SDK="$HOME/.config/avd-launcher/androidSDK_path.conf";
	
	case $1 in
		"getFolderPath") getFolderPath;;
		"setDefaultFolderPath") setDefaultFolderPath;;
		"setFolderPath") setFolderPath "$2";;
	esac;
}

# Obtêm o caminho do Android SDK para uso no AVD Launcher.
# Retorna:
# 	$FOLDERPATH - o caminho do Android SDK
# 	$? - 
# 		TRUE quando o caminho do Android SDK está devidamente setado num .conf
# 		FALSE quando o arquivo de configuração do AVD Launcher pro SDK ñ existe
getFolderPath()
{
	if [ ! -f "$CONFIG_FILE_SDK" ]
	then
		return $FALSE;
	else
		local FOLDERPATH=$(cat "$CONFIG_FILE_SDK");
		return_str "$FOLDERPATH";
		return $TRUE;
	fi
}

# Função que seta a localização padrão do Android SDK no Linux, de acordo com
# o instalador do Android Studio para Linux: <http://bit.ly/1nZZpry>
setDefaultFolderPath()
{
	local DEFAULT_SDK_FOLDER_PATH="$HOME/Android/Sdk";

	setFolderPath "$DEFAULT_SDK_FOLDER_PATH";
}

# Função que verifica se o caminho do Android SDK dado é válido
# e seta tal caminho num arquivo de configuração.
# Parâmetros:
#	$1 - Caminho do diretório que supostamente contém o Android SDK
# Saídas:
# 	$? - 
# 		TRUE quando o caminho do Android SDK está devidamente setado num .conf
# 		FALSE quando o arquivo de configuração do AVD Launcher pro SDK ñ existe
#	"$CONFIG_FILE_SDK" - arquivo de configuração contendo o path do SDK válido
setFolderPath()
{
	# Verificação da existência das pastas do SDK e dos programas "adb,emulator"
	if ls -U -1 --color=never "$1" 2> /dev/null | grep \
	-e 'add-ons' \
	-e 'build-tools' \
	-e 'extras' \
	-e 'platforms' \
	-e 'platform-tools' \
	-e 'sources' \
	-e 'system-images' \
	-e 'tools' > /dev/null && find \
	"$1/platform-tools/adb" "$1/tools/emulator" > /dev/null
	then # A pasta é do Android SDK
		mkdir `dirname "$CONFIG_FILE_SDK"`; # Cria pasta de arquivos de config
		echo "$1" > "$CONFIG_FILE_SDK"; # Seta para o arquivo de configuração
		return $TRUE;
	else # Não é uma pasta válida, GUIController exibe dialogo "invalid folder"
		return $FALSE;
	fi
}

### MAIN com variáveis de classe (fields) ####

case $1 in
	*) fields "$@";;
esac;