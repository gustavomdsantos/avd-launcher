#! /bin/bash

# "Classe" que contêm informações sobre os AVDs (Android Virtual Devices)
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
	local CONFIG_FILE_AVDS="$HOME/.config/avd-launcher/AVDs_path.conf";
	
	case $1 in
		"getFolderPath") getFolderPath;;
		"setDefaultFolderPath") setDefaultFolderPath;;
		"setFolderPath") setFolderPath "$2";;
	esac;
}

# Obtêm o caminho dos AVDs para uso no AVD Launcher.
# Retorna:
# 	$FOLDERPATH - o caminho dos AVDs
# 	$? - 
# 		TRUE quando o caminho dos AVDs está devidamente setado num .conf
# 		FALSE quando o arquivo de configuração do AVD Launcher pro AVDs ñ existe
getFolderPath()
{
	if [ ! -f "$CONFIG_FILE_AVDS" ]
	then
		return $FALSE;
	else
		local FOLDERPATH=$(cat "$CONFIG_FILE_AVDS");
		return_str "$FOLDERPATH";
		return $TRUE;
	fi
}

# Função que seta a localização padrão dos AVDs no Linux, de acordo com
# o instalador do Android Studio para Linux: <http://bit.ly/1nZZpry>
setDefaultFolderPath()
{
	local DEFAULT_AVDS_FOLDER_PATH="$HOME/.android/avd";

	setFolderPath "$DEFAULT_AVDS_FOLDER_PATH";
}

# Função que verifica se o caminho dos AVDs dado é válido
# e seta tal caminho num arquivo de configuração.
# O "if" com "find" e "grep" abaixo é solução baseada nas respostas de fórum:
# 	http://stackoverflow.com/a/3925376 - "find" sem recursão
# 	http://serverfault.com/a/225827 - "grep" retorna 1 se "find" stdout = null
# Parâmetros:
#	$1 - Caminho do diretório que supostamente contém os AVDs
# Saídas:
# 	$? - 
# 		TRUE quando o caminho dos AVDs está devidamente setado num .conf
# 		FALSE quando o arquivo de configuração do AVD Launcher pro AVDs ñ existe
#	"$CONFIG_FILE_AVDS" - arquivo de configuração contendo o path do AVDs válido
setFolderPath()
{
	# Se pasta existe e existe algum .ini (redireciona stdout -> "Buraco Negro")
	if find "$1" -maxdepth 1 -type f -name "*.ini" | grep '.*' >/dev/null
	then # É a pasta dos AVDs
		mkdir `dirname "$CONFIG_FILE_AVDS"` 2> /dev/null; # Cria pasta de config
		echo "$1" > "$CONFIG_FILE_AVDS"; # Seta para o arquivo de configuração
		return $TRUE;
	else # Não é uma pasta válida, GUIController exibe dialogo "invalid folder"
		return $FALSE;
	fi
}

### MAIN com variáveis de classe (fields) ####

case $1 in
	*) fields "$@";;
esac;