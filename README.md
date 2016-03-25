[**Português**](#português) | [**English**](#english)

![AVD Launcher](./avd-launcher/usr/share/icons/hicolor/48x48/apps/android.png) AVD Launcher
=====================================================================================================

[![Stories in Backlog](https://img.shields.io/github/issues-raw/gustavosotnas/avd-launcher.svg?label=backlog&style=plastic)](https://waffle.io/gustavosotnas/avd-launcher)
[![Stories in Ready](https://badge.waffle.io/gustavosotnas/avd-launcher.png?label=ready&title=ready)](https://waffle.io/gustavosotnas/avd-launcher)
[![GitHub license](https://img.shields.io/github/license/gustavosotnas/avd-launcher.svg?style=plastic)](https://github.com/gustavosotnas/avd-launcher/blob/master/COPYING)
[![GitHub release](https://img.shields.io/github/release/gustavosotnas/avd-launcher.svg?label=stable&style=plastic)](https://github.com/gustavosotnas/avd-launcher/releases/latest)
[![GitHub tag](https://img.shields.io/github/tag/gustavosotnas/avd-launcher.svg?label=development&style=plastic)](https://github.com/gustavosotnas/avd-launcher/releases)

Português
--------------------------
**AVD Launcher** é um *front-end* para o emulador de Dispositivos Virtuais Android (AVDs) da Google. Feito em [Bash](https://www.gnu.org/software/bash), a ferramenta permite executar o emulador do *Android SDK* sem abrir o *Android Studio* e sem usar linha de comando (*terminal*).

### *Screenshots*

![0.Init-FirstTime](../../wiki/assets/screenshots/0.Init-FirstTime.png) <br>
*Janela de definição da pasta do Android SDK (aparece apenas na primeira vez)*

![1.Init-FirstTime-AVDfolder-Error](../../wiki/assets/screenshots/1.Init-FirstTime-AVDfolder-Error.png) <br>
*Janela de erro na detecção automática dos AVDs no sistema (aparece apenas na primeira vez)*

![2.SelectAVD](../../wiki/assets/screenshots/2.SelectAVD.png) <br>
*Menu de seleção do AVD desejado para executar*

![3.LoadingAVD](../../wiki/assets/screenshots/3.LoadingAVD.png) <br>
*Janela de carregamento do AVD*

![4.AVD-menu](../../wiki/assets/screenshots/4.AVD-menu.png) <br>
*Menu exibido durante a execução do AVD* *[(a implementar)](https://github.com/gustavosotnas/avd-launcher/issues/8)*

![5.About](../../wiki/assets/screenshots/5.About.png) <br>
*Janela "Sobre", com informações do programa e sua versão.*

### Licença
**AVD Launcher** é distribuído sob os termos da [GNU General Public License](http://www.gnu.org/licenses/), versão 2 ou posterior. Consulte o arquivo [COPYING](./COPYING) para mais detalhes.

### Download e instalação
**AVD Launcher** está disponível como um pacote *.deb* instalável para sistemas baseados no ***Debian*** (*Ubuntu, Mint, Elementary OS, Deepin, Kali, Tails,* etc.). No entanto é compatível com todas as principais distribuições Linux existentes.

Para baixar o pacote *.deb*, vá para a seção [***releases***](https://github.com/gustavosotnas/avd-launcher/releases/latest) e baixe a última versão do mesmo. Instale com um **instalador de pacotes** como [GDebi](https://apps.ubuntu.com/cat/applications/gdebi/) ou digite o seguinte comando em um Terminal (na pasta onde está o arquivo baixado):

`sudo dpkg -i avd-launcher_ver.si.on_all.deb` <br>
(substitua `ver.si.on` pelo número da versão do aplicativo baixada)

#### Dependências
 * [**yad**](http://www.webupd8.org/2010/12/yad-zenity-on-steroids-display.html), que **deve estar instalado antes** para o aplicativo funcionar corretamente.

Para instalar o **yad** em um sistema GNU/Linux via terminal digite os seguintes comandos:

```sh
sudo add-apt-repository ppa:webupd8team/y-ppa-manager
sudo apt-get update
sudo apt-get install yad
```

<!--[**GDebi**](https://apps.ubuntu.com/cat/applications/gdebi/) instala [**yad**](http://www.webupd8.org/2010/12/yad-zenity-on-steroids-display.html) se ele não estiver instalado.-->

Em breve **AVD Launcher** estará disponível em um repositório PPA com uma cópia do [**yad**](http://www.webupd8.org/2010/12/yad-zenity-on-steroids-display.html), a fim de facilitar a instalação desta dependência.

### Bug tracker
Encontrou um bug? Quer sugerir uma nova funcionalidade ou melhoria? Informe-nos [aqui](https://github.com/gustavosotnas/avd-launcher/issues) no GitHub!

### Autor
 * Gustavo Moraes - <gustavosotnas1@gmail.com>

### Pull Request
Contribuidores são bem vindos! [Issues - gustavosotnas/avd-launcher](https://github.com/gustavosotnas/avd-launcher/issues)

English
--------------------------

**AVD Launcher** is a *front-end* to the Android Virtual Devices (AVDs) emulator from Google. Written in [Bash](https://www.gnu.org/software/bash), the tool allows you to run *Android SDK* emulator without opening *Android Studio* and without using command-line interface (*terminal*).

### License
**AVD Launcher** is distributed under the terms of the [GNU General Public License](http://www.gnu.org/licenses/), version 2 or later. See the COPYING file for details.

### Download and installation
**AVD Launcher** is available as an installable *.deb* package for Debian-based systems (*Ubuntu, Mint, Elementary OS, Deepin, Kali, Tails,* etc). However it is compatible with all major existing Linux distributions.

To download the *.deb* package, go to [***releases***](https://github.com/gustavosotnas/avd-launcher/releases/latest) section and download the latest version of it. Install with a **package installer** like [GDebi](https://apps.ubuntu.com/cat/applications/gdebi/) or enter the following command in a Terminal (in the folder where is the downloaded file):

`sudo dpkg -i avd-launcher_ver.si.on_all.deb` <br>
(replace `ver.si.on` with the downloaded application version number)

#### Dependencies
 * [**yad**](http://www.webupd8.org/2010/12/yad-zenity-on-steroids-display.html), which **must be installed before** to the application work correctly.

To install **yad** in a GNU/Linux system by terminal type the following commands:

```sh
sudo add-apt-repository ppa:webupd8team/y-ppa-manager
sudo apt-get update
sudo apt-get install yad
```

<!--[**GDebi**](https://apps.ubuntu.com/cat/applications/gdebi/) installs [**yad**](http://www.webupd8.org/2010/12/yad-zenity-on-steroids-display.html) if it doesn't installed.-->

Soon **AVD Launcher** will be available in a PPA repository with a copy of [**yad**](http://www.webupd8.org/2010/12/yad-zenity-on-steroids-display.html), in order to facilitate the installation of this dependence.

### Bug tracker
Found a bug? Want to suggest a new feature or improvement? Let us know [here](https://github.com/gustavosotnas/avd-launcher/issues) on GitHub!

### Author
 * Gustavo Moraes - <gustavosotnas1@gmail.com>

### Pull Request
Contributors are welcome! [Issues - gustavosotnas/avd-launcher](https://github.com/gustavosotnas/avd-launcher/issues)
