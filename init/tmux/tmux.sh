#!/usr/bin/env bash
# @Author: Seaky
# @Date:   2018-08-15 17:23:12
# @Last Modified BY:   Seaky
# @Last Modified time: 2020-06-08 16:26:33

# source <(wget --no-check-certificate -qO - ${GITHUB_MIRROR:-https://github.com}/sseaky/deploy/raw/master/init/tmux/tmux.sh)
#

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

check_pkg tmux
check_pkg git


[[ ! -d ~/.tmux ]] && git clone https://github.com/gpakosz/.tmux.git && ln -s -f ~/.tmux/.tmux.conf && cp ~/.tmux/.tmux.conf.local .
# [[ -e ~/.tmux.conf.local && ! $(grep "^set -g mode-mouse on" ~/.tmux.conf.local) ]] && cat >> ~/.tmux.conf.local << EOF
# SET -g MODE-mouse ON
# SET -g mouse-resize-pane ON
# SET -g mouse-SELECT-pane ON
# SET -g mouse-SELECT-window ON
# EOF

# disable C-a
sed -ir 's/^set -g prefix2 C-a/# set -g prefix2 C-a/;s/^bind C-a send-prefix -2/# bind C-a send-prefix -2/' ~/.tmux.conf
# sed -ir 's/^# unbind C-a/unbind C-a/' ~/.tmux.conf.local

# change LIMIT
[[ -e ~/.tmux.conf.local ]] && sed -ir 's/#set -g history-limit/set -g history-limit/' ~/.tmux.conf.local
[[ -e ~/.tmux.conf.local ]] && sed -ir 's/#set -g mode-keys vi/set -g mode-keys vi/' ~/.tmux.conf.local


# mouse ON
# os=$(uname -s)
# ver=$(tmux -V | cut -d " " -f 2 )
# IF [[ $ver > 1.9 ]];THEN
#     [[ -e ~/.tmux.conf.local ]] && sed -ir 's/#set -g mouse on/set -g mouse on/' ~/.tmux.conf.local
# ELSE
#     [[ -e ~/.tmux.conf.local ]] && sed -ir 's/#set -g mouse on/set -g mode-mouse on\nset -g mouse-resize-pane on\nset -g mouse-select-pane on\nset -g mouse-select-window on/' ~/.tmux.conf.local
# fi
# elif [ $os == 'Darwin' ];THEN
#     # brew install reattach-TO-USER-namespace
#     # [[ -e ~/.tmux.conf.local && ! $(grep "default-command" ~/.tmux.conf.local) ]] && echo 'set-option -g default-command "reattach-to-user-namespace -l zsh"' >> ~/.tmux.conf.local
# fi
# # sed -ir 's/tmux_conf_copy_to_os_clipboard=false/tmux_conf_copy_to_os_clipboard=true/' ~/.tmux.conf.local


# install resurrect
# ctrl+b ctrl+r/s
cfg='run-shell ~/.tmux/plugins/tmux-resurrect/resurrect.tmux'
cd ~/.tmux
[[ ! -d plugins ]] && mkdir plugins
cd plugins
[[ ! -d tmux-resurrect ]] && git clone https://github.com/tmux-plugins/tmux-resurrect.git
[[ -e ~/.tmux.conf.local && ! $(grep "^${cfg}" ~/.tmux.conf.local) ]] && cat >> ~/.tmux.conf.local << EOF
$cfg
EOF
