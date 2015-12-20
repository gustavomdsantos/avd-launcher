#! /bin/bash

# Author: Gustavo Moraes <gustavosotnas1@gmail.com>
#
# This file is subject to the terms and conditions of the GNU General Public
# License. See the file COPYING in the main directory of this archive
# for more details.

# Script para obter o número da versão do AVD Launcher.
#
# Ao invés de escrever o novo número da versão nos arquivos "control", 
# "avd-launcher.sh" e "avd-launcher-helper.sh" toda vez que lançar uma 
# nova versão, referenciando este script nos outros scripts (exceto no "control")
# facilitará a entrega do pacote Deb com o número da versão correto em 
# cada um dos scripts.

if dpkg -s avd-launcher &>/dev/null # Se o pacote "avd-launcher" foi encontrado (stdout e stderr vão para o "Buraco Negro")
then
	VERSION="$(2>/dev/null dpkg -s avd-launcher | grep 'Version' | cut -d':' -f2 | xargs echo)" # stderr vai para o "Buraco Negro"
	echo "$VERSION";
else
	echo "Not installed";
fi
