#!/usr/bin/env bash
# @Author: Seaky
# @Date:   2019-06-26 16:41:32
# @Last Modified by:   Seaky
# @Last Modified time: 2020-06-15 14:27:18

# source <(wget --no-check-certificate -qO - ${GITHUB_MIRROR:-https://github.com}/sseaky/deploy/raw/master/init/zsh/zsh_inst.sh)
#

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

show_banner Install ZSH

export SERVER="${GITHUB_MIRROR}/sseaky/deploy/raw/master/init/zsh"

check_pkg zsh
check_pkg git

web_get ~/.antigen.zsh ${GITHUB_MIRROR}/sseaky/deploy/raw/master/init/zsh/antigen.zsh
sed -ir 's#ANTIGEN_INSTALL_DIR/antigen.zsh#ANTIGEN_INSTALL_DIR/.antigen.zsh#' ~/.antigen.zsh

web_get ~/.zshrc ${SERVER}/zshrc_antigen
sed -ir "s#/HOME/#${HOME}/#" ~/.zshrc
web_get ~/.zsh_alias ${SERVER}/zsh_alias

$SUDO chsh -s `which zsh` `echo $USER`


zsh -c "source ~/.zshrc"