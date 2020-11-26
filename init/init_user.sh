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
    echo
    echo -e "${COLOR_GREEN}Choice Module:${COLOR_END}"
    echo "    1: oh-my-zsh"
    echo "    2: bashit"
    echo "    3: vim"
    echo "    4: tmux"
    echo "    5: pyenv"
    echo "-------------------------"
    read -e -p "Enter your choice: " str_choice_source
    case "${str_choice_source}" in
        1)
            wget -qO - https://${GITHUB_MIRROR}/sseaky/deploy/raw/master/init/zsh_antigen.sh | bash && zsh
            ;;
        2)
            wget -qO - https://${GITHUB_MIRROR}/sseaky/deploy/raw/master/init/bashit.sh | bash
            ;;
        3)
            wget -qO - https://${GITHUB_MIRROR}/sseaky/deploy/raw/master/init/vim.sh | bash
            ;;
        4)
            wget -qO - https://${GITHUB_MIRROR}/sseaky/deploy/raw/master/init/tmux.sh | bash
            ;;
        5)
            wget -qO - https://${GITHUB_MIRROR}/sseaky/deploy/raw/master/init/pyenv.sh | bash
            ;;
        [eE][xX][iI][tT])
            exit 1
            ;;
        *)
            echo "No choice."
            exit 1
            ;;
    esac
}

choice_mirror
[ -n "${GITHUB_MIRROR}" ] && export GITHUB_MIRROR || exit 1
choice_install