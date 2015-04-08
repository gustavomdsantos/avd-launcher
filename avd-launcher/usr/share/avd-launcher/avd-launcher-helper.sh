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
VERSION="0.2.0-nightly"
APP_AUTHOR="Copyright (C) 2015 Gustavo Moraes"
CONTACT_AUTHOR="http://about.me/gustavosotnas"
APP_HOMEPAGE="https://github.com/gustavosotnas/avd-launcher"
HELP_DESCRIPTION_TEXT_LINE1="$APP_NAME is a simple tool that allows run" 
HELP_DESCRIPTION_TEXT_LINE2="the Android SDK emulator without opening Android Studio or using"
HELP_DESCRIPTION_TEXT_LINE3="command-line interface (terminal). You can also perform some operations with"
HELP_DESCRIPTION_TEXT_LINE4="Android Virtual Device (AVD) opened: Install and Uninstall APKs,"
HELP_DESCRIPTION_TEXT_LINE5="copy files to the AVD or AVD to the computer, install Google Apps (Android 4.3+ "
HELP_DESCRIPTION_TEXT_LINE6="only) and send adb commands to the AVD."
ADVICE_DESCRIPTION_TEXT="This tool doesn't download or manage AVDs, for that, use \"AVD Manager\"."

displayAboutDialog_GUI()
{
	yad --title "About $APP_NAME" --info --center --width=500 --image="android" --window-icon="android" --icon-name="android" --text "<b>$APP_NAME</b>\n\n$VERSION\n\n`echo $HELP_DESCRIPTION_TEXT_LINE1 $HELP_DESCRIPTION_TEXT_LINE2 $HELP_DESCRIPTION_TEXT_LINE3 $HELP_DESCRIPTION_TEXT_LINE4 $HELP_DESCRIPTION_TEXT_LINE5 $HELP_DESCRIPTION_TEXT_LINE6`\n\n<b>$ADVICE_DESCRIPTION_TEXT</b>\n\n$APP_AUTHOR <b>$CONTACT_AUTHOR</b>" --text-align=center --borders=5 --button=Close:0;
}

##displayHelp_CLI()
##{

##}

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
	yad --title "$APP_NAME" --info --center --width=350 --image="help" --window-icon="android" --icon-name="android" --text "<b>Are you sure you want to exit from $APP_NAME?</b>" --text-align=center --button=No:1 --button=Yes:0;
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
	"--help") displayHelp_CLI;; # Escreve na saída padrão (Terminal) uma ajuda de utilização do programa para CLI	"--version") displayVersion_CLI;; # Escreve na saída padrão (Terminal) a versão do aplicativo para informação
	"--version") displayVersion_CLI;; # Escreve na saída padrão (Terminal) a versão do aplicativo para informação
	"cancel") displayCancelDialog; verify_term_all;; # Interrompe todos os processos relacionados ao programa
	"safe-exit") displayCancelDialog; verify_safe_exit;; # Finaliza o programa
esac;
