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

VERSION="1.0.3"
echo "$VERSION";