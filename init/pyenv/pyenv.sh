#!/usr/bin/env bash
# @Author: Seaky
# @Date: 2020-08-12 14:58:02

GITHUB_MIRROR=${GITHUB_MIRROR:-github.com}

sudo curl -L https://${GITHUB_MIRROR}/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
if [[ -f $HOME/.zshrc ]]; then
    configfile=$HOME/.zshrc
elif [[ -f $HOME/.bashrc ]]; then
    configfile=$HOME/.bashrc
fi

grep -qE '^eval "\$\(pyenv init -\)"' $configfile || cat >> $configfile << EOF

# pyenv
export PATH="/home/hzshenzheng/.pyenv/bin:\$PATH"
eval "\$(pyenv init -)"
eval "\$(pyenv virtualenv-init -)"
EOF

source $configfile

cachedir=~/.pyenv/cache
mkdir $cachedir
[[ -f $cachedir/Python-3.7.2.tar.xz ]] || wget --directory-prefix=$cachedir https://${GITHUB_MIRROR}/sseaky/deploy/releases/download/py3.7.2/Python-3.7.2.tar.xz


sudo apt-get install libssl1.0-dev zlib1g-dev


echo '
sudo apt-get install libssl1.0-dev
sudo update-alternatives --install /usr/bin/python python /usr/bin/python2 200
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 100'
