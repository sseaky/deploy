#!/usr/bin/env bash
# @Author: Seaky
# @Date:   2020/12/15 19:10

# windows https://seaky.lanzous.com/iQLAEje9xyj
#

ver=v0.26.9
tarball="linux_amd64_client.tar.gz"
url="https://github.com/ehang-io/nps/releases/download/${ver}/${tarball}"
temp_dir="npc_${ver}"

echo Start install npc

read -p "Input config string ([./npc] xxx):  " conn_str
params=`echo $conn_str | sed "s/\.\/npc //"`

mkdir -p "$temp_dir"
cd "$temp_dir"

[ -f "$tarball" ] && ( `tar ztf $tarball > /dev/null 2>&1` || rm $tarball )
[ -f "$tarball" ] || wget $url

tar zxf $tarball

[ -f 'npc' ] && sudo ./npc install $params
cd ..
sudo npc start
echo "Install done"




