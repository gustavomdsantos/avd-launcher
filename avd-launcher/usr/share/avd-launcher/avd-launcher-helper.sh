#! /bin/bash

# Author: Gustavo Moraes <gustavosotnas@gmail.com>
#
# This file is subject to the terms and conditions of the GNU General Public
# License. See the file COPYING in the main directory of this archive
# for more details.

# Parâmetros OBRIGATÓRIOS que o 'quick-deb-builder.sh' passa:
#	$1=$OPTION - Opções informativas do programa (--version, --help, -h)

# RETURN CODES personalizados do AVD Launcher:
# 	50 = "Yes" para fechar
#	100 = "No" para fechar

APP_NAME="Android Virtual Device Launcher"
CMD_NAME="avd-launcher"
VERSION="1.0"
APP_AUTHOR="Copyright (C) 2015 Gustavo Moraes"
CONTACT_AUTHOR="http://about.me/gustavosotnas"
APP_HOMEPAGE="https://github.com/gustavosotnas/avd-launcher"
HELP_DESCRIPTION_TEXT_LINE1="$APP_NAME is a simple tool that allows you to run AVDs in" 
HELP_DESCRIPTION_TEXT_LINE2="the Android SDK emulator without opening Android Studio or using"
HELP_DESCRIPTION_TEXT_LINE3="command-line interface (terminal). just selecting the AVD from the list of"
HELP_DESCRIPTION_TEXT_LINE4="found AVDs and clicking on \"Launch\" button."
ADVICE_DESCRIPTION_TEXT="This tool doesn't download or manage AVDs, for that, use \"AVD Manager\"."

# Função que exibe uma janela em interface gráfica informando a versão do aplicativo e uma pequena descrição 
# do funcionamento do aplicativo e seu autor.
# Parâmetros:
# 	$APP_NAME (variável GLOBAL) - o nome do aplicativo
# 	$VERSION (variável GLOBAL) - a versão do aplicativo
# 	$HELP_DESCRIPTION_TEXT_LINE1 (variável GLOBAL) - a 1ª parte do texto de descrição do aplicativo
# 	$HELP_DESCRIPTION_TEXT_LINE2 (variável GLOBAL) - a 2ª parte do texto de descrição do aplicativo
# 	$HELP_DESCRIPTION_TEXT_LINE3 (variável GLOBAL) - a 3ª parte do texto de descrição do aplicativo
# 	$HELP_DESCRIPTION_TEXT_LINE4 (variável GLOBAL) - a 4ª parte do texto de descrição do aplicativo
#	$ADVICE_DESCRIPTION_TEXT (variável GLOBAL) - texto de aviso a respeito do AVD Manager, ferramenta que faz parte do Android SDK
# 	$APP_AUTHOR (variável GLOBAL) - o texto de direitos de autor
# 	$CONTACT_AUTHOR (variável GLOBAL) - URL de contato do autor
displayAboutDialog_GUI()
{
	yad --title "About $APP_NAME" --info \
	--center --width=500 --image="android" --window-icon="android" --icon-name="android" \
	--text "<b>$APP_NAME</b>\n\n$VERSION\n\
	\n`echo $HELP_DESCRIPTION_TEXT_LINE1 $HELP_DESCRIPTION_TEXT_LINE2 $HELP_DESCRIPTION_TEXT_LINE3 $HELP_DESCRIPTION_TEXT_LINE4`\n\
	\n<b>$ADVICE_DESCRIPTION_TEXT</b>\n\n$APP_AUTHOR <b>$CONTACT_AUTHOR</b>" \
	--text-align=center --borders=5 --button=Close:0;
}

# Função que exibe um texto de ajuda sobre o aplicativo no Terminal (CLI):
# Uma pequena descrição do funcionamento do aplicativo, bug report, a licença do aplicativo e seu autor.
# Parâmetros:
# 	$CMD_NAME (variável GLOBAL) - o nome comando para executar o aplicativo
# 	$HELP_DESCRIPTION_TEXT_LINE1 (variável GLOBAL) - a 1ª parte do texto de descrição do aplicativo
# 	$HELP_DESCRIPTION_TEXT_LINE2 (variável GLOBAL) - a 2ª parte do texto de descrição do aplicativo
# 	$HELP_DESCRIPTION_TEXT_LINE3 (variável GLOBAL) - a 3ª parte do texto de descrição do aplicativo
# 	$HELP_DESCRIPTION_TEXT_LINE4 (variável GLOBAL) - a 4ª parte do texto de descrição do aplicativo
#	$ADVICE_DESCRIPTION_TEXT (variável GLOBAL) - texto de aviso a respeito do AVD Manager, ferramenta que faz parte do Android SDK
# 	$APP_AUTHOR (variável GLOBAL) - o texto de direitos de autor
# 	$APP_HOMEPAGE (variável GLOBAL) - URL para o código fonte do aplicativo na Internet
# 	$CONTACT_AUTHOR (variável GLOBAL) - URL de contato do autor
displayHelp_CLI()
{
	echo; # Imprime apenas um '\n'
	echo -n "Usage"; echo -n ":"; echo " $CMD_NAME";
	echo -n "   or"; echo -n ":"; echo -n " $CMD_NAME ["; echo -n "OPTION"; echo "]";
	echo;
	echo "$HELP_DESCRIPTION_TEXT_LINE1";
	echo "$HELP_DESCRIPTION_TEXT_LINE2";
	echo "$HELP_DESCRIPTION_TEXT_LINE3";
	echo "$HELP_DESCRIPTION_TEXT_LINE4";
	echo "$ADVICE_DESCRIPTION_TEXT";
	echo;
	echo -n "Options"; echo ":";
	echo -n "  -h, --help			"; echo "Display this help and exit";
	echo -n "      --version			"; echo "Shows version information and exit";
	echo;
	echo "Report $CMD_NAME bugs to <$APP_HOMEPAGE>";
	echo "Released under the GNU General Public License."
	echo "$APP_AUTHOR <$CONTACT_AUTHOR>";
}

# Função que exibe a versão do aplicativo na linha de comando - Terminal
# Parâmetros:
# 	$VERSION (variável GLOBAL) - a versão do aplicativo
displayVersion_CLI()
{
	echo "$VERSION";
}

# Função que exibe uma janela em interface gráfica perguntando ao usuário se ele quer finalizar o aplicativo.
# Parâmetros:
# 	$APP_NAME (variável GLOBAL) - o nome do aplicativo
displayCancelDialog()
{
	yad --title "$APP_NAME" --info \
	--center --width=350 --image="help" --window-icon="android" --icon-name="android" \
	--text "<b>Are you sure you want to exit from $APP_NAME?</b>" --text-align=center --button=No:1 --button=Yes:0;
}

# Função que determina se o aplicativo deverá ser finalizado a pedido do usuário.
# É executada quando o usuário aperta o botão "Cancel" na janela principal do aplicativo.
# Parâmetros:
# 	$? - EXIT CODE do último comando executado (no caso, apenas "displayCancelDialog")
verify_term_all()
{
	if [ "$?" == "0" ] # Se o usuário quer terminar tudo (apertou o botão "Yes")
	then
		killall yad; # Mata o yad para o processo pai continuar executando (gera o RETURN CODE 143)
		exit 50; # Mata os pais e sai
	else
		exit 100; #exit; # Apenas sai do helper
	fi
}

# Função que determina se o aplicativo deverá ser finalizado a pedido do usuário.
# É executada quando o usuário aperta o botão padrão "X" para fechar a janela.
# Parâmetros:
# 	$? - EXIT CODE do último comando executado (no caso, apenas "displayCancelDialog")
verify_safe_exit()
{
	if [ "$?" == "0" ] # Se o usuário quer terminar tudo (apertou o botão "Yes")
	then
		exit 50; # Mata os pais e sai
	else
		exit 100; # Apenas sai do helper
	fi
}

#### MAIN ####

case $1 in
	"about") displayAboutDialog_GUI;; # Abre uma janela de diálogo "sobre" com uma pequena ajuda de utilização do programa em GUI ("help")
	"--help") displayHelp_CLI;; # Escreve na saída padrão (Terminal) uma ajuda de utilização do programa para CLI
	"--version") displayVersion_CLI;; # Escreve na saída padrão (Terminal) a versão do aplicativo para informação
	"cancel") displayCancelDialog; verify_term_all;; # Interrompe todos os processos relacionados ao programa
	"safe-exit") displayCancelDialog; verify_safe_exit;; # Finaliza o programa
esac;
