#! /bin/bash
adbDeviceName=`~/Android/Sdk/platform-tools/adb devices | grep emulator | xargs echo | cut -d' ' -f1`;
sendFile()
{

	false; # Para entrar no while
	while [ $? -ne 0 ] # Enquanto a saída do último comando não for igual a ZERO (return =! 0)
	do
		filePathTmp1=$(chooseLocalFile);
			verifyReturnCode;
		if [ "$?" != "1" ] # Se o usuário não quer sair do programa
		then
		emulatorPathTmp1=$(chooseEmulatorPath);
			verifyReturnCode;

			if [ "$?" != "1" ] # Se o usuário não quer sair do programa
			then
				adbReturn=$(adb -s "$adbDeviceName" push "$filePathTmp1" "$emulatorPathTmp1");
				local returnCode=$?;
				filePathTmp1=""; #desaloca variável bash
				emulatorPathTmp1=""; #desaloca variável bash
				generateReturnCode $returnCode; ### Aqui não pode ser usado o "return" diretamente porque iria finalizar o loop "while" (BASH bosta)
			else # $? == 1
				false;
			fi
		else # $? == 1
			false;
		fi
	done
}

chooseLocalFile(){

	filePathTmp2=$(yad --title "$APP_NAME" \
	--center --width="800" --height="500" --window-icon="android" \
		--image="/usr/share/pixmaps/avd-launcher/avd-upload.png" \
		--file --multiple --file-filter="Todos os arquivos|*.*" DIR $HOME --separator=""\
		--text "\n\nChoose files to send\n\n" \
		--button=About:"./avd-launcher-helper.sh about" --button=Cancel:"./avd-launcher-helper.sh cancel" --button=OK:0);
		# process_return_cancel_button;
	local returnCode=$?; # Armazena o return (variável "?") para retornar depois (variável local)
	echo "$filePathTmp2"; # "return"
	filePathTmp2=""; # desaloca variável bash
	return $returnCode;
}
chooseEmulatorPath(){
	emulatorPathTmp2=$(yad --title "$APP_NAME" --entry\
		--center --width=500 --window-icon="android" \
		--image="/usr/share/pixmaps/avd-launcher/avd-upload.png" \
		--text "\n\nWrite the emulator path you want to send the file(Example: '/sdcard/'):\n" \
		--entry \
		--button=About:"./avd-launcher-helper.sh about" --button=Cancel:"./avd-launcher-helper.sh cancel" --button=OK:0);
		# process_return_cancel_button;
	local returnCode=$?; # Armazena o return (variável "?") para retornar depois (variável local)
	echo "$emulatorPathTmp2"; # "return"
	emulatorPathTmp2=""; # desaloca variável bash
	return $returnCode;

}
