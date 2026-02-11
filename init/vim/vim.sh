#!/usr/bin/env bash
# @Author: Seaky
# @Modified: 2026-02-11

GITHUB_MIRROR=${GITHUB_MIRROR:-https://github.com}
RAW_URL="${GITHUB_MIRROR}/sseaky/deploy/raw/master/init"

# --- 1. 引用基础函数库 (优先本地) ---
if [ ! "$SK_SOURCE" ]; then
    if [ -f "./func.sh" ]; then
        source ./func.sh
    elif [ -f "${BASH_SOURCE%/*}/func.sh" ]; then
        source "${BASH_SOURCE%/*}/func.sh"
    fi

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

[ ! "$SK_SOURCE" ] && { echo "Source func.sh failed"; exit 1; }

# --- 2. 探测并获取文件的函数 ---
smart_get() {
    local target=$1
    local remote_url=$2
    local filename=$(basename "$target")
    local local_file=""

    [ -f "./$filename" ] && local_file="./$filename"
    [ -z "$local_file" ] && [ -f "${BASH_SOURCE%/*}/$filename" ] && local_file="${BASH_SOURCE%/*}/$filename"

    if [ -n "$local_file" ]; then
        show_info "Found local $filename, copying..."
        cp "$local_file" "$target"
    else
        show_info "$filename not found locally, downloading..."
        web_get "$target" "$remote_url"
    fi
}

# --- 3. 开始流程 ---
show_banner "Set VIM Configuration"

check_pkg vim
check_pkg git

# 参数解析 
install_vundle=false
while getopts "p" arg; do
    case $arg in
        p) install_vundle=true ;;
        *) echo "Unknown argument"; exit 1 ;;
    esac
done

export SERVER="${RAW_URL}/vim"

# 获取主配置 .vimrc
smart_get ~/.vimrc "${SERVER}/.vimrc"
[ ! -s ~/.vimrc ] && { show_error "~/.vimrc download failed"; exit 1; }

# 修正 vi 软链接 (处理 CentOS/RHEL 差异) [cite: 22]
VI_BIN=$(command -v vi)
VIM_BIN=$(command -v vim)
if [ -z "$VI_BIN" ]; then
    $SUDO ln -s "$VIM_BIN" /usr/bin/vi
elif [ ! -L "$VI_BIN" ]; then
    show_info "Relinking $VI_BIN to vim"
    $SUDO mv "$VI_BIN" "${VI_BIN}.save"
    $SUDO ln -s "$VIM_BIN" "$VI_BIN"
fi

# Vundle 插件管理 [cite: 25, 26]
if [ "$install_vundle" = true ]; then
    [[ -d ~/.vim ]] || mkdir -p ~/.vim
    VUNDLE_DIR="$HOME/.vim/bundle/Vundle.vim"
    
    if [ ! -d "$VUNDLE_DIR" ]; then
        show_info "Cloning Vundle..."
        git clone "${GITHUB_MIRROR}/VundleVim/Vundle.vim.git" "$VUNDLE_DIR"
    fi

    # 获取插件配置 .vimrc_vundle
    smart_get ~/.vimrc_vundle "${SERVER}/.vimrc_vundle"
    
    # 路径与配置激活 
    sed -i "s#/HOME/#${HOME}/#g" ~/.vimrc_vundle
    # 取消 .vimrc 中对 vundle 的引用注释
    sed -i 's/^" source ~\/.vimrc_vundle/source ~\/.vimrc_vundle/' ~/.vimrc

    show_info "Installing Vim Plugins..."
    vim +PluginInstall +qall
fi

show_info "VIM configuration completed!"