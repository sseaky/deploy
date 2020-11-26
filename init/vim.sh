# @Author: Seaky
# @Date:   2019-06-27 10:28:19
# @Last Modified by:   Seaky
# @Last Modified time: 2020-06-15 14:11:49

# wget -O - https://raw.githubusercontent.com/sseaky/common/master/init/vim.sh | bash

while getopts "s" arg
do
    case $arg in
         s)
            server_mode=true
            ;;
         ?)
        echo "unkonw argument"
    exit 1
    ;;
    esac
done 

GITHUB_MIRROR=${GITHUB_MIRROR:-github.com}

export SERVER="https://${GITHUB_MIRROR}/sseaky/deploy/raw/master/init"

# sudo apt install -y vim-nox
# :echo has('python') || has('python3')
[[ -d ~/.vim ]] || mkdir .vim

wget -qO ~/.vimrc $SERVER/vimrc
sed -ir "s#/HOME/#${HOME}/#" ~/.vimrc

if [ $server_mode ];then
    echo "server mode"
else
    git clone https://${GITHUB_MIRROR}/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    echo "
    Install
        Launch vim and run :PluginInstall
        To install from command line: vim +PluginInstall +qall

    Remove
        Remove Plugin in .vimrc, run :BundleClean

    Other
        BundleUpdate/BundleList/BundleSearch
    "

    vim +PluginInstall +qall
fi


