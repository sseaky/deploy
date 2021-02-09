#!/usr/bin/env bash
# @Author: Seaky
# @Date:   2019-06-27 10:28:19
# @Last Modified by:   Seaky
# @Last Modified time: 2020-06-15 14:11:49

# bash <(wget --no-check-certificate -O - https://${GITHUB_MIRROR:-github.com}/sseaky/deploy/raw/master/init/vim/vim.sh) -p

GITHUB_MIRROR=${GITHUB_MIRROR:-github.com}

wgetx='wget --no-check-certificate '

github_retry(){
    i=${WGET_RETRY:-5}
    while [ $i -gt 0 ]
    do
        i=$(( $i - 1 ))
        $wgetx -O $1 $2
        [ $? -eq 0 ] && break
    done
}

check_install_tool(){
    if [ -n "$(command -v yum)" ];then
        OS="centos"
        INSTALL="yum install -y "
    elif [ -n "$(command -v apt)" ];then
        OS="debian"
        INSTALL="apt install -y "
    fi
    if [ -z "$OS" ]; then
        echo Can not inspect the os system
        exit 1
    fi
}
check_install_tool

check_sudo(){
    if [ $UID -eq 0 ]; then
        IS_ROOT=true
        SUDO=""
    else
        IS_ROOT=false
        [ -n "$(command -v sudo)" ] || $INSTALL sudo
        SUDO="sudo "
    fi
}
check_sudo

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

export SERVER="https://${GITHUB_MIRROR}/sseaky/deploy/raw/master/init/vim"

# common install
$SUDO $INSTALL vim wget git
github_retry ~/.vimrc $SERVER/vimrc_common
if [ ! -s ~/.vimrc ]; then
    echo "~/.vimrc is not valid"
    exit 1
fi

# link vim
vi_path=$(which vi)
if [ -z "$vi_path" ]; then
    $SUDO ln -s $(which vim) /bin/vi
elif [ ! -L $vi_path ]; then
    echo "$vi_path is a bin file, relink vi to vim"
    $SUDO mv $vi_path ${vi_path}.save
    $SUDO ln -s $(which vim) $vi_path
fi

# vundle
if [ $install_vundle ]; then
    [[ -d ~/.vim ]] || mkdir .vim
    [ -d ~/.vim/bundle/Vundle.vim ] && echo "~/.vim/bundle/Vundle.vim is exist" || \
        git clone https://${GITHUB_MIRROR}/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    github_retry ~/.vimrc_vundle $SERVER/vimrc_vundle
    if [ ! -s ~/.vimrc_vundle ]; then
        echo "~/.vimrc_vundle is not valid"
        exit 1
    fi
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


