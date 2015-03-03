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
CONFIG_FILE_SDK="$HOME/.config/androidSDK_path.conf"
AVD_FOLDER="$HOME/.android/avd" # Valor padrão (default) - pode ser diferente
HELP_DESCRIPTION_TEXT="$APP_NAME is a simple tool that allows running the Android SDK emulator without opening Android Studio or using command-line interface (terminal). You can also perform some operations with Android Virtual Device (AVD) opened: Install and Uninstall APKs, copy files to the AVD or AVD to the computer, install Google Apps (Android 4.3+ only) and send adb commands to the AVD."
ADVICE_DESCRIPTION_TEXT="This tool doesn't download or manage AVDs, for that, use \"AVD Manager\"."

#x-terminal-emulator -e echo "Teste." # Executa algum comando no terminal padrão

#if adb pull - (...) else "Error";

main()
{
	verify_GUI;
	verify_android_SDK_path;
	verify_AVD_path;

	choose_avd;

	load_avd;
	menu;
}

#### FUNÇÕES DE VERIFICAÇÃO ####

verify_GUI()
{
	if [ -n "$DISPLAY" ] # O script está sendo executado em interface gráfica
	then
		return 0;
	else # O script está sendo executado em interface de texto
		>&2 echo "This program needs to be run in GUI mode.";
		exit 1;
	fi
}

verify_android_SDK_path()
{
	if [ ! -f "$CONFIG_FILE_SDK" ]
	then
		define_android_SDK_folder;
	fi
	SDK_FOLDER=$(cat $CONFIG_FILE_SDK);
}

verify_AVD_path()
{
	if [ ! -d "$AVD_FOLDER" ]
	then
		define_AVD_folder;
	fi
}

define_android_SDK_folder() # Função chamada apenas na primeira vez que o programa é executado (para definir a pasta onde o Android SDK está instalado)
{
	false; # Para entrar no while
	while [ $? -ne 0 ] # Enquanto a saída do último comando não for igual a ZERO (return =! 0)
	do
		sdk_path_tmp1=$(get_android_SDK_path);
			verifyReturnCode;
		if [ "$?" != "1" ] # Se o usuário não quer sair do programa
		then
			validate_android_SDK_path "$sdk_path_tmp1";
			local returnCode=$?;
			sdk_path_tmp1=""; #desaloca variável bash
			generateReturnCode $returnCode; ### Aqui não pode ser usado o "return" diretamente porque iria finalizar o loop "while" (BASH bosta)
		else # $? == 1
			false;
		fi
	done
}

define_AVD_folder()
{
	false; # Para entrar no while
	while [ $? -ne 0 ] # Enquanto a saída do último comando não for igual a ZERO (return =! 0)
	do
		avd_path_tmp1=$(get_AVD_path);
			verifyReturnCode;
		if [ "$?" != "1" ] # Se o usuário não quer sair do programa
		then
			validate_AVD_path "$avd_path_tmp1";
			local returnCode=$?;
			avd_path_tmp1=""; #desaloca variável bash
			generateReturnCode $returnCode; ### Aqui não pode ser usado o "return" diretamente porque iria finalizar o loop "while"
		else # $? == 1
			false;
		fi
	done
}

##########################################################################

get_android_SDK_path() # Imprime tela de apresentação e pede para o usuário colocar onde está localizada a pasta do Android SDK (apenas na primeira vez)
{
	sdk_path_tmp2=$(yad --title "$APP_NAME" --form --center --width=500 --image="android" --window-icon="android" --icon-name="android" --text "$HELP_DESCRIPTION_TEXT\n\n<b>$ADVICE_DESCRIPTION_TEXT</b>" --field 'Android SDK Path (this is needed only once)\:':DIR $HOME --separator="" --borders=5 --button=Cancel:"./avd-launcher-helper.sh cancel" --button=OK:0);
		process_return_cancel_button;
	local returnCode=$?; # Armazena o return (variável "?") para retornar depois (variável local)
	echo "$sdk_path_tmp2";
	sdk_path_tmp2=""; # desaloca variável bash
	return $returnCode;
}

get_AVD_path()
{
	avd_path_tmp=$(yad --title "$APP_NAME" --form --center --width=500 --image="help" --window-icon="android" --icon-name="android" --text "<b>AVD Folder not found</b>\n\nCould not find the Android Virtual Devices (AVDs) folder. Normally, the AVDs are located in the <tt>~/.android/avd/</tt> folder." --field 'Android AVDs Path\:':DIR $HOME --separator="" --borders=5 --button=Cancel:"./avd-launcher-helper.sh cancel" --button=OK:0);
		process_return_cancel_button;
	local returnCode=$?; # Armazena o return (variável "?") para retornar depois (variável local)
	echo "$avd_path_tmp"; # "return"
	avd_path_tmp=""; # desaloca variável bash
	return $returnCode;
}

validate_android_SDK_path() # Verifica se o caminho do Android SDK dado é válido (tem os principais executáveis necessários: "adb" e "emulator")
{
	if ls -U -1 --color=never $1 | grep \
	-e 'add-ons' \
	-e 'build-tools' \
	-e 'extras' \
	-e 'platforms' \
	-e 'platform-tools' \
	-e 'sources' \
	-e 'system-images' \
	-e 'tools' > /dev/null && find "$1/platform-tools/adb" "$1/tools/emulator" > /dev/null # Verifica a existência das pastas do Android SDK (ls com otimizações) e dos programas "adb" e "emulator"
	then
		echo "$1" > "$CONFIG_FILE_SDK"; # Escreve para um arquivo de configuração
		return $?;
	else
		dialog_invalid_folder;
		return 2;
	fi
}

validate_AVD_path()
{
	if ls -A "$1" > /dev/null && find "$1"/*.ini > /dev/null # Verifica se a pasta dos AVDs NÃO está vazia e contém arquivos de inicialização dos AVDs (*.ini)
	then
		AVD_FOLDER=$(echo "$1"); # Escreve para variável BASH
		return 0;
	else
		dialog_invalid_folder;
		return 1;
	fi
}

dialog_invalid_folder()
{
	yad --title "$APP_NAME" --error --center --width=350 --image="error" --window-icon="android" --icon-name="android" --text "<big><b>Invalid folder, try again.</b></big>" --text-align=center --button="OK:0";
}

#### FUNÇÕES PRINCIPAIS ####

choose_avd()
{	
	local AVDs_list=$(list_installed_AVDs); # string com o esqueleto da lista de AVDs no formato "zenity/yad"
	false; # Para entrar no while
	while [ $? -ne 0 ] # Enquanto a saída do último comando não for igual a ZERO (return =! 0)
	do
		CHOSEN_AVD=$(get_AVD_choice "$AVDs_list");
			verifyReturnCode;
		if [ "$?" != "1" ] # Se o usuário não quer sair do programa
		then
			execute_AVD_emulator & # Executa o Android SDK Emulator com o AVD escolhido (em background, "&" cria thread para a função "execute_AVD_emulator")
			true; # Termina o while
		else # $? == 1
			false; # Faz o while ter mais um loop
		fi
	done

}

get_AVD_choice()
{
	chosen_AVD_tmp=$(echo "$1" | yad --title "$APP_NAME" --list --center --width=350 --height=200 --image="android" --window-icon="android" --icon-name="android" --text "Choose below one of the Android Virtual Devices (AVDs) to run:" --radiolist --separator="" --column "Pick" --column "AVD" --print-column=2 --borders=5 --button=Cancel:"./avd-launcher-helper.sh cancel" --button=Launch:0);
		process_return_cancel_button;
	local returnCode=$?; # Armazena o return da janela para controlar depois (variável local)
	echo "$chosen_AVD_tmp";
	chosen_AVD_tmp=""; # desaloca variável bash
	return $returnCode;
}

execute_AVD_emulator() # Faz uma chamada para o emulador do Android SDK passando o nome do AVD como parâmetro para ele (em background)
{
	cd "$SDK_FOLDER"/tools; # Muda de diretório para ser possível chamar o emulador com o ponto-barra ("./") (NÃO MUDE ISSO!)
	./emulator -avd "$CHOSEN_AVD" -netspeed full -netdelay none;
}

load_avd()
{
	sleep 1; # Tempo suficiente para o processo ser criado (para não pegar PID vazio na próxima linha)
	EMULATOR_PID=$(ps -xo pid,command | grep emulator | grep --invert-match grep | cut -d'.' -f1) # Nome do processo pode ser "emulator64-x86", "emulator-x86", "emulator-arm", "emulator-mips", etc. ### Poderia usar o comando "pidof", mas a filtragem para obter apenas o nome do processo (sem "PATH" junto) daria um comando enorme, com um monte de pipes (mais LENTO!)
	EMULATOR_PSTATE="S"; # Valor inicial ("SLEEPING": apenas para entrar no while)
	( # Início do pipe para o zenity
	sleep 4; # Tempo aproximado para o "emulator*" estabilizar seus PSTATES (pra não sair do while antes da hora)
	while [ "$EMULATOR_PSTATE" != "R" ] # Enquanto o emulador não estiver no estado "Running" (PROCESS STATE CODES: R -> running or runnable (on run queue); D -> uninterruptible sleep (usually IO); S -> interruptible sleep (waiting for an event to complete); Z -> defunct/zombie, terminated but not reaped by its parent; T -> stopped, either by a job control signal or because it is being traced)
	do
		sleep 1;
		EMULATOR_PSTATE=$(ps -eo pid,state | grep "$EMULATOR_PID" | cut -d' ' -f2) # Obtêm o PSTATE do emulador
	done # Quando o emulador entrar no estado "Running", ele sai do loop e é impresso "100" para o zenity fechar
	echo 100; # Fecha o zenity (100% de progresso)
	) | # Pipe!
	zenity --title "$APP_NAME" --progress --pulsate --no-cancel --window-icon="android" --icon-name="android" --text "Initializing Android SDK Emulator with the \"$CHOSEN_AVD\" AVD..." --auto-close # Não foi usado o "yad" aqui porque esse tem bugs na barra de progresso no modo "pulsate"
}

menu()
{
	wait; # Espera as threads terminarem (o emulador é fechado)
}

#### FUNÇÕES AUXILIARES ####

process_return_cancel_button()
{
	local returnCode=$?;
	if [ "$returnCode" == "143" ] # O "yad" foi morto pelo helper ("killall")
	then
		return 50; # vai para o "verifyReturnCode" e este finaliza o programa
	elif [ "$returnCode" == "252" ] # O "yad" foi fechado usando as funções da janela para fechar o diálogo (padrão do "yad")
	then
		return 1; # Para entrar na função "verifyReturnCode" e abrir a janela de confirmação de fechamento do "helper"
	else #elif[ "$returnCode" == "0" ] # O "yad" saiu normalmente
		return 0;
	fi 
}

list_installed_AVDs() # Cria um array de arquivos .ini dos AVDs e "retorna" uma string com o esqueleto da lista de AVDs no formato "zenity/yad"
{
	shopt -s nullglob;
	local installed_AVDs=("$AVD_FOLDER"/*.ini);
	shopt -u nullglob; # Turn off nullglob to make sure it doesn't interfere with anything later
	#echo "${installed_AVDs[@]}"; # Note double-quotes to avoid extra parsing of funny characters in filenames

	for f in "${installed_AVDs[@]}"
	do
		if [ "$f" == "${installed_AVDs[0]}" ]
		then
			echo TRUE; # Palavra-chave do "yad" para marcar na lista
		else
			echo FALSE; # Palavra-chave do "yad" para NÃO marcar na lista
		fi
		basename "$f" .ini;
	done
}

verifyReturnCode()
{
	local returnCode=$?;
	if [ "$returnCode" == "50" ] # Se o RETURN CODE já é 50
	then # Significa que o usuário está querendo sair do programa apertando o botão Cancel, o "yad" abriu o helper e o usuário apertou "Yes" para fechar
		exit;
	elif [ "$returnCode" == "0" ] # o usuário não quer sair (apertou o botão OK da janela principal)
	then # o programa continua
		return 0;
	else
		./avd-launcher-helper.sh safe-exit # Abre janela de confirmação se quer mesmo fechar o programa
		if [ "$?" == "50" ] # Usuário apertou o botão de confirmação "Yes" para fechar
		then # o usuário quer sair
			exit;
		else # o usuário não quer sair (retornou "100")
			return 1; # return 1
		fi
	fi
}

generateReturnCode()
{
	return $1;
}

#### CHAMADA DA FUNÇÃO MAIN ####

main;