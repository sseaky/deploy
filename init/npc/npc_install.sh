#!/usr/bin/env bash
# @Author: Seaky
# @Date:   2020/12/15 19:10

# windows https://seaky.lanzous.com/iQLAEje9xyj
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

show_banner Install npc

ver=v0.26.9
tarball="linux_amd64_client.tar.gz"
url="${GITHUB_MIRROR}/ehang-io/nps/releases/download/${ver}/${tarball}"
temp_dir="npc_${ver}"

echo Start install npc

read -p "Input config string ([./npc] xxx):  " conn_str
params=`echo $conn_str | sed "s/\.\/npc //"`

mkdir -p "$temp_dir"
cd "$temp_dir"

[ -f "$tarball" ] && ( `tar ztf $tarball > /dev/null 2>&1` || rm $tarball )
[ -f "$tarball" ] || wget $url

tar zxf $tarball

[ -f 'npc' ] && $SUDO ./npc install $params
cd ..
$SUDO npc start
echo "Install done"




