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