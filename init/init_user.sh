#!/usr/bin/env bash
# @Author: Seaky
# @Date:   2020/11/26 22:49

GITHUB_MIRROR=${GITHUB_MIRROR:-github.com}
GITHUB_RETRY=10

if [ ! $SK_SOURCE ]; then
    i=$GITHUB_RETRY
    while [ $i -gt 0 ]; do
        i=$(( $i - 1 ))
        source <(wget --no-check-certificate -O - https://${GITHUB_MIRROR}/sseaky/deploy/raw/master/init/func.sh)
        [ $sk_SOURCE ] && break
    done
fi
if [ ! $SK_SOURCE ]; then
    echo source faile
    exit 1
fi

for x in $*; do
    case $x in
        aliyun)
            bash <(github_retry - https://${GITHUB_MIRROR}/sseaky/deploy/raw/master/init/source/aliyun.sh)
            ;;
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
