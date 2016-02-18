#! /bin/bash

import model.AppInfo='source ../model/AppInfo.sh';

# "Classe" que contêm todas as mensagens específicas para linha de comando (CLI)
#
# Author: Gustavo Moraes <gustavosotnas1@gmail.com>
#
# This file is subject to the terms and conditions of the GNU General Public
# License. See the file COPYING in the main directory of this archive
# for more details.

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

# Função que exibe mensagem de erro de que o usuário entrou com args inválidos.
# Parâmetros:
# 	$@ - args de linha de comando inválidos
displayInvalidArgs()
{
	local ARGS="`echo $@ | cut -d' ' -f2`";
	local INVALID_ARGS_TEXT="\n`model.AppInfo getCmdName`: invalid option '$ARGS'\n";
	INVALID_ARGS_TEXT="${INVALID_ARGS_TEXT}Usage: `model.AppInfo getCmdName`\n";
	INVALID_ARGS_TEXT="${INVALID_ARGS_TEXT}   or: `model.AppInfo getCmdName` [OPTION]\n";
	INVALID_ARGS_TEXT="${INVALID_ARGS_TEXT}Try '`model.AppInfo getCmdName` --help' for more information."

	echo -e "$INVALID_ARGS_TEXT";
}

#### MAIN ####

case $1 in
	"displayHelp") displayHelp;;
	"displayVersion") displayVersion;;
	"displayInvalidArgs") displayInvalidArgs "$@";;
esac;