# @Author: Seaky
# @Date:   2019-06-27 10:28:19
# @Last Modified by:   Seaky
# @Last Modified time: 2020-06-08 15:32:06

# wget -qO - https://raw.githubusercontent.com/sseaky/common/master/init/vim.sh | bash

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


export SERVER="https://raw.githubusercontent.com/sseaky/common/master/init"

# sudo apt install -y vim-nox
# :echo has('python') || has('python3')
[[ -d ~/.vim ]] || mkdir .vim

wget -qO ~/.vimrc $SERVER/vimrc
sed -ir "s#/HOME/#${HOME}/#" ~/.vimrc

if [ $server_mode ];then
    echo "server mode"
else
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
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


