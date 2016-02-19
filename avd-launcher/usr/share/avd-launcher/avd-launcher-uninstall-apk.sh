# Arquivo responsável pela desinstalação de APKs desejado pelo usuário.
uninstallApk(){

  pathApk = $(selectAPK);

  adb uninstall-apk "$pathApk";

  pathPackage = $(selectDirectory;

  adb uninstall "$pathPackage";
}

selectAPK(){

  local APK = $(yad --title "Escolha do APK para" --file-selection \
  -- center --width=800 \
  --file --multiple --file-filter="APK | *.apk"
  -- text="Selecione qual APK deseja desinstalar " \
  --image="/usr/share/pixmaps/avd-launcher/avd-install-apk.png" \
  );

  return APK;
}

selectDirectory(){

  local Origem=$(yad --file \
  --directory \
  --title="Selecione o diretório do APK que deseja desinstalar" \
  --width="500" \
  --height="600");

  adbDeviceName = $("$Origem" | grep emulator | xargs echo | cut -d' ' -f1`);
}
