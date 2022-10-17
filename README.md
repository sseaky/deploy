# About

Apply my environment on new server quickly.



## Deploy

need **sudo** right if require apps installation, edit /etc/sudoers.d/seaky

`seaky  ALL=(ALL:ALL) NOPASSWD: ALL`

```bash
# export GITHUB_RETRY=10
# export GITHUB_MIRROR="https://github.com.cnpmjs.org"
bash <(wget --no-check-certificate -qO - ${GITHUB_MIRROR:-https://github.com}/sseaky/deploy/raw/master/init/init_user.sh) [module]
```



## Add user
```bash
# export GITHUB_RETRY=10
# export GITHUB_MIRROR="https://github.com.cnpmjs.org"
sudo -E bash -c "bash <(wget -qO - ${GITHUB_MIRROR:-https://github.com}/sseaky/deploy/raw/master/init/misc/add_user.sh) -u <new_user> [-s]"
```



## Add iptables-apply

```bash
which iptables-apply || ( wget https://raw.githubusercontent.com/sseaky/deploy/master/init/misc/iptables-apply && chmod +x iptables-apply && mv iptables-apply /usr/sbin/ )

iptables-save > /etc/network/iptables.up.rules && vi /etc/network/iptables.up.rules && iptables-apply && sleep 1 && iptables -nvL && echo '\n\n' && iptables -nvL -t nat
```



## Proxy

```
--no-check-certificate 
-e "http_proxy=http://127.0.0.1:8087"
--no-proxy
```



## Alternative Server

```
hub.fastgit.org
github.com.cnpmjs.org
g.ioiox.com/https://github.com
```



## DNS

sudo vi /etc/hosts

```
199.232.4.133 raw.githubusercontent.com
```

