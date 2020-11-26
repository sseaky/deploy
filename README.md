# About

Apply my environment on new server quickly.



## Add user

```bash
wget https://github.com/sseaky/deploy/raw/master/init/add_user.sh
sudo bash add_user.sh -u <new_user> [-s]
```

or

```bash
sudo bash -c "bash <(wget -qO - https://github.com/sseaky/deploy/raw/master/init/add_user.sh) -u <new_user> [-s]"
```



## Deploy

need **sudo** right if require apps installation, edit /etc/sudoers.d/seaky

`seaky  ALL=(ALL:ALL) NOPASSWD: ALL`



```
wget -O - https://github.com/sseaky/deploy/raw/master/init/bashit.sh | bash

wget -O - https://github.com/sseaky/deploy/master/init/zsh_antigen.sh | bash && zsh  

wget -O - https://github.com/sseaky/deploy/master/init/vim.sh | bash  

wget -O - https://github.com/sseaky/deploy/master/init/tmux.sh | bash

wget -O - https://github.com/sseaky/deploy/master/init/pyenv.sh | bash
```



## Proxy

```
--no-check-certificate 
-e "http_proxy=http://127.0.0.1:8087"
--no-proxy
```



## DNS

sudo vi /etc/hosts

```
199.232.4.133 raw.githubusercontent.com
```

