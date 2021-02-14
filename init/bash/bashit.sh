# @Author: Seaky
# @Date:   2020-06-12 17:53:48
# @Last Modified by:   Seaky
# @Last Modified time: 2020-06-15 14:27:49
#
# bash <(wget --no-check-certificate -O - https://${GITHUB_MIRROR:-github.com}/sseaky/deploy/raw/master/init/bash/bashit.sh)

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

show_banner Bash-it

check_pkg git

git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
~/.bash_it/install.sh 

sed -ir 's/bobby/pure/' ~/.bashrc

echo "run source ~/.bashrc"
