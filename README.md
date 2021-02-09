# About

Apply my environment on new server quickly.



## Add user
```bash
sudo bash -c "bash <(wget -qO - https://github.com/sseaky/deploy/raw/master/init/add_user.sh) -u <new_user> [-s]"
```
or

```bash
wget https://github.com/sseaky/deploy/raw/master/init/add_user.sh
sudo bash add_user.sh -u <new_user> [-s]
```



## Deploy

need **sudo** right if require apps installation, edit /etc/sudoers.d/seaky

`seaky  ALL=(ALL:ALL) NOPASSWD: ALL`

```
bash <(wget -qO - https://github.com/sseaky/deploy/raw/master/init/init_user.sh)
```



## Proxy

```
--no-check-certificate 
-e "http_proxy=http://127.0.0.1:8087"
--no-proxy
```



## Alternative Server

```
github.com.cnpmjs.org
hub.fastgit.org
g.ioiox.com/https://github.com
```



## DNS

sudo vi /etc/hosts

```
199.232.4.133 raw.githubusercontent.com
```

