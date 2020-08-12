# @Author: Seaky
# @Date:   2019-06-26 16:41:32
# @Last Modified by:   Seaky
# @Last Modified time: 2020-06-15 14:27:18

# wget --no-proxy -qO - https://raw.githubusercontent.com/sseaky/common/master/init/zsh_antigen.sh | bash && zsh
# wget --no-proxy -qO - https://raw.githubusercontent.com/sseaky/common/master/init/zsh_antigen.sh | bash -s -- -w <WAKATIME_KEY> && zsh
#

while getopts "w:" arg
do
    case $arg in
         w)
            wakatime_api_key=$OPTARG
            ;;
         ?)
            echo "unkonw argument"
            exit 1
            ;;
    esac
done

export SERVER="https://raw.githubusercontent.com/sseaky/common/master/init"

sudo apt install -y zsh git

# https://raw.githubusercontent.com/zsh-users/antigen/master/bin/antigen.zsh
wget -O ~/.antigen.zsh git.io/antigen
sed -ir 's#ANTIGEN_INSTALL_DIR/antigen.zsh#ANTIGEN_INSTALL_DIR/.antigen.zsh#' ~/.antigen.zsh

wget -qO ~/.zshrc $SERVER/zshrc_antigen
sed -ir "s#/HOME/#${HOME}/#" ~/.zshrc
wget -qO ~/.zsh_alias $SERVER/zsh_alias

if [[ -n $wakatime_api_key ]];then
    [[ ! -f ~/.wakatime.cfg ]] && cat > ~/.wakatime.cfg << EOF
[settings]
debug = false
api_key = $wakatime_api_key
hostname = $(hostname)
EOF
    pip install wakatime
    wget -qO ~/.wakatime.cfg $SERVER/wakatime.cfg
    sed -ir "s/hostname = NocTest/hostname = $(hostname)/" ~/.wakatime.cfg
fi

sudo chsh -s `which zsh` `echo $USER`

# ConEmu/Cmder
# # export http_proxy='127.0.0.1:52321'
# # export https_proxy='127.0.0.1:52321'
# wget rawgit.com/transcode-open/apt-cyg/master/apt-cyg > apt-cyg
# install apt-cyg /bin