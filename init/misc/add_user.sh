#!/usr/bin/env bash
# @Author: Seaky
# @Date:   2020/11/26 10:40
# @Description:  Add user/add pub key/set sudo/set .vimrc

# sudo bash add_user.sh -u <new_user> [-d] [-s]

VERSION=20210210

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


encrypt(){
    show_info "Input PUBLIC KEY for crypt: "
    read pubkey_plain
    show_info "Input PASSWORD 1st time: "
    read -s password1
    show_info "Input PASSWORD 2nd time: "
    read -s password2
    [ "$password1" != "$password2" ] && show_error "passwords are not match" && exit 1
    password=`echo $password1 | md5sum | awk '{print $1}'`
    # ubuntu18.04使用openssl1.1.1下
    # echo $pubkey_plain | openssl enc -a -e -aes-256-cbc -pbkdf2 -iter 100000 -k $password
    [ $(openssl version | grep -oh 'OpenSSL 1\.\S*' | cut -d" " -f 2 | cut -d"." -f2) -ge 1 ] && _param="-pbkdf2 -iter 100000" || _param=""
    echo $pubkey_plain | openssl enc -a -e -aes-256-cbc $_param -k $password
    exit
}

decrypt(){
    _password=`echo $1 | md5sum | awk '{print $1}'`
    [ $(openssl version | grep -oh 'OpenSSL 1\.\S*' | cut -d" " -f 2 | cut -d"." -f2) -ge 1 ] && _param="-pbkdf2 -iter 100000" || _param=""
    result=`echo $2 | openssl enc -a -d -aes-256-cbc $_param -k $_password`
    if [ $? -ne 0 ]
    then
        exit 1
    fi
    echo $result
}


check_param(){
    [ -z "${_USER}" ] && show_usage
}

get_pubkey(){
    show_info "Get public key"
    # [ KEY_FROM="cipher" -a -n "${CIPHER_PUB}" ] && KEY_FROM='cipher' || KEY_FROM="stdin"
    if [ "${KEY_FROM}" = "stdin" ]
    then
        show_info "Please paste PUBLIC KEY of $_USER below "
        read k_type k_body k_comment
    elif [ "${KEY_FROM}" = "cipher" ]
    then
        show_info "Use pre crypto public key, please input PASSWORD for decrypt: "
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
        show_info "Create ${DIR_SSH}/authorized_keys"
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
        show_info "Append public key"
        echo $PUBKEY >> ${DIR_SSH}/authorized_keys
    fi
}

_adduser(){
    if `id ${_USER} >> /dev/null 2>&1`
    then
        show_warn "User ${_USER} is exist"
    else
        show_info "Start add user ${_USER}"
        useradd ${_USER} -s /bin/bash -m
        usermod -U ${_USER} >> /dev/null 2>&1
        usermod -p '*' ${_USER}
    fi
    USER_HOME=`eval echo "~${_USER}"`
    DIR_SSH="${USER_HOME}/.ssh"
}

set_sudo(){
    show_info "Grant sudo privilege for user ${_USER}"
    if [ -d "/etc/sudoers.d/" ]
    then
        echo "${_USER} ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/${_USER}
    fi
}

#set_vim(){
#    if `grep -q "syntax on" ${USER_HOME}/.vimrc >> /dev/null 2>&1`
#    then
#        show_warn ".vimrc is stuffed"
#    else
#        show_info "Set .vimrc"
#        cat >> ${USER_HOME}/.vimrc << EOF
#syntax on
#set tabstop=4
#set softtabstop=4
#set shiftwidth=4
#set expandtab
#set cursorline
#EOF
#    fi
#}

show_hint(){
    if [ $USE_PWD ]; then
        show_info "Need to set password for $_USER, random string: `head -c 32 /dev/urandom | base64 | cut -b 1-12`"
        echo "    sudo passwd $_USER"
        echo
    fi
    show_info "For further setup"
    echo "    sudo su - ${_USER}"
    echo "    bash <(wget --no-check-certificate -qO - ${GITHUB_MIRROR}/sseaky/deploy/raw/master/init/init_user.sh)"
}


show_usage(){
    echo "Usage:  sudo bash add_user.sh -u <new_user> [-d] [-s]"
    echo "    -u <new_user>"
    echo "    -p, use password"
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
CIPHER_PUB_1_0="
U2FsdGVkX1+7hmdKPKJQ0olobZUYk44CZ7ZQwx2fkh34uynJclnODzRU6y5XuxeP
EXIRZuwByrv3ICglCWu65nlOUGZ9LUkYC+amuVo58zgunHWG5cU+IB2pju3dfXLX
tmP8WBQztL5aJ2PHTQkoy5GvzV42U4MnN4gt5TrvgfaHRbS2MnlSVtnMGg2pszfN
K1jOLFox+4frW03roqsP9Q0iiqyQ6si7sCte9ATin0I2zMjIvmOB4pO+egtyI1mR
lwGffcvywQcOool9+pZA/nnl42s4XQUFR7JikJZEnlJnmvdJiMoG5Kwq6TPsr+wh
"

CIPHER_PUB_1_1="
U2FsdGVkX18n3z3OPUigcjmIrFx6Ia5x5VjViMUNGTMMGsfx2E6JNIVDpct0y5SU
HbTO0B1lxmdjrQgb+88/Wr7MJTSMAmxxWLR9DTqnag0vn6eYCiM9LdJb6N10qlMB
wKMXBVJx6T9p8iY5wNe3/pPp2l0hmgiAFMWaVCU1z8d6UER3rxJfX9BAIW1Ouiui
I7Mu29Y+M3sPlbZJ0PqD/aDeOV+zaLXUjtLK9043XwFOEVD+a9CBJzsefR8Q4vWr
I2pBbmysS3aAuGeIzeaOtx+BaQ3O6lckoQi0Bl6LLs0RAdkq3a1baDE/QX3LZ/7a
"

[ $(openssl version | grep -oh 'OpenSSL 1\.\S*' | cut -d" " -f 2 | cut -d"." -f2) -ge 1 ] && CIPHER_PUB=$CIPHER_PUB_1_1 || CIPHER_PUB=$CIPHER_PUB_1_0

CIPHER_PUB=`merge_line $CIPHER_PUB`

FLAG_ZSH=false
KEY_FROM="stdin"

while getopts 'u:pcdsm:e' opt
do
    case $opt in
        u) _USER="$OPTARG" ;;
        p) USE_PWD=true ;;
        c) KEY_FROM="stdin" ;;
        d) KEY_FROM="cipher" ;;
        s) FLAG_SET_SUDO=true ;;
        m) COMMENT="$OPTARG" ;;
        e) encrypt ;;
    *)
        show_usage
    esac
done

show_banner Add user $_USER
check_param
_adduser
[ ! $USE_PWD ] && get_pubkey && append_key
[ $FLAG_SET_SUDO ] && [ "$_USER" != "root" ] && set_sudo
#set_vim
show_hint
