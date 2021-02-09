#!/usr/bin/env bash
# @Author: Seaky
# @Date:   2019-06-27 10:28:19
# @Last Modified by:   Seaky
# @Last Modified time: 2020-06-15 14:11:49

# bash <(wget -qO - https://github.com/sseaky/deploy/raw/master/init/vim/vim.sh) -p

check_install_tool(){
    if [ -n "$(command -v yum)" ];then
        OS="centos"
        AY="yum"
    elif [ -n "$(command -v apt)" ];then
        OS="debian"
        AY="apt"
    fi
    if [ -z "$OS" ]; then
        echo Can not inspect the os system
        exit 1
    fi
}
check_install_tool

while getopts "p" arg
do
    case $arg in
         p)
            install_vundle=true
            ;;
         ?)
        echo "unkonw argument"
    exit 1
    ;;
    esac
done 

GITHUB_MIRROR=${GITHUB_MIRROR:-github.com}
export SERVER="https://${GITHUB_MIRROR}/sseaky/deploy/raw/master/init/vim"

# common install
sudo $AY install -y vim wget git
wget -qO ~/.vimrc $SERVER/vimrc_common

# link vim
vi_path=$(which vi)
if [ -z "$vi_path" ]; then
    sudo ln -s $(which vim) /bin/vi
elif [ ! -L $vi_path ]; then
    echo "bin vi exist, relink vi to vim"
    sudo mv $vi_path ${vi_path}.save
    sudo ln -s $(which vim) $vi_path
fi

# vundle
if [ $install_vundle ]; then
    [[ -d ~/.vim ]] || mkdir .vim
    git clone https://${GITHUB_MIRROR}/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    wget -qO ~/.vimrc_vundle $SERVER/vimrc_vundle
    sed -ir "s#/HOME/#${HOME}/#" ~/.vimrc_vundle
    sed -ir "s/\" source .vimrc_vundle/source .vimrc_vundle/" ~/.vimrc

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


