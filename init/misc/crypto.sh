#!/usr/bin/env bash
# @Author: Seaky
# @Date:   2020/11/27 10:36

merge_line(){
    echo $* | tr -d "[:space:]" | tr -d "\n"
}

encrypt(){
    _password=`echo $PASS | md5sum | awk '{print $1}'`
    merge_line "`echo $TEXT | openssl enc -a -e -aes-256-cbc -k $_password`"
}

decrypt(){
    _password=`echo $PASS | md5sum | awk '{print $1}'`
    echo $TEXT | openssl enc -a -d -aes-256-cbc -k $_password
}

read_param(){
    VAR_NAME=$1
    # $2='-s'
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

MODE='enc'

while getopts 'dp:t:' opt
do
    case $opt in
    d) MODE='den' ;;
    p) PASS="$OPTARG" ;;
    t) TEXT="$OPTARG" ;;
    *) exit 1
    esac
done

[ -z "$PASS" ] && read_param PASS
[ -z "$TEXT" ] && read_param TEXT

[ $MODE = 'enc' ] && encrypt || decrypt



