#! /bin/bash

# "Classe" que contêm informações estáticas sobre o AVD Launcher.
#
# Author: Gustavo Moraes <gustavosotnas1@gmail.com>
#
# This file is subject to the terms and conditions of the GNU General Public
# License. See the file COPYING in the main directory of this archive
# for more details.

# Obtêm o nome do aplicativo.
# Retorna:
# 	$APP_NAME - o nome do aplicativo (por extenso)
getAppName()
{
	local APP_NAME="Android Virtual Device Launcher";
	return_str "$APP_NAME";
}

# Obtêm o nome do comando para abrir o aplicativo via linha de comando (CLI).
# Retorna:
# 	$CMD_NAME - o nome do comando
getCmdName()
{
	local CMD_NAME="avd-launcher";
	return_str "$CMD_NAME";
}

# Obtêm o número da versão do aplicativo. É um script que obtêm isso através da
# consulta às informações do pacote "avd-launcher" ao DPKG do Linux, caso tenha.
# Retorna:
# 	$VERSION - a versão do app ou "Not installed", caso não esteja instalado.
getVersion()
{
	local DPKG_OUTPUT;
	if DPKG_OUTPUT=`dpkg -s avd-launcher 2>/dev/null` # stderr -> "Buraco Negro"
	then
		local VERSION=`echo "$DPKG_OUTPUT" | grep 'Version' | cut -d':' -f2 | 
		xargs echo`;
		echo "$VERSION";
	else
		return_str "Not installed";
	fi
}

# Obtêm o nome do(s) autor(es) do aplicativo.
# Retorna:
# 	$APP_AUTHOR - o nome do(s) autor(es) seguido de Copyright e o ano de lançado
getAppAuthor()
{
	local APP_AUTHOR="Copyright (C) 2015 Gustavo Moraes";
	return_str "$APP_AUTHOR";
}

# Obtêm o nome do(s) autor(es) do aplicativo.
# Retorna:
# 	$APP_AUTHOR - o nome do(s) autor(es) seguido de Copyright e o ano de lançado
getAuthorContact()
{
	local CONTACT_AUTHOR="http://about.me/gustavosotnas";
	return_str "$CONTACT_AUTHOR";
}

# Obtêm o link para a página principal do projeto do aplicativo.
# Pode ser o link para o repositório no GitHub / Sourceforge ou o Website do
# aplicativo, caso exista.
# Retorna:
# 	$APP_HOMEPAGE - o link na Internet sobre o aplicativo.
getAppHomepage()
{
	local APP_HOMEPAGE="https://github.com/gustavosotnas/avd-launcher";
	return_str "$APP_HOMEPAGE";
}

# Obtêm o texto de descrição e ajuda geral sobre o aplicativo.
# É exibido tanto na interface gráfica (GUI) quanto na interface de texto (CLI).
# Retorna:
# 	$APP_ABOUT - string de texto com informações sobre o aplicativo.
getAppAbout()
{
	local APP_ABOUT="Android Virtual Device Launcher is a simple tool that allows you to run AVDs in the Android SDK emulator without opening Android Studio or using command-line interface (terminal). Just selecting the AVD from the list of found AVDs and clicking on \"Launch\" button.";
	return_str "$APP_ABOUT";
}

# Texto opcional de aviso de algo no aplicativo.
# Pode ser uma restrição de escopo do aplicativo.
# Retorna:
# 	$ADVICE_DESCRIPTION_TEXT - string de texto aviso do aplicativo.
getAppAdvice()
{
	local ADVICE_DESCRIPTION_TEXT="This tool doesn't download or manage AVDs, for that, use \"AVD Manager\".";
	return_str "$ADVICE_DESCRIPTION_TEXT";
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