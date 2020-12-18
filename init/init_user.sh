#!/usr/bin/env bash
# @Author: Seaky
# @Date:   2020/11/26 22:49

choice_mirror(){
    if [ -z "$GITHUB_MIRROR" ]
    then
        SERVER_GITHUB='github.com'
        SERVER_1='github.com.cnpmjs.org'
        SERVER_2='hub.fastgit.org'
        SERVER_3='g.ioiox.com/https://github.com'
        echo
        echo -e "${COLOR_GREEN}Choice server:${COLOR_END}"
        echo "    0: $SERVER_GITHUB (default, may slow)"
        echo "    1: $SERVER_1"
        echo "    2: $SERVER_2"
        echo "    3: $SERVER_3"
        echo    "-------------------------"
        read -e -p "Enter your choice (0, 1, 2, 3 or exit. default [0]): " str_choice_source
        case "${str_choice_source}" in
            0)
                GITHUB_MIRROR=$SERVER_GITHUB
                ;;
            1)
                GITHUB_MIRROR=$SERVER_1
                ;;
            2)
                GITHUB_MIRROR=$SERVER_2
                ;;
            3)
                GITHUB_MIRROR=$SERVER_3
                ;;
            [eE][xX][iI][tT])
                exit 1
                ;;
            *)
                GITHUB_MIRROR=$SERVER_GITHUB
                ;;
        esac
     fi
}

choice_install(){
    while true
    do
        echo
        echo -e "${COLOR_GREEN}Choice Module:${COLOR_END}"
        echo "    1: oh-my-zsh"
        echo "    2: bashit"
        echo "    3: vim"
        echo "    4: tmux"
        echo "    5: antiscan"
        echo "    6: frp"
        echo "    7: npc"
        echo "    8: pyenv"
        echo "-------------------------"
        read -e -p "Enter your choice: " str_choice_source
        case "${str_choice_source}" in
            1)
                bash <(wget -O - https://${GITHUB_MIRROR}/sseaky/deploy/raw/master/init/zsh/zsh_antigen.sh)
                ;;
            2)
                wget -O - https://${GITHUB_MIRROR}/sseaky/deploy/raw/master/init/bash/bashit.sh | bash
                ;;
            3)
                wget -O - https://${GITHUB_MIRROR}/sseaky/deploy/raw/master/init/vim/vim.sh | bash
                ;;
            4)
                wget -O - https://${GITHUB_MIRROR}/sseaky/deploy/raw/master/init/tmux/tmux.sh | bash
                ;;
            5)
                sudo -E bash -c "bash <(wget -qO - https://github.com/sseaky/AntiScan/raw/master/antiscan_onekey.sh) install"
                ;;
            6)
                wget -O - https://${GITHUB_MIRROR}/sseaky/frp-onekey/raw/main/frp_onekey.sh | bash
                ;;
            7)
                wget -O - https://${GITHUB_MIRROR}/sseaky/deploy/raw/master/init/npc/npc_install.sh | bash
                ;;
            8)
                wget -O - https://${GITHUB_MIRROR}/sseaky/deploy/raw/master/init/pyenv/pyenv.sh | bash
                ;;
            [eE][xX][iI][tT])
                exit 1
                ;;
            *)
                echo "No choice."
                exit 1
                ;;
        esac
    done
}

choice_mirror
[ -n "${GITHUB_MIRROR}" ] && export GITHUB_MIRROR || exit 1
choice_install