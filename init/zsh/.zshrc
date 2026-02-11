###
 # @Author: Seaky
 # @Date: 2026-02-11 23:53:51
 # @LastEditTime: 2026-02-12 00:05:20
 # @Description: 
 # 
### 

# 加载 Antigen [cite: 2, 12]
source ~/.antigen.zsh

# 插件配置 [cite: 3, 4, 12]
antigen use oh-my-zsh
antigen bundle git
antigen bundle pip
antigen bundle command-not-found
antigen bundle colored-man-pages
antigen bundle cp
antigen bundle extract
antigen bundle history
antigen bundle sudo
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions

# 主题 [cite: 5, 12]
antigen theme robbyrussell
antigen apply

# --- 个性化设置 ---
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=245"
DISABLE_AUTO_UPDATE="true"

# 路径缩写逻辑优化 [cite: 12, 13]
setopt PROMPT_SUBST
pwd_limit=40
short_pwd() {
    local PWD1=${PWD#${HOME}}
    if [[ ${#PWD1} -le ${pwd_limit} ]]; then
        echo '%~'
    else
        echo "...${PWD1: -${pwd_limit}}"
    fi
}

# 环境变量 [cite: 12]
export TERM=xterm-256color
export LANG=C.UTF-8
export EDITOR=vim

# 快捷键修复 [cite: 7, 12, 14]
bindkey -s "^[Op" "0"
bindkey -s "^[On" "."
bindkey -s "^[OM" "^M"
bindkey -s "^[Oq" "1"
bindkey -s "^[Or" "2"
bindkey -s "^[Os" "3"
bindkey -s "^[Ot" "4"
bindkey -s "^[Ou" "5"
bindkey -s "^[Ov" "6"
bindkey -s "^[Ow" "7"
bindkey -s "^[Ox" "8"
bindkey -s "^[Oy" "9"
bindkey '^f' forward-word
bindkey -r '^V'

# 加载别名文件 [cite: 12]
[[ -f ~/.zsh_alias ]] && source ~/.zsh_alias

# --- 动态 Hostname 与 IP 显示 ---
extract_ip(){
    # 增加超时处理 [cite: 8, 12, 15]
    curl -4 -s --connect-timeout 3 "$1" 2>/dev/null | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b"
}

MY_HOSTNAME=$(hostname)

# 修正：只有明确为 true 时获取 
export USE_PRI_IP="false"
export USE_PUB_IP="false"
if [[ "$USE_PUB_IP" == "true" ]]; then
    PUBIP=$(extract_ip ip.sb)
    [[ -n "$PUBIP" ]] && MY_HOSTNAME="${MY_HOSTNAME}_${PUBIP}"
fi

if [[ "$USE_PRI_IP" == "true" ]]; then
    # 逻辑：查找 default 路由，提取 src 关键字后的第一个字段
    PRIIP=$(ip route show default 2>/dev/null | grep -oP 'src \K[\d.]+' | head -n 1)
    
    # 如果 default 没找到，再回退到原来的 get 1.1.1.1 方案
    if [[ -z "$PRIIP" ]]; then
        PRIIP=$(ip route get 1.1.1.1 2>/dev/null | awk '{print $7}' | head -n 1)
    fi

    [[ -n "$PRIIP" ]] && MY_HOSTNAME="${MY_HOSTNAME}_${PRIIP}"
fi

# 根据用户权限设置颜色 [cite: 11, 12, 16]
if [ "$UID" -eq 0 ]; then
    NAME_COLOR="red"
else
    NAME_COLOR="yellow"
fi

export PROMPT='%{$fg[$NAME_COLOR]%}%n%{$reset_color%}@%{$fg[cyan]%}${MY_HOSTNAME}%{$reset_color%} %{$fg[blue]%}$(short_pwd)%{$reset_color%} $(git_prompt_info) %'