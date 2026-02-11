#!/usr/bin/env bash
# @Author: Seaky
# @Description: ZSH 自动安装脚本 - 优先探测本地文件，不存在则远程下载

GITHUB_MIRROR=${GITHUB_MIRROR:-https://github.com}
RAW_URL="${GITHUB_MIRROR}/sseaky/deploy/raw/master/init"

# --- 1. 引用基础函数库 (优先本地) ---
if [ ! "$SK_SOURCE" ]; then
    # 探测本地 func.sh
    if [ -f "./func.sh" ]; then
        source ./func.sh
    elif [ -f "${BASH_SOURCE%/*}/func.sh" ]; then
        source "${BASH_SOURCE%/*}/func.sh"
    fi

    # 本地不存在则远程下载
    if [ ! "$SK_SOURCE" ]; then
        echo "Local func.sh not found, trying remote..."
        i=${WEB_RETRY:-10}
        while [ "$i" -gt 0 ]; do
            ((i--))
            source <(wget --no-check-certificate -qO - "${RAW_URL}/func.sh")
            [ "$SK_SOURCE" ] && break
        done
    fi
fi

if [ ! "$SK_SOURCE" ]; then
    echo "Error: Source func.sh failed!"
    exit 1
fi

# --- 2. 定义探测并获取文件的函数 ---
smart_get() {
    local target=$1
    local remote_url=$2
    local filename=$(basename "$target")
    local local_file=""

    # 检查当前目录或脚本所在目录是否存在该文件
    if [ -f "./$filename" ]; then
        local_file="./$filename"
    elif [ -f "${BASH_SOURCE%/*}/$filename" ]; then
        local_file="${BASH_SOURCE%/*}/$filename"
    fi

    if [ -n "$local_file" ]; then
        show_info "Found local $filename, copying..."
        cp "$local_file" "$target"
    else
        show_info "$filename not found locally, downloading from remote..."
        web_get "$target" "$remote_url"
    fi
}

# --- 3. 开始安装流程 ---
show_banner "Install ZSH"
export SERVER="${RAW_URL}/zsh"

# 环境检查与依赖安装
check_os
check_user
check_pkg zsh
check_pkg git
check_pkg curl

# 探测并安装 Antigen 插件管理器 [cite: 2]
smart_get ~/.antigen.zsh "${SERVER}/.antigen.zsh"
sed -i 's#ANTIGEN_INSTALL_DIR/antigen.zsh#ANTIGEN_INSTALL_DIR/.antigen.zsh#' ~/.antigen.zsh

# 探测并安装 .zshrc 配置 [cite: 12]
smart_get ~/.zshrc "${SERVER}/.zshrc"
sed -i "s#/HOME/#${HOME}/#g" ~/.zshrc

# 探测并安装 zsh_alias
smart_get ~/.zsh_alias "${SERVER}/.zsh_alias"

# 切换 Shell
ZSH_PATH=$(command -v zsh)
show_info "Switching shell to $ZSH_PATH"
$SUDO chsh -s "$ZSH_PATH" "$USER"

# 初始化环境
show_info "Initializing ZSH environment..."
zsh -c "source ~/.zshrc"

show_info "Done! Please re-login to enjoy ZSH."