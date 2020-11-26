#!/usr/bin/env bash
# @Author: Seaky
# @Date:   2020/11/26 10:40
# @Description:  Add user/add pub key/set sudo/set .vimrc

# sudo bash add_user.sh -u <new_user> [-d] [-s]

VERSION=202011

set_text_color(){
    COLOR_RED='\E[1;31m'
    COLOR_GREEN='\E[1;32m'
    COLOR_YELLOW='\E[1;33m'
    COLOR_BLUE='\E[1;34m'
    COLOR_PINK='\E[1;35m'
    COLOR_PINKBACK_WHITEFONT='\033[45;37m'
    COLOR_GREEN_LIGHTNING='\033[32m \033[05m'
    COLOR_END='\E[0m'
}

show_process(){
    echo -e "${COLOR_GREEN}- INFO: $1${COLOR_END}"
}

show_error(){
    echo -e "${COLOR_RED}! ERROR: $1${COLOR_END}"
}

show_warn(){
    echo -e "${COLOR_YELLOW}* WARN: $1${COLOR_END}"
}

merge_line(){
    echo $* | tr -d "[:space:]"
}

encrypt(){
    show_process "Input PUBLIC KEY for crypt: "
    read pubkey_plain
    show_process "Input PASSWORD 1st time: "
    read -s password1
    show_process "Input PASSWORD 2nd time: "
    read -s password2
    [ "$password1" != "$password2" ] && show_error "passwords are not match" && exit 1
    password=`echo $password1 | md5sum | awk '{print $1}'`
    echo $pubkey_plain | openssl enc -a -e -aes-256-cbc -k $password
    exit
}

decrypt(){
    _password=`echo $1 | md5sum | awk '{print $1}'`
    result=`echo $2 | openssl enc -a -d -aes-256-cbc -k $_password`
    if [ $? -ne 0 ]
    then
        exit 1
    fi
    echo $result
}

check_root(){
    if [ "$EUID" -ne 0 ]; then
        show_error "This script must be run as root!" 1>&2
        exit 1
    fi
}

check_param(){
    [ -z "${_USER}" ] && show_usage
}

get_pubkey(){
    show_process "Get public key"
    [ -z "${CIPHER_PUB}" ] && KEY_FROM="stdin"
    if [ "${KEY_FROM}" = "stdin" ]
    then
        show_process "Please paste PUBLIC KEY of $_USER below "
        read k_type k_body k_comment
    elif [ "${KEY_FROM}" = "cipher" ]
    then
        show_process "Use pre crypto public key, please input PASSWORD for decrypt: "
        read -s password
        result=`decrypt $password ${CIPHER_PUB}`
        if [ "$?" -ne 0 ]
        then
            show_error "Decrypt fail" && exit 1
        else
            read k_type k_body k_comment <<< $result
        fi
    fi
    [ -z "$k_comment" ] && k_comment=${COMMENT}
    PUBKEY="$k_type $k_body $k_comment"
}

append_key(){
    if [ ! -d "${DIR_SSH}" ]
    then
        show_process "Create ${DIR_SSH}/authorized_keys"
        mkdir -p ${DIR_SSH}
        touch ${DIR_SSH}/authorized_keys
        chown -R ${_USER}:${_USER} ${DIR_SSH}
        chmod 700 ${DIR_SSH}
        chmod 600 ${DIR_SSH}/authorized_keys
    fi
    if `grep -q "$k_body" ${DIR_SSH}/authorized_keys >> /dev/null 2>&1`
    then
        show_warn "Public key is exist"
    else
        show_process "Append public key"
        echo $PUBKEY >> ${DIR_SSH}/authorized_keys
    fi
}

_adduser(){
    if `id ${_USER} >> /dev/null 2>&1`
    then
        show_warn "User ${_USER} is exist"
    else
        show_process "Start add user ${_USER}"
        useradd ${_USER} -s /bin/bash -m
        usermod -U ${_USER} >> /dev/null 2>&1
        usermod -p '*' ${_USER}
    fi
    DIR_HOME=`eval echo "~${_USER}"`
    DIR_SSH="${DIR_HOME}/.ssh"
}

set_sudo(){
    show_process "Grant sudo privilege for user ${_USER}"
    if [ -d "/etc/sudoers.d/" ]
    then
        echo "${_USER} ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/${_USER}
    fi
}

set_vim(){
    if `grep -q "syntax on" ${DIR_HOME}/.vimrc >> /dev/null 2>&1`
    then
        show_warn ".vimrc is stuffed"
    else
        show_process "Set .vimrc"
        cat >> ${DIR_HOME}/.vimrc << EOF
syntax on
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set cursorline
EOF
    fi
}

show_usage(){
    echo "Usage:  sudo bash add_user.sh -u <new_user> [-d] [-s]"
    echo "    -u <new_user>"
    echo "    -c, read public key from stdin"
    echo "    -d, read public key from cipher in script"
    echo "    -s, set sudo privilege"
    echo "    -m <comment>, public key comment"
    echo "    -e, encrypt public key"
    exit
}

# main

set_text_color

# seaky_rsa_openssh
CIPHER_PUB="
U2FsdGVkX19QHMMDWg/hy8xWFUxqErcTpRNj/8oSRXZMkyQlCE5m5pZhQEGXzG3W
JdDYo/kCC4XqX+GN2X4qPnyEH2QUlPoCCm5oEmFpK45o5MBytBLBbh52CQIKdx93
Lkerc73nHfxYnx5Vu/mzdFIkhscNbMwr/LwsodMuwpll92rfJTubn4+GrAaF9M3a
6+uYCAGsb6rHKXScz21xkmwHSMS2WMIjBvY7lDjkZRH/5PGswQ+y9I/hf7J8wRI6
uD0lnz8Xe37Qo5/YpTaLo1sBNwcx1wrgCiNE3eh3TLpLcbXORxF3CGC8Btra95Xv
"
CIPHER_PUB=`merge_line $CIPHER_PUB`

FLAG_SET_SUDO=false
KEY_FROM="stdin"

while getopts 'u:cdsm:e' opt
do
    case $opt in
    u) _USER="$OPTARG" ;;
    c) KEY_FROM="stdin" ;;
    d) KEY_FROM="cipher" ;;
    s) FLAG_SET_SUDO=true ;;
    m) COMMENT="$OPTARG" ;;
    e) encrypt ;;
    *)
        show_usage
    esac
done

eval echo "~${_USER}"

check_root
check_param
get_pubkey
_adduser
append_key
$FLAG_SET_SUDO && [ "$_USER" != "root" ] && set_sudo
set_vim

