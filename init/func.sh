#!/bin/bash
# @Author: Seaky
# @Description: 通用函数库，支持多系统环境检测

wgetx='wget --no-check-certificate -q '
SK_SOURCE=true

# =================================================================
# 第一部分：优化与增强函数 (替代原逻辑)
# =================================================================

# [优化] 核心系统检测：替代原 check_os
check_os(){
    local f="/etc/os-release"
    if [ ! -f "$f" ]; then
        show_error "无法检测系统: $f 不存在"
        exit 1
    fi
    source "$f"
    ID_LOWER=$(echo "$ID" | tr '[:upper:]' '[:lower:]')
    
    case "$ID_LOWER" in
        "ubuntu"|"debian")
            INSTALL="apt install -y "
            UPDATE_CMD="apt update"
            ;;
        "centos"|"anolis"|"rhel"|"rocky"|"almalinux"|"fedora")
            # 自动选择包管理器：优先 dnf
            if command -v dnf >/dev/null 2>&1; then
                INSTALL="dnf install -y "
            else
                INSTALL="yum install -y "
            fi
            UPDATE_CMD="yum makecache"
            ;;
        *)
            show_error "不支持的系统类型: $ID"
            exit 1
            ;;
    esac
    show_info "检测到系统: $ID_LOWER"
}

# [优化] 智能更新逻辑：替代原 apt_update_in_1day
apt_update_in_1day(){
    local stamp_file
    if [ -d "/var/lib/apt/periodic" ]; then
        stamp_file="/var/lib/apt/periodic/update-success-stamp"
    else
        # 为 CentOS/RedHat 等系统模拟时间戳文件
        stamp_file="/var/cache/package_manager_update_stamp"
    fi

    local current_time=$(date +%s)
    local last_update=0
    [ -f "$stamp_file" ] && last_update=$(stat -c %Y "$stamp_file")
    
    if (( current_time - last_update < 86400 )); then
        show_info "24小时内已更新，跳过系统源更新."
    else
        show_info "执行系统源更新..."
        $SUDO $UPDATE_CMD
        $SUDO touch "$stamp_file"
    fi
}

# [优化] 参数读取：替代原 read_param
read_param(){
    local msg=$1
    local var_name=$2
    while true; do
        read -p "请输入 $msg: " -r INPUT
        if [ -z "$INPUT" ]; then
            echo "$msg 不能为空!"
        else
            printf -v "$var_name" "%s" "$INPUT"
            break
        fi
    done
}

# [优化] 增强版加密：替代原 encrypt
encrypt(){
    show_info "请输入待加密文本: "
    read -r plain_text
    show_info "请输入密码: "
    read -rs pass1; echo
    show_info "确认密码: "
    read -rs pass2; echo
    [ "$pass1" != "$pass2" ] && { show_error "密码不一致"; return 1; }
    
    local key=$(echo -n "$pass1" | md5sum | awk '{print $1}')
    # 增加 pbkdf2 兼容新版 OpenSSL
    echo "$plain_text" | openssl enc -a -e -aes-256-cbc -k "$key" -pbkdf2 2>/dev/null || \
    echo "$plain_text" | openssl enc -a -e -aes-256-cbc -k "$key"
}

# =================================================================
# 第二部分：保留的基础功能函数 (供外部引用)
# =================================================================

set_text_color(){
    COLOR_RED='\E[1;31m'
    COLOR_GREEN='\E[1;32m'
    COLOR_YELLOW='\E[1;33m'
    COLOR_BLUE='\E[1;34m'
    COLOR_END='\E[0m'
}
set_text_color

show_info(){ echo -e "${COLOR_GREEN}- INFO: $*${COLOR_END}"; }
show_error(){ echo -e "${COLOR_RED}! ERROR: $*${COLOR_END}"; }
show_warn(){ echo -e "${COLOR_YELLOW}* WARN: $*${COLOR_END}"; }
show_title(){ echo -e "${COLOR_YELLOW}* $* ${COLOR_END}"; }

show_banner(){
    str_repeat(){ eval printf -- "$1%0.s" {1..$2}; }
    local title="$*"
    local len=$((${#title} + 4))
    echo -e "${COLOR_YELLOW}"
    echo "+"$(str_repeat "-" $len)"+"
    printf "|  %s  |\n" "$title"
    echo "+"$(str_repeat "-" $len)"+"
    echo -e "${COLOR_END}"
}

merge_line(){ echo "$*" | tr -d "[:space:]"; }

check_user(){
    if [ "$EUID" -eq 0 ]; then
        IS_ROOT=true; SUDO=""
    else
        IS_ROOT=false
        command -v sudo >/dev/null 2>&1 || { $INSTALL sudo >/dev/null 2>&1; }
        SUDO="sudo "
    fi
    show_info "user: $USER"
}

check_pkg(){
    if [ -n "$1" ]; then
        local cmd=$1
        local pkg=${2:-${cmd}}
        command -v "$cmd" >/dev/null 2>&1 || $SUDO $INSTALL "$pkg"
    fi
}

check_root(){
    if [ "$EUID" -ne 0 ]; then
        show_error "This script must be run as root!"
        exit 1
    fi
}

web_get(){
    local i=${WEB_RETRY:-10}
    while [ "$i" -gt 0 ]; do
        ((i--))
        $wgetx -O "$1" "$2" && break
    done
}

decrypt(){
    local key=$(echo -n "$1" | md5sum | awk '{print $1}')
    local res
    res=$(echo "$2" | openssl enc -a -d -aes-256-cbc -k "$key" -pbkdf2 2>/dev/null || \
          echo "$2" | openssl enc -a -d -aes-256-cbc -k "$key")
    [ $? -eq 0 ] && echo "$res" || return 1
}

# 执行基础环境检测
check_os
check_user