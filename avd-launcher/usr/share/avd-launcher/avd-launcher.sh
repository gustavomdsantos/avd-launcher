#! /bin/bash

# Author: Gustavo Moraes <gustavosotnas@gmail.com>
#
# This file is subject to the terms and conditions of the GNU General Public
# License. See the file COPYING in the main directory of this archive
# for more details.

APP_NAME="Android Virtual Device Launcher"
VERSION="1.0"
CONFIG_FILE_SDK="$HOME/.config/androidSDK_path.conf"
AVD_FOLDER="$HOME/.android/avd" # Valor padrão (default) - pode ser diferente
HELP_DESCRIPTION_TEXT="$APP_NAME is a simple tool that allows you to run AVDs in the Android SDK Emulator, without opening Android Studio or using command-line interface (terminal)."

# Função que começa a execução do programa.
# Parâmetros (que o '/usr/bin/avd-launcher' passa):
#	$1=$OPTION - Opções informativas do programa (--version, --help, -h)
init()
{
	case "$1" in
		"-h"|"--help" )
			./avd-launcher-helper.sh --help;; # Esse "--help" é DIFERENTE de "about", este último abre uma janela em GUI!
		"--version" )
			./avd-launcher-helper.sh --version;; # Exibe a versão do programa
		*)
			main;; # Executa as funcionalidades principais do programa em GUI
	esac
}

# Função principal do programa, em interface gráfica (GUI). Tem definidas as sequências de execução do aplicativo (algoritmos).
main()
{
	verify_GUI;
	verify_android_SDK_path;
	verify_AVD_path;

	choose_avd;

	loading_avd;
	menu;
}

#### FUNÇÕES DE VERIFICAÇÃO ####

# Função que verifica se o programa está sendo executado em interface gráfica.
# Parâmetros:
#	$DISPLAY (variável de ambiente) - O número do monitor para o X Window System
verify_GUI()
{
	if [ -n "$DISPLAY" ]
	then # Está sendo executado em interface gráfica
		return 0;
	else # O script está sendo executado em interface de texto
		>&2 echo "This program needs to be run in GUI mode.";
		exit 1;
	fi
}

# Verifica se a pasta onde está localizada o Android SDK está definida (em um arquivo de configuração).
# Parâmetros:
#	$CONFIG_FILE_SDK (variável GLOBAL) - o caminho do arquivo de configuração definido (ou a ser criado)
# Saída:
#	$SDK_FOLDER (variável GLOBAL) - o caminho do diretório do Android SDK (conteúdo do arquivo de configuração).
verify_android_SDK_path()
{
	if [ ! -f "$CONFIG_FILE_SDK" ]
	then
		define_android_SDK_folder;
	fi
	SDK_FOLDER=$(cat $CONFIG_FILE_SDK);
}

# Verifica se a pasta onde está os Android Virtual Devices (AVDs) existe.
# Parâmetros:
#	$AVD_FOLDER (variável GLOBAL) - o caminho do diretório dos AVDs padrão (caso não exista, este será definido).
verify_AVD_path()
{
	if [ ! -d "$AVD_FOLDER" ]
	then
		define_AVD_folder;
	fi
}

# Função que define o caminho do diretório onde o Android SDK está instalado.
# É chamada apenas na primeira vez que o programa é executado.
define_android_SDK_folder()
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

# Função que define o caminho do diretório onde os AVDs estão localizados.
# É chamada apenas quando o caminho padrão dos AVDs (variável $AVD_FOLDER) não é válida.
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

# Cria janela de apresentação e pede para o usuário colocar onde está localizada a pasta do Android SDK (apenas na primeira vez)
# Parâmetros:
#	$APP_NAME (variável GLOBAL) - nome do aplicativo
#	$HELP_DESCRIPTION_TEXT (variável GLOBAL) - texto de descrição do aplicativo.
#	$HOME (variável de ambiente) - caminho do diretório inicial do usuário (diretório padrão para "drop-down" da janela)
# Retorna ("echo"):
#	$sdk_path_tmp2 - caminho do diretório escolhido pelo usuário (supostamente contém o Android SDK nele)
get_android_SDK_path()
{
	# Na linha abaixo "$sdk_path_2" não pode ser variável "local" porque o EXIT CODE do "yad" é descartado (problema do Bash, talvez o pessoal do GNU Project melhore isso na próxima versão)
	sdk_path_tmp2=$(yad --title "$APP_NAME" --form \
		--center --width=500 --image="android" --window-icon="android" \
		--text "$HELP_DESCRIPTION_TEXT\n\n" \
		--field 'Android SDK Path (this is needed only once)\:':DIR $HOME --separator="" --borders=5 \
		--button=Cancel:"./avd-launcher-helper.sh cancel" --button=OK:0);
		process_return_cancel_button;
	local returnCode=$?; # Armazena o return (variável "?") para retornar depois (variável local)
	echo "$sdk_path_tmp2"; # "return"
	sdk_path_tmp2=""; # desaloca variável bash
	return $returnCode;
}

# Cria janela de apresentação e pede para o usuário colocar onde está localizada a pasta dos AVDs (apenas se os AVDs não estão na pasta padrão)
# Parâmetros:
#	$APP_NAME (variável GLOBAL) - nome do aplicativo
#	$HOME (variável de ambiente) - caminho do diretório inicial do usuário (diretório padrão para "drop-down" da janela)
# Retorna ("echo"):
#	$avd_path_tmp - caminho do diretório escolhido pelo usuário (supostamente contém o Android SDK nele)
get_AVD_path()
{
	avd_path_tmp=$(yad --title "$APP_NAME" --form \
		--center --width=500 --image="help" --window-icon="android" \
		--text "<b>AVD Folder not found</b>\n\nCould not find the Android Virtual Devices (AVDs) folder. Normally, the AVDs are located in the <tt>~/.android/avd/</tt> folder." \
		--field 'Android AVDs Path\:':DIR $HOME --separator="" --borders=5 \
		--button=Cancel:"./avd-launcher-helper.sh cancel" --button=OK:0);
		process_return_cancel_button;
	local returnCode=$?; # Armazena o return (variável "?") para retornar depois (variável local)
	echo "$avd_path_tmp"; # "return"
	avd_path_tmp=""; # desaloca variável bash
	return $returnCode;
}

# Função que verifica se o caminho do Android SDK dado é válido (tem os principais executáveis necessários: "adb" e "emulator")
# Parâmetros:
#	$1 - Caminho do diretório informado pelo usuário na função "get_android_SDK_path" que supostamente contém o Android SDK
# Arquivos criados:
#	'$HOME/.config/androidSDK_path.conf' (especificada na variável "$CONFIG_FILE_SDK") - arquivo de configuração que contém o caminho do diretório do Android SDK válido
validate_android_SDK_path()
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
	then # A pasta é do Android SDK
		echo "$1" > "$CONFIG_FILE_SDK"; # Escreve para um arquivo de configuração
		return $?;
	else # Não é uma pasta válida
		dialog_invalid_folder;
		return 2;
	fi
}

# Função que verifica se o caminho do diretório dos AVDs dado é válido (a pasta NÃO está vazia e contém arquivos de inicialização dos AVDs (*.ini))
# Parâmetros:
#	$1 - Caminho do diretório informado pelo usuário na função "get_AVD_path" que supostamente contém os AVDs
# Saída:
#	$AVD_FOLDER - o caminho do diretório dos AVDs válido
validate_AVD_path()
{
	if ls -A "$1" > /dev/null && find "$1"/*.ini > /dev/null
	then # É a pasta dos AVDs
		AVD_FOLDER=$(echo "$1"); # Escreve para variável BASH
		return 0;
	else # Não é uma pasta válida
		dialog_invalid_folder;
		return 1;
	fi
}

# Função que exibe uma janela informando que o caminho do diretório informado é inválido.
# Parâmetros:
#	$APP_NAME (variável GLOBAL) - o nome do aplicativo
dialog_invalid_folder()
{
	yad --title "$APP_NAME" --error \
	--center --width=350 --image="error" --window-icon="android" \
	--text "<big><b>Invalid folder, try again.</b></big>" --text-align=center \
	--button="OK:0";
}

#### FUNÇÕES PRINCIPAIS ####

# Função que permite ao usuário escolher o AVD que deseja executar, de acordo com a lista de AVDs disponível.
# Saída:
#	$CHOSEN_AVD - o nome do AVD escolhido pelo usuário.
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

# Função que cria uma janela em GUI pedindo para o usuário escolher o AVD desejado dentre os que estiverem na lista de AVDs.
# Parâmetros:
#	$1 - a lista de AVDs localizados para escolha
#	$APP_NAME (variável GLOBAL) - nome do aplicativo
# Retorna ("echo"):
#	$chosen_AVD_tmp - o nome do AVD que o usuário escolheu
get_AVD_choice()
{
	chosen_AVD_tmp=$(echo "$1" | yad --title "$APP_NAME" --list \
		--center --width=350 --height=200 --image="android" --window-icon="android" \
		--text "Choose below one of the Android Virtual Devices (AVDs) to run:" \
		--radiolist --separator="" --column "Pick" --column "AVD" --print-column=2 --borders=5 \
		--button=About:"./avd-launcher-helper.sh about" --button=Cancel:"./avd-launcher-helper.sh cancel" --button=Launch:0);
		process_return_cancel_button;
	local returnCode=$?; # Armazena o return da janela para controlar depois (variável local)
	echo "$chosen_AVD_tmp";
	chosen_AVD_tmp=""; # desaloca variável bash
	return $returnCode;
}

# Função que faz uma chamada para o emulador do Android SDK passando o nome do AVD como parâmetro para ele (função executada em background).
# Parâmetros:
#	$SDK_FOLDER (variável GLOBAL) - a pasta onde está localizado o Android SDK
#	$CHOSEN_AVD (variável GLOBAL) - o nome do Android Virtual Device (AVD) escolhido pelo usuário para executar
execute_AVD_emulator()
{
	cd "$SDK_FOLDER"/tools; # Muda de diretório para ser possível chamar o emulador com o ponto-barra ("./") (NÃO MODIFIQUE ISSO!)
	./emulator -avd "$CHOSEN_AVD" -netspeed full -netdelay none;
}

# Função que cria uma janela de carregamento pulsante para dar "feedback" ao usuário de que o emulador do Android SDK está inicializando.
# Parâmetros:
#	$APP_NAME (variável GLOBAL) - o nome do aplicativo
#	$CHOSEN_AVD (variável GLOBAL) - o AVD que está sendo inicializado
loading_avd()
{
	( # Início do subshell para o zenity
	local is_emulator_window_opened="false"; # Flag para o while

	sleep 1; # tempo suficiente para a janela de progresso abrir e o wmctrl ser executado corretamente na próxima linha
	wmctrl -r "$APP_NAME" -b toggle,above; # Deixa a janela de progresso do zenity "always-on-top" (vmctrl busca o nome da janela aberta)

	while [ "$is_emulator_window_opened" != "true" ] # enquanto o vmctrl NÃO detectar a janela com o nome do AVD
	do
		wmctrl -l | grep $CHOSEN_AVD; # Lista todas as janelas abertas no computador e tenta filtar a janela cujo nome é o nome do AVD escolhido
		if [ "$?" == "0" ] # Se a janela procurada está aberta
		then
			is_emulator_window_opened="true"; # sai do while para fechar a janela de progresso
		else
			sleep 0.5; # não pode ser um tempo de sleep pequeno demais, pois o comando `wmctrl | grep` consome CPU
		fi
	done

	echo 100; # Fecha o zenity (100% de progresso)

	) | # Pipe!
	zenity --progress --title "$APP_NAME" \
	--pulsate --no-cancel --window-icon="android" \
	--text "Initializing Android SDK Emulator with the \"$CHOSEN_AVD\" AVD..." --auto-close; # Não foi usado o "yad" aqui porque ele tem bugs na barra de progresso no modo "pulsate"
}

# Função que deixa o AVD Launcher "em espera" até o Android SDK ser fechado.
# É um "semáforo" que espera a thread da função "execute_AVD_emulator" finalizar para o script inteiro finalizar.
# Sem isso, depois que a função "loading_avd" terminasse de executar (a janela do "zenity" fechasse), 
# o processo do emulador do Android SDK seria "morto" pelo script, por ter sido chamado dentro de uma thread do mesmo.
#
# Obs.: Nas próximas versões do AVD Launcher será implementada uma janela de menu com opções para manipulação do AVD, 
# e por isso não teria mais necessidade de colocar um "wait" no programa, pois teria um "I/O event wait" no lugar.
menu()
{
	wait; # Espera as threads terminarem (o emulador é fechado)
}

#### FUNÇÕES AUXILIARES ####

# Cria um array do nome dos arquivos .ini dos AVDs e "retorna" uma string com a lista de AVDs para o usuário escolher, sendo o primeiro AVD listado a opção marcada por "default" na lista.
# Parâmetros:
#	$AVD_FOLDER (variável GLOBAL) - o caminho da pasta onde estão localizados os AVDs
# Retorna ("echo" e "basename"):
#	$AVDs_list - string com o esqueleto da lista dos AVDs localizados para execução no formato de checklist do "zenity/yad": "TRUE Android_Wear_Round_API_20 FALSE Nexus_6_API_21 FALSE Nexus_S_API_19"
list_installed_AVDs()
{
	shopt -s nullglob;
	local installed_AVDs=("$AVD_FOLDER"/*.ini);
	shopt -u nullglob; # Turn off nullglob to make sure it doesn't interfere with anything later
	#echo "${installed_AVDs[@]}"; # Note double-quotes to avoid extra parsing of funny characters in filenames

	for f in "${installed_AVDs[@]}"
	do
		if [ "$f" == "${installed_AVDs[0]}" ]
		then
			echo TRUE; # Palavra-chave do "yad" para marcar na lista (um "radio button")
		else
			echo FALSE; # Palavra-chave do "yad" para NÃO marcar na lista
		fi
		basename "$f" .ini; # Imprime o nome do arquivo sem a extensão dele (sufixo)
	done
}

# Executada apenas após chamadas de execução do "yad", esta função processa o EXIT CODE do "yad", para computar o que aconteceu com a janela (se o usuário a fechou ou não).
# Parâmetros:
#	$? - o EXIT CODE do "yad"
# Retorna:
#	EXIT CODE apropriado para cada caso no AVD Launcher (função "verifyReturnCode", executada um nível acima das funções que chamam o "yad").
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

# Função que processa o RETURN CODE do último evento de I/O do programa (janelas em GUI) para decisão se o programa deve ser finalizado ou não.
# RETURN CODES personalizados do AVD Launcher:
#	50 = "Yes" para fechar
#	100 = "No" para fechar
# Parâmetros:
#	$? - o RETURN CODE (ou EXIT CODE) do último comando executado (normalmente, depois da execução do "process_return_cancel_button")
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

# Função que gera um RETURN CODE qualquer, definido pelo usuário (função).
# É chamada em casos onde não se pode usar o "return" diretamente, para não quebrar a execução do script (sem "subshells").
# Parâmetros:
#	$1 - o RETURN CODE desejado para ser lançado
# Retorna:
#	$? - o RETURN CODE desejado pelo usuário da função
generateReturnCode()
{
	return $1;
}

#### CHAMADA DA FUNÇÃO INIT ####

init $@;
