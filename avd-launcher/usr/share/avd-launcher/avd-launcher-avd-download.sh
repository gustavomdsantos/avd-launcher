#! /bin/bash
adbDeviceName=`~/Android/Sdk/platform-tools/adb devices | grep emulator | xargs echo | cut -d' ' -f1`;
receiveFile()
{

	false; # Para entrar no while
	while [ $? -ne 0 ] # Enquanto a saída do último comando não for igual a ZERO (return =! 0)
	do
		emulatorFileTmp1=$(chooseEmulatorFile);
			verifyReturnCode;

		localPathTmp1=$(chooseLocalPath);
			verifyReturnCode;

		if [ "$?" != "1" ] # Se o usuário não quer sair do programa
		then
			adb -s "$adbDeviceName" pull "$emulatorPathTmp1" "$localPathTmp1";
			local returnCode=$?;
			filePathTmp1=""; #desaloca variável bash
			emulatorPathTmp1=""; #desaloca variável bash
			generateReturnCode $returnCode; ### Aqui não pode ser usado o "return" diretamente porque iria finalizar o loop "while" (BASH bosta)
		else # $? == 1
			false;
		fi
	done
}

chooseLocalPath(){

	localPathTmp2=$(yad --title "$APP_NAME" \
	--center --width="800" --height="500" --window-icon="android" \
		--image="/usr/share/pixmaps/avd-launcher/avd-download.png" \
		--file --directory DIR $HOME --separator=""\
		--text "\n\nChoose the local folder\n\n" \
		--button=About:"./avd-launcher-helper.sh about" --button=Cancel:"./avd-launcher-helper.sh cancel" --button=OK:0);
		# process_return_cancel_button;
	local returnCode=$?; # Armazena o return (variável "?") para retornar depois (variável local)
	echo "$localPathTmp2"; # "return"
	localPathTmp2=""; # desaloca variável bash
	return $returnCode;
}
chooseEmulatorFile(){
	emulatorFileTmp2=$(yad --title "$APP_NAME" --entry\
		--center --width=500 --window-icon="android" \
		--image="/usr/share/pixmaps/avd-launcher/avd-download.png" \
		--text "\nWrite the emulator file path you want to receive:\n(Example: '/sdcard/test.png')\n" \
		--entry \
		--button=About:"./avd-launcher-helper.sh about" --button=Cancel:"./avd-launcher-helper.sh cancel" --button=OK:0);
		# process_return_cancel_button;
	local returnCode=$?; # Armazena o return (variável "?") para retornar depois (variável local)
	echo "$emulatorFileTmp2"; # "return"
	emulatorFileTmp2=""; # desaloca variável bash
	return $returnCode;

}

