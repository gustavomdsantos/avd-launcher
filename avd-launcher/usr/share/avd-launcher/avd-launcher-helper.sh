#! /bin/bash

# Author: Gustavo Moraes <gustavosotnas1@gmail.com>
#
# This file is subject to the terms and conditions of the GNU General Public
# License. See the file COPYING in the main directory of this archive
# for more details.

# Parâmetros OBRIGATÓRIOS que o 'quick-deb-builder.sh' passa:
#	$1=$OPTION - Opções informativas do programa (--version, --help, -h)

# RETURN CODES personalizados do AVD Launcher:
# 	50 = "Yes" para fechar
#	100 = "No" para fechar

# Função que inicializa Strings em forma de variáveis locais para serem usadas em
# outras funções do helper.
# Constantes (Entrada - Parâmetro, Saída - String):
# 	$APP_NAME - o nome do aplicativo
# 	$CMD_NAME - o nome comando para executar o aplicativo
# 	$VERSION - a versão do aplicativo
# 	$APP_AUTHOR - o texto de direitos de autor
# 	$CONTACT_AUTHOR - URL de contato do autor
# 	$APP_HOMEPAGE - URL para o código fonte do aplicativo na Internet
# 	$APP_ABOUT ou $APP_ABOUT_FMT - texto de descrição do aplicativo ("FMT" = formatado para CLI)
#	$ADVICE_DESCRIPTION_TEXT - texto de aviso a respeito do AVD Manager, ferramenta que faz parte do Android SDK
get_message()
{
	case $1 in
		APP_NAME)
			local APP_NAME="Android Virtual Device Launcher";
			echo "$APP_NAME";;
		CMD_NAME)
			local CMD_NAME="avd-launcher";
			echo "$CMD_NAME";;
		VERSION)
			local VERSION="$(./avd-launcher-get-version.sh)";
			echo "$VERSION";;
		APP_AUTHOR)
			local APP_AUTHOR="Copyright (C) 2015 Gustavo Moraes";
			echo "$APP_AUTHOR";;
		CONTACT_AUTHOR)
			local CONTACT_AUTHOR="http://about.me/gustavosotnas";
			echo "$CONTACT_AUTHOR";;
		APP_HOMEPAGE)
			local APP_HOMEPAGE="https://github.com/gustavosotnas/avd-launcher";
			echo "$APP_HOMEPAGE";;
		APP_ABOUT | APP_ABOUT_FMT)
			local APP_ABOUT="Android Virtual Device Launcher is a simple tool that allows you to run AVDs in the Android SDK emulator without opening Android Studio or using command-line interface (terminal). Just selecting the AVD from the list of found AVDs and clicking on \"Launch\" button.";
			if [ "$1" == "APP_ABOUT" ]
			then
				echo "$APP_ABOUT";
			elif [ "$1" == "APP_ABOUT_FMT" ]
			then
				echo "$APP_ABOUT" | fmt -t;
			fi;;
		ADVICE_DESCRIPTION_TEXT)
			local ADVICE_DESCRIPTION_TEXT="This tool doesn't download or manage AVDs, for that, use \"AVD Manager\".";
			echo "$ADVICE_DESCRIPTION_TEXT";;
		*) false;; # default, lança apenas um return 1
	esac
}

# Função que exibe uma janela em interface gráfica informando a versão do aplicativo e uma pequena descrição
# do funcionamento do aplicativo e seu autor.
# Parâmetros:
# 	$APP_NAME (via 'get_message') - o nome do aplicativo
# 	$VERSION (via 'get_message') - a versão do aplicativo
# 	$APP_AUTHOR (via 'get_message') - o texto de direitos de autor
# 	$CONTACT_AUTHOR (via 'get_message') - URL de contato do autor
# 	$APP_ABOUT (via 'get_message') - texto de descrição do aplicativo
#	$ADVICE_DESCRIPTION_TEXT (via 'get_message') - texto de aviso a respeito do AVD Manager, ferramenta que faz parte do Android SDK
displayAboutDialog_GUI()
{
	yad --title "About `get_message APP_NAME`" --info \
	--center --width=500 --image="android" --window-icon="android" --icon-name="android" \
	--text "<b>`get_message APP_NAME`</b>\n\n`get_message VERSION`\n\
	\n`get_message APP_ABOUT`\n\
	\n<b>`get_message ADVICE_DESCRIPTION_TEXT`</b>\n\n`get_message APP_AUTHOR` <b>`get_message CONTACT_AUTHOR`</b>" \
	--text-align=center --borders=5 --button=Close:0;
}

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
displayHelp_CLI()
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
displayVersion_CLI()
{
	echo "$(get_message VERSION)";
}

# Função que exibe uma janela em interface gráfica perguntando ao usuário se ele quer finalizar o aplicativo.
# Parâmetros:
# 	$APP_NAME (variável GLOBAL) - o nome do aplicativo
displayCancelDialog()
{
	yad --title "$(get_message APP_NAME)" --info \
	--center --width=350 --image="help" --window-icon="android" --icon-name="android" \
	--text "<b>Are you sure you want to exit from $(get_message APP_NAME)?</b>" --text-align=center --button=No:1 --button=Yes:0;
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
