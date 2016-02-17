#! /bin/bash

# Author: Gustavo Moraes <gustavosotnas1@gmail.com>
#
# This file is subject to the terms and conditions of the GNU General Public
# License. See the file COPYING in the main directory of this archive
# for more details.

# "Classe" que contêm todas as mensagens específicas para linha de comando (CLI)

# Função que exibe um texto de ajuda sobre o aplicativo no Terminal (CLI):
# Uma pequena descrição do funcionamento do aplicativo, bug report, a licença do aplicativo e seu autor.
# Parâmetros:
# 	$CMD_NAME (via 'get_message') - o nome comando para executar o aplicativo
# 	$VERSION (via 'get_message')  a versão do aplicativo
# 	$APP_AUTHOR (via 'get_message')  o texto de direitos de autor
# 	$CONTACT_AUTHOR (via 'get_message')  URL de contato do autor
# 	$APP_HOMEPAGE (via 'get_message')  URL para o código fonte do aplicativo na Internet
# 	$APP_ABOUT_FMT (via 'get_message')  texto de descrição do aplicativo (formatado para CLI)
#	$ADVICE_DESCRIPTION_TEXT (via 'get_message')  texto de aviso a respeito do AVD Manager, ferramenta que faz parte do Android SDK
displayHelp()
{
	echo -e "\nUsage: `get_message CMD_NAME`";
	echo -e "   or: `get_message CMD_NAME` [OPTION]\n";

	get_message APP_ABOUT_FMT;
	get_message ADVICE_DESCRIPTION_TEXT;

	echo -e "\nOptions:";
	echo -e "  -h, --help			Display this help and exit";
	echo -e "      --version			Shows version information and exit\n";

	echo "Report `get_message CMD_NAME` bugs to <`get_message APP_HOMEPAGE`>";
	echo "Released under the GNU General Public License."
	echo "`get_message APP_AUTHOR` <`get_message CONTACT_AUTHOR`>";
}

# Função que exibe a versão do aplicativo na linha de comando - Terminal
# Parâmetros:
# 	$VERSION (variável GLOBAL) - a versão do aplicativo
displayVersion()
{
	echo "$(get_message VERSION)";
}

#### MAIN ####

case $1 in
	"displayHelp") displayHelp;;
	"displayVersion") displayVersion;;
esac;