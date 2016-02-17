#! /bin/bash
shopt -s expand_aliases && alias import='alias' return_str='echo -n -e'; # import em .sh

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
	local HELP_TEXT="\n";

	# Concatenando Strings
	HELP_TEXT="${HELP_TEXT}Usage: `model.AppInfo getCmdName`\n";
	HELP_TEXT="${HELP_TEXT}   or: `model.AppInfo getCmdName` [OPTION]\n\n";

	HELP_TEXT="${HELP_TEXT}`model.AppInfo getAppAbout | fmt -t`\n";
	HELP_TEXT="${HELP_TEXT}`model.AppInfo getAppAdvice`\n\n";

	HELP_TEXT="${HELP_TEXT}Options:\n";
	HELP_TEXT="${HELP_TEXT}  -h, --help			Display this help and exit\n";
	HELP_TEXT="${HELP_TEXT}      --version			Shows version information and exit\n\n";

	HELP_TEXT="${HELP_TEXT}Report `model.AppInfo getCmdName` bugs to <`model.AppInfo getAppHomepage`>\n";
	HELP_TEXT="${HELP_TEXT}Released under the GNU General Public License.\n";
	HELP_TEXT="${HELP_TEXT}`model.AppInfo getAppAuthor` <`model.AppInfo getAuthorContact`>";

	echo -e "$HELP_TEXT";
}

# Função que exibe a versão do aplicativo no Terminal (CLI).
displayVersion()
{
	echo "`model.AppInfo getVersion`";
}

#### MAIN ####

case $1 in
	"displayHelp") displayHelp;;
	"displayVersion") displayVersion;;
esac;