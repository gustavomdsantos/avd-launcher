#! /bin/bash

# "Classe" que controla ações com o Android SDK no AVD Launcher.
#
# Author: Gustavo Moraes <gustavosotnas1@gmail.com>
#
# This file is subject to the terms and conditions of the GNU General Public
# License. See the file COPYING in the main directory of this archive
# for more details.

verifySDKPath()
{

}

verifyAVDPath()
{

}

### MAIN ####

case $1 in
	"verifySDKPath") verifySDKPath;;
	"verifyAVDPath") verifyAVDPath;;
esac;