#! /bin/bash
shopt -s expand_aliases && alias import='alias'; # Permite usar "import" em .sh

import model.AppInfo='source ../model/AppInfo.sh';

# Author: Gustavo Moraes <gustavosotnas1@gmail.com>
#
# This file is subject to the terms and conditions of the GNU General Public
# License. See the file COPYING in the main directory of this archive
# for more details.

# "Classe" que contêm todas as mensagens específicas para linha de comando (CLI)

# Função que exibe um texto de ajuda sobre o aplicativo no Terminal (CLI):
# Uma pequena descrição do funcionamento do aplicativo, bug report, 
# a licença do aplicativo e seu autor.
displayHelp()
{
	echo -e "\nUsage: `model.AppInfo getCmdName`";
	echo -e "   or: `model.AppInfo getCmdName` [OPTION]\n";

	echo -e "`model.AppInfo getAppAbout`" | fmt -t;
	echo -e "`model.AppInfo getAppAdvice`";

	echo -e "\nOptions:";
	echo -e "  -h, --help			Display this help and exit";
	echo -e "      --version			Shows version information and exit\n";

	echo "Report `model.AppInfo getCmdName` bugs to <`model.AppInfo getAppHomepage`>";
	echo "Released under the GNU General Public License."
	echo "`model.AppInfo getAppAuthor` <`model.AppInfo getAuthorContact`>";
}

# Função que exibe a versão do aplicativo no Terminal (CLI).
displayVersion()
{
	echo "$(model.AppInfo getVersion)";
}

#### MAIN ####

case $1 in
	"displayHelp") displayHelp;;
	"displayVersion") displayVersion;;
esac;