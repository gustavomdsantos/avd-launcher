#! /bin/bash

# Author: Gustavo Moraes <gustavosotnas1@gmail.com>
#
# This file is subject to the terms and conditions of the GNU General Public
# License. See the file COPYING in the main directory of this archive
# for more details.

# "Classe" que contêm informações estáticas sobre o AVD Launcher.

getAppName()
{
	local APP_NAME="Android Virtual Device Launcher";
	echo "$APP_NAME";
}

getCmdName()
{
	local CMD_NAME="avd-launcher";
	echo "$CMD_NAME";
}

# Script para obter o número da versão do AVD Launcher.
getVersion()
{
	local DPKG_OUTPUT;
	if DPKG_OUTPUT=`dpkg -s avd-launcher 2>/dev/null` # stderr -> "Buraco Negro"
	then
		local VERSION=`echo "$DPKG_OUTPUT" | grep 'Version' | cut -d':' -f2 | 
		xargs echo`;
		echo "$VERSION";
	else
		echo "Not installed";
	fi
}

getAppAuthor()
{
	local APP_AUTHOR="Copyright (C) 2015 Gustavo Moraes";
	echo "$APP_AUTHOR";
}

getAuthorContact()
{
	local CONTACT_AUTHOR="http://about.me/gustavosotnas";
	echo "$CONTACT_AUTHOR";
}

getAppHomepage()
{
	local APP_HOMEPAGE="https://github.com/gustavosotnas/avd-launcher";
	echo "$APP_HOMEPAGE";
}

getAppAbout()
{
	local APP_ABOUT="Android Virtual Device Launcher is a simple tool that allows you to run AVDs in the Android SDK emulator without opening Android Studio or using command-line interface (terminal). Just selecting the AVD from the list of found AVDs and clicking on \"Launch\" button.";
	echo "$APP_ABOUT";
}

getAppAdvice()
{
	local ADVICE_DESCRIPTION_TEXT="This tool doesn't download or manage AVDs, for that, use \"AVD Manager\".";
	echo "$ADVICE_DESCRIPTION_TEXT";
}

### MAIN ####

case $1 in
	"getAppName") getAppName;;
	"getCmdName") getCmdName;;
	"getVersion") getVersion;;
	"getAppAuthor") getAppAuthor;;
	"getAuthorContact") getAuthorContact;;
	"getAppHomepage") getAppHomepage;;
	"getAppAbout") getAppAbout;;
	"getAppAdvice") getAppAdvice;;
esac;