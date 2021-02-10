
# enhance echo
set_text_color(){
    COLOR_RED='\E[1;31m'
    COLOR_GREEN='\E[1;32m'
    COLOR_YELLOW='\E[1;33m'
    COLOR_BLUE='\E[1;34m'
    COLOR_PINK='\E[1;35m'
    COLOR_PINKBACK_WHITEFONT='\033[45;37m'
    COLOR_GREEN_LIGHTNING='\033[32m \033[05m'
    COLOR_END='\E[0m'
}
set_text_color

show_info(){
    echo -e "${COLOR_GREEN}- INFO: $*${COLOR_END}"
}

show_error(){
    echo -e "${COLOR_RED}! ERROR: $*${COLOR_END}"
}

show_warn(){
    echo -e "${COLOR_YELLOW}* WARN: $*${COLOR_END}"
}

merge_line(){
    echo $* | tr -d "[:space:]"
}

# OS

check_os(){
    f="/etc/os-release"
    if [ ! -f $f ]; then
        show_error Can\'t detect the os for $f dose not exist.
        exit 1
    fi
    source /etc/os-release
    if [ $ID = "ubuntu" -o $ID = "debian" ]; then
        INSTALL="yum install -y "
    elif [ $ID = "centos" ]; then
        INSTALL="yum install -y "
    else
        show_error Can\'t detect the os with $f
        exit 1
    fi
    show_info os: $ID
}
check_os

check_pkg(){
    if [ -n "$1" ]; then
        cmd=$1
        pkg=${2:-${cmd}}
        [ -n "$(command -v $cmd)" ] || $INSTALL $pkg
    fi
}

check_user(){
    if [ $UID -eq 0 ]; then
        IS_ROOT=true
        SUDO=""
    else
        IS_ROOT=false
        check_pkg sudo
        SUDO="sudo "
    fi
    show_info user: $USER
}
check_user


check_root(){
    if [ "$EUID" -ne 0 ]; then
        show_error "This script must be run as root!" 1>&2
        exit 1
    fi
}

# github ssl fail
github_retry(){
    i=${GITHUB_RETRY:-5}
    while [ $i -gt 0 ]
    do
        i=$(( $i - 1 ))
        $wgetx -O $1 $2
        [ $? -eq 0 ] && break
    done
}

wgetx='wget --no-check-certificate '

SK_SOURCE=true
