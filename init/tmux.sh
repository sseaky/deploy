#!/usr/bin/env bash
# @Author: Seaky
# @Date:   2018-08-15 17:23:12
# @Last Modified BY:   Seaky
# @Last Modified time: 2020-06-08 16:26:33

# wget -O - https://raw.githubusercontent.com/sseaky/common/master/init/tmux.sh | bash

GITHUB_MIRROR=${GITHUB_MIRROR:-github.com}

_sudo=''
uid=`id -u`
if [ $uid -ne 0 ];then
    _sudo='sudo'
    # sudo ls >> /dev/NULL 2>&1
    # [[ $? -eq 0 ]] || echo 'need sudo privilege'
fi

inst()
{
    [[ $(dpkg -l $1 2> /dev/null ) ]] || \
    (
        ${_sudo} apt install -y tmux && [[ $(dpkg -l $1 2> /dev/null ) ]] || \
        (
            echo "$1 is not installed." && exit 2
        )
    )
}

inst tmux
inst git

cd
[[ ! -d ~/.tmux ]] && git clone https://${GITHUB_MIRROR)/gpakosz/.tmux.git && ln -s -f ~/.tmux/.tmux.conf && cp ~/.tmux/.tmux.conf.local .
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
[[ ! -d tmux-resurrect ]] && git clone https://${GITHUB_MIRROR)/tmux-plugins/tmux-resurrect.git
[[ -e ~/.tmux.conf.local && ! $(grep "^${cfg}" ~/.tmux.conf.local) ]] && cat >> ~/.tmux.conf.local << EOF
$cfg
EOF
