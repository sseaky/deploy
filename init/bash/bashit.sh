# @Author: Seaky
# @Date:   2020-06-12 17:53:48
# @Last Modified by:   Seaky
# @Last Modified time: 2020-06-15 14:27:49
# 
# bash <(wget --no-check-certificate -O - https://${GITHUB_MIRROR:-github.com}/sseaky/deploy/raw/master/init/bash/bashit.sh)


[ $SK_SOURCE ] || source <(wget -q -O - http://192.168.236.100:8888/init/func.sh)
GITHUB_MIRROR=${GITHUB_MIRROR:-github.com}

check_pkg git

git clone --depth=1 https://${GITHUB_MIRROR}/Bash-it/bash-it.git ~/.bash_it
~/.bash_it/install.sh 

sed -ir 's/bobby/pure/' ~/.bashrc

echo "run source ~/.bashrc"
