#! /bin/bash
# Configuração de aliases de MVC (por causa que o YAD sempre chama em Subshell)
shopt -s expand_aliases && alias import='alias' return_str='echo -n -e';

import model.AppInfo='source ../model/AppInfo.sh';
import controller.GUIController='source ../controller/GUIController.sh';

# "Classe" que contém o código das janelas de diálogo do AVD Launcher. 
#
# Author: Gustavo Moraes <gustavosotnas1@gmail.com>
#
# This file is subject to the terms and conditions of the GNU General Public
# License. See the file COPYING in the main directory of this archive
# for more details.

# Função que exibe uma janela informando que o caminho do diretório é inválido.
displayInvalidFolder()
{
	yad --title "`model.AppInfo getAppName`" --error \
	--center --width=350 --image="error" --window-icon="android" \
	--text "<big><b>Invalid folder, try again.</b></big>" \
	--text-align=center --borders=5 --button="OK:0";
}

# Função que exibe uma janela informando a versão do aplicativo e 
# uma pequena descrição do funcionamento do aplicativo e seu autor.
displayAbout()
{
	yad --title "About `model.AppInfo getAppName`" --info \
	--center --width=500 --image="android" --window-icon="android" --icon-name="android" \
	--text "<b>`model.AppInfo getAppName`</b>\n\n`model.AppInfo getVersion`\n\
	\n`model.AppInfo getAppAbout`\n\
	\n<b>`model.AppInfo getAppAdvice`</b>\n\n`model.AppInfo getAppAuthor` <b>`model.AppInfo getAuthorContact`</b>" \
	--text-align=center --borders=5 --button=Close:0;
}

# Função que exibe uma janela em interface gráfica perguntando ao usuário se ele
# quer finalizar o aplicativo.
# Retorna:
# 	$? - 
# 		TRUE quando o usuário aperta o botão "Yes"
# 		FALSE quando o usuário aperta o botão "No"
displayCancel()
{
	yad --title "`model.AppInfo getAppName`" --info \
	--center --width=450 --image="help" --window-icon="android" --icon-name="android" \
	--text "<big><b>Are you sure you want to exit from `model.AppInfo getAppName`?</b></big>" \
	--text-align=center --borders=5 --button=No:1 --button=Yes:0;
	controller.GUIController onClickCancelButton "$?";
}

### MAIN ####

case $1 in
	"displayInvalidFolder") displayInvalidFolder;;
	"displayAbout") displayAbout;;
	"displayCancel") displayCancel;;
esac;