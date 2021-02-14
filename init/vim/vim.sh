#!/usr/bin/env bash
# @Author: Seaky
# @Date:   2019-06-27 10:28:19
# @Last Modified by:   Seaky
# @Last Modified time: 2020-06-15 14:11:49

# bash <(wget --no-check-certificate -O - ${GITHUB_MIRROR:-github.com}/sseaky/deploy/raw/master/init/vim/vim.sh) -p

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

show_banner Set VIM

check_pkg vim
check_pkg git


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

export SERVER="${GITHUB_MIRROR}/sseaky/deploy/raw/master/init/vim"

# common install
web_get ~/.vimrc $SERVER/vimrc_common
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
        git clone ${GITHUB_MIRROR}/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    web_get ~/.vimrc_vundle $SERVER/vimrc_vundle
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


