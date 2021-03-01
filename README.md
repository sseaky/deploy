# About

Apply my environment on new server quickly.



## Deploy

need **sudo** right if require apps installation, edit /etc/sudoers.d/seaky

`seaky  ALL=(ALL:ALL) NOPASSWD: ALL`

```bash
# export GITHUB_RETRY=10
# export GITHUB_MIRROR="https://hub.fastgit.org"
GITHUB_MIRROR=${GITHUB_MIRROR:-github.com}
bash <(wget --no-check-certificate -qO - ${GITHUB_MIRROR:-https://github.com}/sseaky/deploy/raw/master/init/init_user.sh) [module]
```



## Add user
```bash
# export GITHUB_RETRY=10
# export GITHUB_MIRROR="https://hub.fastgit.org"
GITHUB_MIRROR=${GITHUB_MIRROR:-github.com}
sudo -E bash -c "bash <(wget -qO - ${GITHUB_MIRROR:-https://github.com}/sseaky/deploy/raw/master/init/add_user.sh) -u <new_user> [-s]"
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

