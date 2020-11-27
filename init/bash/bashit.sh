# @Author: Seaky
# @Date:   2020-06-12 17:53:48
# @Last Modified by:   Seaky
# @Last Modified time: 2020-06-15 14:27:49
# 
# wget -O - https://github.com/sseaky/deploy/master/init/bash/bashit.sh | bash

GITHUB_MIRROR=${GITHUB_MIRROR:-github.com}

git clone --depth=1 https://${GITHUB_MIRROR}/Bash-it/bash-it.git ~/.bash_it
~/.bash_it/install.sh 

sed -ir 's/bobby/pure/' ~/.bashrc
