
wgetx='wget --no-check-certificate -q '

SK_SOURCE=true

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

show_title(){
    echo -e "${COLOR_YELLOW}* $* "
}

show_banner(){
    str_repeat(){
        eval printf -- "$1%0.s" {1..$2}
    }
    indent=2
    title=$@
    len=$((${#title} + $indent + $indent))
    echo
    echo "+"$(str_repeat "-" $len)"+"
    printf "|%$((${len}+1))s\n" "|"
    printf "|%$((${#title} + $indent))s%$((${indent}+1))s\n" "$title" "|"
    printf "|%$((${len}+1))s\n" "|"
    echo "+"$(str_repeat "-" $len)"+"
    echo
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
        INSTALL="apt install -y "
    elif [ $ID = "centos" -o $ID = "anolis" ]; then
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
        [ -n "$(command -v $cmd)" ] || $SUDO $INSTALL $pkg
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

read_param(){
    VAR_NAME=$1
    while true
    do
        echo Please input $VAR_NAME:
        read $2 INPUT
        if [ -z "$INPUT" ]
        then
            echo "$VAR_NAME can't be none!"
        else
            eval "VAR_NAME=$INPUT"
            break
        fi
    done
}

# github ssl fail
web_get(){
    i=${WEB_RETRY:-10}
    while [ $i -gt 0 ]
    do
        i=$(( $i - 1 ))
        $wgetx -O $1 $2
        [ $? -eq 0 ] && break
    done
}



# crypto
encrypt(){
    show_info "Input PLAIN TEXT for crypt: "
    read plain_text
    show_info "Input PASSWORD 1st time: "
    read -s password1
    show_info "Input PASSWORD 2nd time: "
    read -s password2
    [ "$password1" != "$password2" ] && show_error "passwords are not match" && exit 1
    password=`echo $password1 | md5sum | awk '{print $1}'`
    echo $plain_text | openssl enc -a -e -aes-256-cbc -k $password
    exit
}

decrypt(){
    _password=`echo $1 | md5sum | awk '{print $1}'`
    result=`echo $2 | openssl enc -a -d -aes-256-cbc -k $_password`
    if [ $? -ne 0 ]
    then
        exit 1
    fi
    echo $result
}

apt_update_in_1day(){
    # 获取上次更新的时间
    last_update=$(stat -c %Y /var/lib/apt/periodic/update-success-stamp)
    current_time=$(date +%s)

    # 定义一天的秒数
    day_in_seconds=$((60*60*24))

    # 如果距离上次更新不到一天时间，则不更新
    if (( current_time - last_update < day_in_seconds )); then
        echo "上次更新在一天以内，不执行更新操作"
    else
        echo "上次更新超过一天，执行更新操作"
        apt-get update
    fi
}