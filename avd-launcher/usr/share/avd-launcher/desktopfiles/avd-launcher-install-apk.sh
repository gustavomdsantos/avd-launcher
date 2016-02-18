# Arquivo responsável pela instalação de qualquer APK desejado pelo usuário, do PC para o emulador.

selectAPK(){

  local APK = $(yad --title "Escolha de APK" --file-selection \
  -- center --width=300 \
  -- text="Selecione qual APK deseja instalar no emulador em execução" \
  --image="/usr/share/pixmaps/avd-launcher/avd-install-apk.png" \
  );

  return APK;
}

installAPK(){

  pathAPK = $(selectAPK);
  adb -s CHOSEN_AVD install pathAPK;
}
