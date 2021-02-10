#!/usr/bin/env bash
# @Author: Seaky
# @Date:   2020/11/26 22:49

GITHUB_MIRROR=${GITHUB_MIRROR:-github.com}
[ $SK_SOURCE ] || source <(https://${GITHUB_MIRROR}/sseaky/deploy/raw/master/init/func.sh)

GITHUB_RETRY=10

for x in $*; do
    case $x in
        vim)
            bash <(github_retry - https://${GITHUB_MIRROR}/sseaky/deploy/raw/master/init/vim/vim.sh)
            ;;
        bashit)
            bash <(github_retry - https://${GITHUB_MIRROR:-github.com}/sseaky/deploy/raw/master/init/bash/bashit.sh)
            ;;
        aliyun)
            bash <(github_retry - https://${GITHUB_MIRROR:-github.com}/sseaky/deploy/raw/master/init/source/aliyun.sh)
            ;;
        *)
            echo $x is illegal
            ;;
    esac
done