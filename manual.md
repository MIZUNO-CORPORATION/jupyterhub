# Welcome to Mizuno-Colab!!

このファイルは，マニュアルを記述したファイルなので，削除しないでください．

## Password変更

- 初期設定では，`password`になっているので，お好きなパスワードを設定してください．

- 左側の＋をクリックして，`Launcher`起動


  ![launcher.png](https://user-images.githubusercontent.com/63040751/101456181-06a06b00-3977-11eb-8c0b-453fc7294243.png)

- Other > Terminalを起動し，`passwd`コマンドで変更可能

  ```bash
  passwd
  
  > Changing password for {user}.
  > (current) UNIX password: password
  > Enter new UNIX password: {your new password}
  > Retype new UNIX password: {your new password}
  ```

## ファイル（データセット等）の共有

sharedフォルダ（正確にはシンボリックリンク）をhomeディレクトリ直下に用意しました．その中にデータセット等の共有したいファイルをアップロードしていってください．

![shared](https://user-images.githubusercontent.com/63040751/102979312-3f306f00-4549-11eb-91d2-dce614fd6ecf.JPG)

## 仮想環境の作り方

<strike>基本的には，Anacondaの仮想環境の作り方と同じです．（最後だけちょっと違います）</strike>

pyenv+venv+pipを使った環境構築に変更しました．

- pythonの任意のバージョンをインストール

  ```bash
  pyenv install 3.8.11
  ```

- pyenvのバージョンを確認

  ```bash
  pyenv versions
  
  # 以下のように現在使おうとしているバージョンがアスタリスク＊で表示される
  * system (set by /home/jkado/.pyenv/version)
    3.8.11
  ```

- バージョンの変更

  - 全体

    ```bash
    pyenv global 3.8.11
    ```

  - ディレクトリ内のみ

    ```bash
    pyenv local 3.8.11
    ```

- プログラムのあるディレクトリに移動し，venv作成（ここまでが最初にやるべき作業）

  ```bash
  cd /path/to/program
  python -m venv .venv # これで.venvディレクトリが作成されます．.venvは任意の名前でOKです．
  ```

- venvを有効にする（`conda activate`に相当）

  `(.venv) ~$`と出ればOK．
  
  ```bash
source .venv/bin/activate
  ```
  
- あとは，自由にpipでインストール

  ```bash
  (.venv) ~$ pip install numpy ~~
  ```

## Jupyter実行

- 上記のように仮想環境`.venv`を作成する．

- Jupyterhub上で実行するには，kernelを作成しなければならない

  - `{path/to/project} `は`.venv`上のディレクトリパス
  - `{env name}`は任意の名前
  - `--no-share`はオプション引数．これをつけると，その他のユーザーに環境を公開しない

  ```bash
  bash create_kernel.sh {path/to/project} {env name} [--no-share]
  ```

  

## Github連携

Githubで管理したい場合は，[ここに書いた方法](https://github.com/MIZUNO-CORPORATION/tutorial/wiki/SSH)と同じように設定すればOKです．

```bash
cd ~/.ssh
ssh-keygen -t rsa -f id_git_rsa
chmod 600 id_git_rsa
```

`config`ファイルに以下追記

```bash
vi config

Host github.com
  HostName github.com
  User git
  Port 22
  IdentityFile ~/.ssh/id_git_rsa
  TCPKeepAlive yes
  IdentitiesOnly yes
```

以下で表示される文字列をGithubのSSHの欄にコピペ

```bash 
cat id_git_rsa.pub
```

## 実行ファイルの共有

YoloやOpenPoseなどの実行ファイルを共有するには，`/opt/software`ディレクトリ でbuildする．

※デフォルトでは，他のユーザーは書き込みのみできない（読み込み・実行の権限はある）ようになる．

```bash
cd /opt/software
git clone ~~

# build

# シンボリックリンクを貼る
ln -s /opt/software/~~~~/~~.bin /opt/software/bin/
```

## Visual Studio Code

現状のJupyterhubでは，Intellisenseが効かないので，VSCodeのRemote SSHを使って開発した方が効率上がりそう．

### SSH設定

- 接続元（ローカル側）で，SSHの鍵を設定（Windowsは[Git bash](https://git-scm.com/download/win)をインストールしてください）

  `{hoge}`は任意

  ```bash
  cd ~/.ssh
  ssh-keygen -t rsa -f id_{hoge}_rsa
  # パスフレーズ設定は任意
  ```

- `config`ファイルの編集

  `{username}`は自分のユーザーネーム，`{host}`は任意．

  ```config
  vi ~/.ssh/config
  
  Host {host}
  	HostName 172.16.30.88
  	User {username}
  	Port 22
  	IdentityFile ~/.ssh/id_{hoge}_rsa
  ```

- できた`id_hoge_rsa.pub`を接続先にコピー

  ```bash
  scp ~/.ssh/id_{hoge}_rsa.pub {host}:~
  ```
  
- 接続先（AIサーバー側）にSSHして，公開鍵登録

  ```bash
  ssh {host}
  cat id_jkmlserver_rsa.pub >> .ssh/authorized_keys
  rm id_jkmlserver_rsa.pub
  chmod 600 .ssh/authorized_keys
  ```

- もう一度接続して，パスワードを聞かれなければOK

  ```bash
  ssh {host}
  ```

### VSCode設定

- Visual Studio Codeインストール

  [公式サイト](https://code.visualstudio.com/)からダウンロードして，インストール

- Remote Developmentインストール（本当はRemote SSHでいいけど，せっかくなので全部インストールします）

  ![remote ssh](https://user-images.githubusercontent.com/16914891/104996836-ed0d3b80-5a6b-11eb-9d8e-e49cde240159.JPG)

- 歯車マーク→Settings→Extensions→Remote-SSH→Remote Platform

  `Item`：上記で設定した`{host}`，`Value`：接続先のOSを設定

  ![remote ssh2](https://user-images.githubusercontent.com/16914891/104996849-f26a8600-5a6b-11eb-992d-343b92a2ca59.png)

  

- 左下の＞＜→Remote-SSH: Connect to Host...→`{host}`
  で新しくVSCodeのWindowが立ち上がり，エラーが出なければOK！

  ![remote ssh3](https://user-images.githubusercontent.com/16914891/104996845-f1395900-5a6b-11eb-9b41-423b899b3138.png)

- Open Folderすると．．．

  接続先のディレクトリを接続元のVSCodeで開ける！！

  ![remote ssh4](https://user-images.githubusercontent.com/16914891/104997514-0cf12f00-5a6d-11eb-9371-a42a52219e2c.png)
  
- Extensionが読み込めない場合

  ```bash
  ssh {host}
  rm -rf .vscode-server
  ```


## Fileのダウンロード

Jupyterhubでは，ディレクトリ単位でダウンロードできない（2020/02/18現在）ので，SCPがおすすめ．

※上述のSSH設定をしている必要あり

（Windowsの場合）Git bashを開いて，以下のコマンドでローカルのホームディレクトリにディレクトリごとダウンロードできる．

`{host}`は上述のホスト名，`{hoge}`含め`shared/{hoge}`はJupyterhub上の任意のパス

```bash
scp -r {host}:~/shared/{hoge} ~/
```

