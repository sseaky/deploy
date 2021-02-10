#!/usr/bin/env bash
# @Author: Seaky
# @Date:   2021/2/10 11:26

#

[ $SK_SOURCE ] || source <(wget --no-check-certificate -q -O - https://${GITHUB_MIRROR}/sseaky/deploy/raw/master/init/func.sh)

if [ "$ID" = "ubuntu" ]; then
    if [ -z "${UBUNTU_CODENAME}" ];then
        show_error "Cann't detect UBUNTU_CODENAME"
        exit 1
    fi
    show_info ubuntu_code: ${UBUNTU_CODENAME}
    if `grep -v ^# /etc/apt/sources.list | grep aliyun >> /dev/null`; then
        show_info "aliyun has been installed"
    else
        mkdir -p /etc/apt/sources.list.backup
        mv /etc/apt/sources.list /etc/apt/sources.list.backup/
        cat > /etc/apt/sources.list <<-EOF
deb http://mirrors.aliyun.com/ubuntu/ ${UBUNTU_CODENAME} main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ ${UBUNTU_CODENAME} main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ ${UBUNTU_CODENAME}-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ ${UBUNTU_CODENAME}-security main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ ${UBUNTU_CODENAME}-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ ${UBUNTU_CODENAME}-updates main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ ${UBUNTU_CODENAME}-proposed main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ ${UBUNTU_CODENAME}-proposed main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ ${UBUNTU_CODENAME}-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ ${UBUNTU_CODENAME}-backports main restricted universe multiverse

#deb http://mirrors.tencentyun.com/ubuntu/ ${UBUNTU_CODENAME} main restricted universe multiverse
#deb http://mirrors.tencentyun.com/ubuntu/ ${UBUNTU_CODENAME}-security main restricted universe multiverse
#deb http://mirrors.tencentyun.com/ubuntu/ ${UBUNTU_CODENAME}-updates main restricted universe multiverse
#deb-src http://mirrors.tencentyun.com/ubuntu/ ${UBUNTU_CODENAME} main restricted universe multiverse
#deb-src http://mirrors.tencentyun.com/ubuntu/ ${UBUNTU_CODENAME}-security main restricted universe multiverse
#deb-src http://mirrors.tencentyun.com/ubuntu/ ${UBUNTU_CODENAME}-updates main restricted universe multiverse
#deb-src http://mirrors.tencentyun.com/ubuntu/ ${UBUNTU_CODENAME}-proposed main restricted universe multiverse
#deb-src http://mirrors.tencentyun.com/ubuntu/ ${UBUNTU_CODENAME}-backports main restricted universe multiverse

EOF
    show_info Install aliyun done.
    fi
elif [ "$ID" = "centos" ]; then
    if  [ "$VERSION_ID" -ne 7 ]; then
        show_error "Cann't detect centos version "
        exit 1
    fi
    show_info centos_code: $VERSION_ID
    if `grep -v ^# /etc/yum.repos.d/*.repo | grep aliyun >> /dev/null`; then
        show_info "aliyun has been installed"
    else
        mkdir -p /etc/yum.repos.d/repo.backup
        mv /etc/yum.repos.d/*.repo /etc/yum.repos.d/repo.backup/
        wget -O /etc/yum.repos.d/aliyun.repo http://mirrors.aliyun.com/repo/Centos-7.repo
        show_info Install aliyun done.
    fi
else
    show_error Can not support OS $ID
fi


