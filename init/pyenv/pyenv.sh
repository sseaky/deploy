#!/usr/bin/env bash
# @Author: Seaky
# @Date: 2020-08-12 14:58:02

# assure to fetch source file
GITHUB_MIRROR=${GITHUB_MIRROR:-https://github.com}

if [ ! $SK_SOURCE ]; then
    i=${WEB_RETRY:-10}
    while [ $i -gt 0 ]; do
        i=$(( $i - 1 ))
        source <(wget --no-check-certificate -qO - ${GITHUB_MIRROR}/sseaky/deploy/raw/master/init/func.sh)
        [ $SK_SOURCE ] && break
    done
fi
if [ ! $SK_SOURCE ]; then
    echo source faile
    exit 1
fi
#

show_banner Install pyenv

check_pkg gcc

USE_GIT_URI=1 bash <(web_get - ${GITHUB_MIRROR}/sseaky/deploy/raw/master/init/pyenv/pyenv-installer)
if [[ -f $HOME/.zshrc ]]; then
    configfile=$HOME/.zshrc
elif [[ -f $HOME/.bashrc ]]; then
    configfile=$HOME/.bashrc
fi

grep -qE '^eval "\$\(pyenv init -\)"' $configfile || cat >> $configfile << EOF

# pyenv
export PATH=~/.pyenv/bin:\$PATH
eval "\$(pyenv init -)"
eval "\$(pyenv virtualenv-init -)"
EOF

source $configfile

cachedir=~/.pyenv/cache
mkdir $cachedir
[[ -f $cachedir/Python-3.7.2.tar.xz ]] || wget --directory-prefix=$cachedir ${GITHUB_MIRROR}/sseaky/deploy/releases/download/py/Python-3.7.2.tar.xz


$SUDO $INSTALL libssl1.0-dev zlib1g-dev
$SUDO bash -c "$INSTALL zlib* libffi-devel openssl-devel"
$SUDO bash -c "$INSTALL zlib* libffi-dev openssl-devel"


echo '
sudo apt-get install libssl1.0-dev
sudo update-alternatives --install /usr/bin/python python /usr/bin/python2 200
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 100'
