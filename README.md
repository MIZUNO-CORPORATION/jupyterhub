# JupyterHub

## Admin

### ユーザー追加・削除

- `adminserver`でログイン

  ```bash
  su - adminserver
  >*****
  
  cd ~/jupyterhub
  ```

  - ユーザー追加

    ※Passwordはデフォルトで`password`と設定される．ユーザーが任意のものに変更可能．

    ```bash
    sudo bash add_user.sh {user name}
    ```

  - ユーザー削除

    ```bash
    sudo bash delete_user.sh {username}
    ```

    

## Installation

参考：https://nodaki.hatenablog.com/entry/2019/04/17/220613

参考：https://jupyterhub.readthedocs.io/en/stable/installation-guide-hard.html

### JupyterHubインストール

- ログイン
  ```bash
  ssh mlserver@172.16.30.88
  ```
  
- Group作成

  ```bash
  groupadd jupyter
  usermod -a -G jupyter mlserver # mlserverユーザーをjupyterグループに追加
  
  # adminserver user作成
  sudo useradd adminserver -g jupyter -m -s /bin/bash
  sudo usermod -aG sudo adminserver # sudoの実行権限を与える
  sudo passwd adminserver
  >******
  >******
  ```
  
- 以下は`adminserver`で作業

  ```bash
  su - adminserver
  ```
  
- Jupyterhubインストール

  ```bash
  sudo apt-get install python3-venv
  sudo python3 -m venv /opt/jupyterhub/
  sudo /opt/jupyterhub/bin/python3 -m pip install wheel
  sudo /opt/jupyterhub/bin/python3 -m pip install jupyterhub jupyterlab
  sudo /opt/jupyterhub/bin/python3 -m pip install ipywidgets
  
  sudo chmod 775 -R /opt/jupyterhub/share
  sudo chmod 775 -R /opt/jupyterhub/lib
  ```
  
- 依存関係インストール

  ```bash
  sudo apt install nodejs npm
  sudo npm install -g configurable-http-proxy
  ```

- Jupyterhubの設定

  ```bash
  sudo mkdir -p /opt/jupyterhub/etc/jupyterhub/
  cd /opt/jupyterhub/etc/jupyterhub/
  
  sudo /opt/jupyterhub/bin/jupyterhub --generate-config
  sudo vi jupyterhub_config.py
  
  #vimでは，/{word}で検索可能．nで次の検索結果へ
  # 112行目付近
  c.JupyterHub.bind_url = 'http://:8000/jupyter'
  
  # 696行目付近
  c.Spawner.default_url = '/lab'
  
  # 最後にでも追記
  # login時のバグらしい
  # ref: https://github.com/jupyterhub/jupyterhub/issues/486
  c.PAMAuthenticator.open_sessions = False
  ```
  
- 自動起動設定

  ```bash
  sudo mkdir -p /opt/jupyterhub/etc/systemd
  
  sudo vi /opt/jupyterhub/etc/systemd/jupyterhub.service
  
  [Unit]
  Description=JupyterHub
  After=syslog.target network.target
  
  [Service]
  User=root
  Environment="PATH=/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/opt/jupyterhub/bin"
  ExecStart=/opt/jupyterhub/bin/jupyterhub -f /opt/jupyterhub/etc/jupyterhub/jupyterhub_config.py
  
  [Install]
  WantedBy=multi-user.target
  ```

  ```bash
  sudo ln -s /opt/jupyterhub/etc/systemd/jupyterhub.service /etc/systemd/system/jupyterhub.service
  sudo systemctl daemon-reload
  sudo systemctl enable jupyterhub.service
  sudo systemctl start jupyterhub.service
  sudo systemctl status jupyterhub.service
  ```


### Anaconda インストール

- Anacondaインストール（バージョンは適宜指定で）

  ```bash
  wget https://repo.anaconda.com/archive/Anaconda3-5.3.0-Linux-x86_64.sh -O ~/anaconda.sh
  sudo /bin/bash ~/anaconda.sh -p /opt/conda # 基本yes，最後のVSCodeなんちゃらはNoで
  rm ~/anaconda.sh
  
  source ~/.bashrc
  
  conda create -n py37 python=3.7 ipykernel
  sudo /home/adminserver/.conda/envs/py37/bin/python -m ipykernel install --prefix=/opt/jupyterhub/ --name 'python' --display-name "Python (default)"
  
  sudo ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh
  
  sudo chown -R adminserver:jupyter /opt/conda
  sudo chmod 775 -R /opt/conda/envs # jupyter groupに属したuserはcondaの仮想環境を弄れる # base環境のPythonのバージョンが壊れるとcondaコマンドが動かなくなる．それを防ぐために，base環境はadminserverのみ弄れるようにしている．
  ```

### Pyenvインストール

Anaconda商用利用有償化に伴い，追記（2021/03/05）

- Pyenvインストール

  Pyenvをadminserver直下にインストール
  
  ```bash
  git clone https://github.com/pyenv/pyenv.git
  ```
  
  このままでは，SSLエラーが出る可能性があるので，`libssl`のバージョンを変更（[リンク](https://github.com/pyenv/pyenv/wiki/Common-build-problems#error-the-python-ssl-extension-was-not-compiled-missing-the-openssl-lib)）
  
  ```bash
  sudo apt-get remove libssl-dev
  sudo apt-get update
  sudo apt-get install libssl1.0-dev
  ```


### nginx インストール

- nginxインストール

  ```bash
  sudo apt-get install -y nginx
  ```

- nginx設定

  ```bash
  sudo vi /etc/nginx/conf.d/mizuno-colab.conf
  
  
  # 以下追記
  map $http_upgrade $connection_upgrade {
          default upgrade;
          '' close;
      }

  server {
    listen 80;
    # ドメインもしくはIPを指定
    server_name localhost;

    access_log /var/log/nginx/access.log;
    error_log  /var/log/nginx/error.log;
   
   	client_max_body_size 0;
    ...
    
    # ここも追記
    location /jupyter/ {
        # NOTE important to also set base url of jupyterhub to /jupyter in its config
        proxy_pass http://127.0.0.1:8000;
      
        proxy_redirect   off;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
      
        # websocket headers
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $connection_upgrade;
      
      }
  ```
  
- 設定の反映

  ```bash 
  sudo nginx -t
  sudo systemctl reload nginx.service
  sudo systemctl restart nginx.service
  ```

- あとは，http://172.16.30.88/jupyter　にアクセスできればOK．

### Shareフォルダ

```bash
mkdir /opt/shared
sudo chown -R adminserver:jupyter /opt/shared
sudo chmod 775 /opt/shared
```

### Softwareフォルダ

```bash
mkdir -p /opt/software/bin
sudo chown -R adminserver:jupyter /opt/software
sudo chmod 775 /opt/software
sudo chmod 775 /opt/software/bin
```

全ユーザーへこの`/opt/software/bin`のパスを通す．

```bash
sudo vi /etc/profile.d/custom_path.sh

# CUDA
export PATH="/usr/local/cuda/bin:$PATH"
export LD_LIBRARY_PATH="/usr/local/cuda/lib64:$LD_LIBRARY_PATH"

# shared software
export PATH="/opt/software/bin:$PATH"

# proxy
# ここは直接入力した方が良さげ
# http://username:password@host:port/
export http_proxy="${http_proxy}"
export https_proxy="${https_proxy}"
export ftp_proxy="${ftp_proxy}"
```

### 管理用ディレクトリ

- ユーザー追加用スクリプトの作成

  ```bash
  mkdir ~/jupyterhub && cd ~/jupyterhub
  git clone https://github.com/MIZUNO-CORPORATION/jupyterhub.git
  ```

- カーネルディレクトリは`/opt/jupyterhub/share/jupyter/kernels/`に保存されている

  - カーネルの削除
  
    ```bash
    rm -rf /opt/jupyterhub/share/jupyter/kernels/{kernel name}
    ```

  

- 使い方

  ```bash
  # add user for jupyterhub
  sudo bash add_user.sh {username}
  ```

  ```bash
  # delete user
  sudo bash delete_user.sh {username}
  ```

  ```bash
  # create kernel for jupyter
  create_kernel.sh {envname}
  ```
  
  - Anaconda→pyenv+pip
  
    ```bash
    sudo bash to_pyenv.sh {username}
    ```
  
    


## Upgrade

```bash
su - adminserver
sudo systemctl stop jupyterhub.service 
# backup
sudo cp /opt/jupyterhub/etc/jupyterhub/jupyterhub_config.py ~/backup/
# upgrade
sudo /opt/jupyterhub/bin/python3 -m pip install -U jupyterhub
# もしエラーが出て，Pipそのもののバージョンを上げるときは要注意！19が良さげ．
```

