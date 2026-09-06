#!/bin/bash
#
# XUI One-Click Installer
# Maintained by Shahid Malla — https://shahidmalla.com
# Repo: https://github.com/shahidmallaofficial/xui-one-installer
#

REPO="shahidmallaofficial/xui-one-installer"
BRANCH="main"
RELEASE_TAG="v1.5.12"
XUI_ZIP="XUI_1.5.12.zip"

echo -e "\n================================================================"
echo -e " XUI Installer  |  by Shahid Malla  |  shahidmalla.com"
echo -e "================================================================\n"

echo -e "Checking that minimal requirements are ok"

# Ensure the OS is compatible with the launcher
if [ -f /etc/centos-release ]; then
    inst() {
       rpm -q "$1" &> /dev/null
    }
    if (inst "centos-stream-repos"); then
    OS="CentOS-Stream"
    else
    OS="CentOs"
    fi
    VERFULL="$(sed 's/^.*release //;s/ (Fin.*$//' /etc/centos-release)"
    VER="${VERFULL:0:1}" # return 6, 7 or 8
elif [ -f /etc/fedora-release ]; then
    inst() {
       rpm -q "$1" &> /dev/null
    }
    OS="Fedora"
    VERFULL="$(sed 's/^.*release //;s/ (Fin.*$//' /etc/fedora-release)"
    VER="${VERFULL:0:2}" # return 34, 35 or 36
elif [ -f /etc/lsb-release ]; then
    OS="$(grep DISTRIB_ID /etc/lsb-release | sed 's/^.*=//')"
    VER="$(grep DISTRIB_RELEASE /etc/lsb-release | sed 's/^.*=//')"
elif [ -f /etc/os-release ]; then
    OS="$(grep -w ID /etc/os-release | sed 's/^.*=//')"
    VER="$(grep -w VERSION_ID /etc/os-release | sed 's/^.*=//')"
 else
    OS="$(uname -s)"
    VER="$(uname -r)"
fi
ARCH=$(uname -m)
echo "Detected : $OS  $VER  $ARCH"
if [[ "$OS" = "Ubuntu" && ( "$VER" = "20.04" || "$VER" = "22.04" || "$VER" = "24.04" ) && "$ARCH" == "x86_64" ]] ; then
echo "Ok."
else
    echo "Sorry, this OS is not supported by Xtream UI use online Ubuntu LTS Version."
    echo "Use online actual Ubuntu LTS Version 20.04 22.04 or 24.04."
    exit 1
fi

echo -e "\nInstalling dependencies..."
sudo DEBIAN_FRONTEND=noninteractive apt-get update >/dev/null 2>&1
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install python python-dev unzip >/dev/null 2>&1
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install python2 python2-dev unzip >/dev/null 2>&1
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install python2.7 python2.7-dev unzip >/dev/null 2>&1
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install python2.8 python2.8-dev unzip >/dev/null 2>&1
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install python3 python3-dev unzip wget >/dev/null 2>&1

cd /root || exit 1

echo -e "\nDownloading XUI ($XUI_ZIP) ..."
wget --no-verbose "https://github.com/${REPO}/releases/download/${RELEASE_TAG}/${XUI_ZIP}" -O "$XUI_ZIP"
if [ ! -s "$XUI_ZIP" ]; then
    echo "Download failed: could not fetch $XUI_ZIP from the release. Aborting."
    exit 1
fi

echo -e "\nExtracting XUI ..."
unzip -o "$XUI_ZIP" >/dev/null 2>&1 # install xui 1.5.12 & unzip it in the root folder.

echo -e "\nFetching installer script ..."
wget --no-verbose "https://raw.githubusercontent.com/${REPO}/${BRANCH}/install.python3.py" -O /root/install.python3.py
if [ ! -s /root/install.python3.py ]; then
    echo "Download failed: could not fetch install.python3.py. Aborting."
    exit 1
fi

python3 /root/install.python3.py # run the XUI setup script

echo -e "\n================================================================"
echo -e " Installation script finished."
echo -e " Support & guides: https://shahidmalla.com"
echo -e "================================================================\n"
