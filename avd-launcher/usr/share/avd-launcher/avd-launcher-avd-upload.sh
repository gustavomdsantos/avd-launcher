#! /bin/bash
adb_device_name=`~/Android/Sdk/platform-tools/adb devices | grep emulator | xargs echo | cut -d' ' -f1`;
send_file()
{

	false; # Para entrar no while
	while [ $? -ne 0 ] # Enquanto a saída do último comando não for igual a ZERO (return =! 0)
	do
		file_path_tmp1=$(choose_local_file);
			verifyReturnCode;
		if [ "$?" != "1" ] # Se o usuário não quer sair do programa
		then
			adb -s "$adb_device_name" push "$file_path_tmp1" /sdcard/
			local returnCode=$?;
			file_path_tmp1=""; #desaloca variável bash
			generateReturnCode $returnCode; ### Aqui não pode ser usado o "return" diretamente porque iria finalizar o loop "while" (BASH bosta)
		else # $? == 1
			false;
		fi
	done
}

choose_local_file(){

	file_path_tmp2=$(yad --title "$APP_NAME" --form \
	--center --width="800" --height="500" --image="android" --window-icon="android" \
		--image="/usr/share/pixmaps/avd-launcher/avd-upload.png" \
		--file --multiple --file-filter="Todos os arquivos|*.*" \
		--text "$HELP_DESCRIPTION_TEXT\n\n" \
		--button=About:"./avd-launcher-helper.sh about" --button=Cancel:"./avd-launcher-helper.sh cancel" --button=OK:0);
		#process_return_cancel_button;
	local returnCode=$?; # Armazena o return (variável "?") para retornar depois (variável local)
	echo "$file_path_tmp2"; # "return"
	file_path_tmp2=""; # desaloca variável bash
	return $returnCode;
}

choose_local_file;