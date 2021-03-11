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

[ $INIT_DEBUG ] && X="-x" || X=""

for module in $*; do
    case $module in
        aliyun)
            bash $X <(web_get - ${GITHUB_MIRROR}/sseaky/deploy/raw/master/init/source/aliyun.sh)
            ;;
        vim)
            bash $X <(web_get - ${GITHUB_MIRROR}/sseaky/deploy/raw/master/init/vim/vim.sh)
            ;;
        zsh)
            bash $X <(web_get - ${GITHUB_MIRROR}/sseaky/deploy/raw/master/init/zsh/zsh_inst.sh)
            ;;
        bashit)
            bash $X <(web_get - ${GITHUB_MIRROR}/sseaky/deploy/raw/master/init/bash/bashit.sh)
            ;;
        tmux)
            bash $X <(web_get - ${GITHUB_MIRROR}/sseaky/deploy/raw/master/init/tmux/tmux.sh)
            ;;
        pyenv)
            bash $X <(web_get - ${GITHUB_MIRROR}/sseaky/deploy/raw/master/init/pyenv/pyenv.sh)
            ;;
        npc)
            bash $X <(web_get - ${GITHUB_MIRROR}/sseaky/deploy/raw/master/init/npc/npc_install.sh)
            ;;
        frp)
            bash $X <(web_get - ${GITHUB_MIRROR}/sseaky/frp-onekey/raw/main/frp_onekey.sh)
            ;;
        *)
            echo $x is illegal
            ;;
    esac
done
