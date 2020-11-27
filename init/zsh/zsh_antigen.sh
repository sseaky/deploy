#!/usr/bin/env bash
# @Author: Seaky
# @Date:   2019-06-26 16:41:32
# @Last Modified by:   Seaky
# @Last Modified time: 2020-06-15 14:27:18

# wget --no-proxy -qO - https://github.com/sseaky/deploy/master/init/zsh/zsh_antigen.sh | bash && zsh
# wget --no-proxy -qO - https://github.com/sseaky/deploy/master/init/zsh/zsh_antigen.sh | bash -s -- -w  && zsh
#

read_param(){
    VAR_NAME=$1
    while true
    do
        echo Please input $VAR_NAME:
        read $2 INPUT
        if [ -z "$INPUT" ]
        then
            echo "$VAR_NAME can't be none!"
        else
            eval "VAR_NAME=$INPUT"
            break
        fi
    done
}

decrypt(){
    _password=`echo $PASS | md5sum | awk '{print $1}'`
    echo $TEXT | openssl enc -a -d -aes-256-cbc -k $_password
}

set_wt(){
    if $FLAG_WT
    then
        TEXT='U2FsdGVkX18c6ABXyiA+yti11rlvO1F1EpOV3Q+L/kW2DcHsRgFLmRwh6rTN+5mDZzehB8uFE0AMlPTT5cJqnQ=='
        read_param PASS -s
        [ ! -f ~/.wakatime.cfg ] && cat > ~/.wakatime.cfg <<-EOF
[settings]
debug = false
api_key = $(decrypt)
hostname = $(hostname)
EOF
    fi
}

FLAG_WT=false

while getopts "w" arg
do
    case $arg in
         w)
            FLAG_WT=true
            ;;
         ?)
            echo "unkonw argument"
            exit 1
            ;;
    esac
done

GITHUB_MIRROR=${GITHUB_MIRROR:-github.com}

export SERVER="https://${GITHUB_MIRROR}/sseaky/deploy/raw/master/init/zsh"

sudo apt install -y zsh git

# https://raw.githubusercontent.com/zsh-users/antigen/master/bin/antigen.zsh
wget -O ~/.antigen.zsh git.io/antigen
sed -ir 's#ANTIGEN_INSTALL_DIR/antigen.zsh#ANTIGEN_INSTALL_DIR/.antigen.zsh#' ~/.antigen.zsh

wget -qO ~/.zshrc ${SERVER}/zshrc_antigen
sed -ir "s#/HOME/#${HOME}/#" ~/.zshrc
wget -qO ~/.zsh_alias ${SERVER}/zsh_alias

sudo chsh -s `which zsh` `echo $USER`

set_wt

zsh -c "source ~/.zshrc"