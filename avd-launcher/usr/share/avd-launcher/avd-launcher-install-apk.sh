# Arquivo responsável pela instalação de qualquer APK desejado pelo usuário, do PC para o emulador.
installAPK(){

  pathAPK = $(selectAPK);
  selectDirectory;

  adb -s "$adbDeviceName" install "$pathAPK";
}

selectAPK(){

  local APK = $(yad --title "Escolha de APK" --file-selection \
  -- center --width=800 \
  --file --multiple --file-filter="APK | *.apk"
  -- text="Selecione qual APK deseja instalar no emulador em execução" \
  --image="/usr/share/pixmaps/avd-launcher/avd-install-apk.png" \
  );

  return APK;
}

selectDirectory(){

  local Origem=$(yad --file \
  --directory \
  --title="Selecione o diretório do ADB" \
  --width="500" \
  --height="600");

  adbDeviceName = $("$Origem" | grep emulator | xargs echo | cut -d' ' -f1`);
}
