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

基本的には，Anacondaの仮想環境の作り方と同じです．（最後だけちょっと違います）

- 任意の名前で仮想環境を作成

  ```bash
  conda create -n {env name} python=*.*
  ```

- アクティベートしてパッケージのインストール

  ```bash
  conda activate {env name}
  conda install {package name, e.g: numpy}
  ```

- Jupyter用のカーネル作成

  共有する場合

  ```bash
  bash create_kernel.sh {env name}
  ```

  共有しない場合

  ```bash
  bash create_kernel.sh {env name} --no-share
  ```

- `Syntax Error`がでるとき

  ```bash
  conda parso list
  ```

  で`parso`のバージョンを確認して，それより下のバージョンにダウングレード．

  ```bash
  conda install parso=*.*
  ```

- File > Log Outから一回ログアウトして，Launcherをみると，`Python(env name)`というKernelが追加されているので，それをクリックすればOK．


  ![kernel.png](https://user-images.githubusercontent.com/63040751/101456179-04d6a780-3977-11eb-82d9-8ad8516921cb.png)



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

- 接続元で，SSHの鍵を設定

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
  
- 接続先にSSHして，公開鍵登録

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