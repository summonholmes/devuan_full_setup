#!/bin/sh

### Install correct video and input drivers
/usr/bin/apt-get -t ascii-backports install libpolkit-backend-elogind-1-0 -y
/usr/bin/apt-get -t ascii-backports install sysv-rc-conf -y
/usr/bin/apt-get -t ascii-backports install intel-microcode -y
/usr/bin/apt-get -t ascii-backports install xserver-xorg-input-libinput -y
/usr/bin/apt-get -t ascii-backports install xserver-xorg-video-intel -y
/usr/bin/apt-get -t ascii-backports installxserver-xorg-input-wacom -y 
/bin/echo "#!/bin/sh" > /etc/init.d/isdv4
/bin/echo "/usr/bin/isdv4-serial-inputattach /dev/ttyS0 > /dev/null 2>&1 &" >> /etc/init.d/isdv4
/bin/chmod +x /etc/init.d/isdv4

### Install fonts
/usr/bin/apt-get -t ascii-backports install powerline fonts-firacode fonts-roboto fonts-liberation -y

## Install plugins
/usr/bin/apt-get -t ascii-backports install zip unzip unrar p7zip gstreamer-plugins-1.0-{good,bad,ugly} zsh build-essential git curl dirmngr screenfetch -y

### Fully install KDE
/usr/bin/apt-get -t ascii-backports install plasma-desktop plasma-nm sddm sddm-theme-breeze network-manager-openvpn kio-mtp plasma-applet-redshift-control -y

### More KDE apps
/usr/bin/apt-get -t ascii-backports install dolphin konsole kmail kate amarok gwenview ark kde-spectacle okular -y

### Install Devuan-native apps
/usr/bin/apt-get -t ascii-backports install libreoffice libreoffice-kde smplayer smplayer-themes keepassx transmission-qt imagemagick -y
/usr/bin/dpkg --add-architecture i386
/usr/bin/apt-get update
/usr/bin/apt-get -t ascii-backports steam wine -y
# /usr/bin/apt-get -t ascii-backports qemu virt-manager -y
/usr/bin/apt-get -t ascii-backports tlp tp-smapi-dkms -y

### Install Latest Firefox
cd /tmp
/usr/bin/wget -O FirefoxSetup.tar.bz2 "https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=en-US"
/bin/tar jxvf FirefoxSetup.tar.bz2
/bin/mv firefox /opt/firefox
/bin/echo "[Desktop Entry]
Version=1.0
Name=Firefox
GenericName=Web Browser
Exec=/opt/firefox/firefox %u
Icon=firefox
Terminal=false
Type=Application
MimeType=text/html;text/xml;application/xhtml+xml;application/vnd.mozilla.xul+xml;text/mml;x-scheme-handler/http;x-scheme-handler/https;
StartupNotify=true
Categories=Network;WebBrowser;
Keywords=web;browser;internet;
Actions=new-window;new-private-window;
[Desktop Action new-window]
Name=New Window
Exec=/opt/firefox/firefox --new-window %u
[Desktop Action new-private-window]
Name=New Private Window
Exec=/opt/firefox/firefox --private-window %u" > /usr/share/applications/firefox.desktop

### Install Papirus Icon theme & Adapta KDE
/bin/echo 'deb http://ppa.launchpad.net/papirus/papirus/ubuntu xenial main' > /etc/apt/sources.list.d/papirus-ppa.list
/usr/bin/apt-key adv --recv-keys --keyserver keyserver.ubuntu.com E58A9D36647CAE7F
/usr/bin/apt-get update
/usr/bin/apt-get -t ascii-backports install papirus-icon-theme adapta-kde -y
/usr/bin/git clone https://github.com/mustafaozhan/Breeze-Adapta.git && cd Breeze-Adapta && chmod +x install.sh && sh install.sh
/usr/bin/wget -O adapta-gtk.deb "https://launchpad.net/~tista/+archive/ubuntu/adapta/+build/14213155/+files/adapta-gtk-theme_3.93.0.11-0ubuntu1~xenial1_all.deb"
/usr/bin/dpkg -i adapta-gtk.deb
/usr/bin/apt-get -t ascii-backports install -f -y

### Install Miniconda
cd /home/summonholmes
# Let user install later
/usr/bin/wget -O miniconda3.sh "https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh"
cd /tmp

### Install Dropbox
/usr/bin/wget -O dropbox.deb "https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2015.10.28_amd64.deb"
/usr/bin/dpkg -i dropbox.deb
/usr/bin/apt-get -t ascii-backports install -f -y

### Post install tasks
/bin/echo "flat-volumes = no" >> /etc/pulse/daemon.conf
/bin/echo "#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "exit 0" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
# By default this script does nothing.
sleep 90
echo `date +\%Y/\%m/\%d` > /var/log/aptdistupgrade.log 2>&1
echo `date +\%I:\%M:\%S` >> /var/log/aptdistupgrade.log 2>&1
apt-get update >> /var/log/aptdistupgrade.log 2>&1
apt-get dist-upgrade -y >> /var/log/aptdistupgrade.log 2>&1
exit 0
" > /etc/rc.local 
/bin/echo "# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
#allow-hotplug eth0
#iface eth0 inet dhcp
# This is an autoconfigured IPv6 interface
#iface eth0 inet6 auto
" > /etc/network/interfaces
 