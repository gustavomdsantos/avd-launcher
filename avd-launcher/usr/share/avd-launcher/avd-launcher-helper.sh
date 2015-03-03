#! /bin/bash

# Author: Gustavo Moraes <gustavosotnas@gmail.com>
#
# This file is subject to the terms and conditions of the GNU General Public
# License. See the file COPYING in the main directory of this archive
# for more details.

# RETURN CODES personalizados do AVD Launcher:
# 	50 = "Yes" para fechar
#	100 = "No" para fechar

APP_NAME="Android Virtual Device Launcher"
VERSION="0.1.1"
HELP_DESCRIPTION_TEXT="$APP_NAME is a simple tool that allows running the Android SDK emulator without opening Android Studio or using command-line interface (terminal). You can also perform some operations with Android Virtual Device (AVD) opened: Install and Uninstall APKs, copy files to the AVD or AVD to the computer, install Google Apps (Android 4.3+ only) and send adb commands to the AVD."
ADVICE_DESCRIPTION_TEXT="This tool doesn't download or manage AVDs, for that, use \"AVD Manager\"."
APP_AUTHOR="Copyright (C) 2015 Gustavo Moraes http://about.me/gustavosotnas"

displayAboutDialog()
{
	yad --title "About $APP_NAME" --info --center --width=500 --image="android" --window-icon="android" --icon-name="android" --text "<b>$APP_NAME</b>\n\n$VERSION\n\n$HELP_DESCRIPTION_TEXT <b>$ADVICE_DESCRIPTION_TEXT</b>\n\n$APP_AUTHOR" --text-align=center --borders=5 --button=Close:0;
}

displayCancelDialog()
{
	yad --title "$APP_NAME" --info --center --width=350 --image="help" --window-icon="android" --icon-name="android" --text "<b>Are you sure you want to exit from $APP_NAME?</b>" --text-align=center --button=No:1 --button=Yes:0;
}

verify_term_all()
{
	if [ "$?" == "0" ] # Se o usuário quer terminar tudo (apertou o botão "Yes")
	then
		killall yad; # Mata o yad para o processo pai continuar executando (gera o RETURN CODE 143)
		exit 50; #killall yad avd-launcher.sh; exit; # Mata os pais e sai
	else
		exit 100; #exit; # Apenas sai do helper
	fi
}

verify_safe_exit()
{
	if [ "$?" == "0" ] # Se o usuário quer terminar tudo (apertou o botão "Yes")
	then
		exit 50; #killall yad avd-launcher.sh; exit; # Mata os pais e sai
	else
		exit 100; #exit; # Apenas sai do helper
	fi
}

case $1 in
	"about") displayAboutDialog;; # Abre uma janela de diálogo "sobre"
	"cancel") displayCancelDialog; verify_term_all;; # Interrompe todos os processos relacionados ao AVD Launcher
	"safe-exit") displayCancelDialog; verify_safe_exit;;
esac;