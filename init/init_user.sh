#!/usr/bin/env bash
# @Author: Seaky
# @Date:   2020/11/26 22:49


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

for x in $*; do
    case $x in
        vim)
            bash <(github_retry - https://${GITHUB_MIRROR}/sseaky/deploy/raw/master/init/vim/vim.sh)
            ;;
        bashit)
            bash <(github_retry - https://${GITHUB_MIRROR}/sseaky/deploy/raw/master/init/bash/bashit.sh)
            ;;
        *)
            echo $x is illegal
            ;;
    esac
done