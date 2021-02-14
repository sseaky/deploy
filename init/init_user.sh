#!/usr/bin/env bash
# @Author: Seaky
# @Date:   2020/11/26 22:49

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

for x in $*; do
    case $x in
        aliyun)
            bash <(web_get - ${GITHUB_MIRROR}/sseaky/deploy/raw/master/init/source/aliyun.sh)
            ;;
        vim)
            bash <(web_get - ${GITHUB_MIRROR}/sseaky/deploy/raw/master/init/vim/vim.sh)
            ;;
        zsh)
            bash <(web_get - ${GITHUB_MIRROR}/sseaky/deploy/raw/master/init/zsh/zsh_inst.sh)
            ;;
        bashit)
            bash <(web_get - ${GITHUB_MIRROR}/sseaky/deploy/raw/master/init/bash/bashit.sh)
            ;;
        tmux)
            bash <(web_get - ${GITHUB_MIRROR}/sseaky/deploy/raw/master/init/tmux/tmux.sh)
            ;;
        pyenv)
            bash <(web_get - ${GITHUB_MIRROR}/sseaky/deploy/raw/master/init/pyenv/pyenv.sh)
            ;;
        *)
            echo $x is illegal
            ;;
    esac
done
