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

  ```bash
  bash create_kernel.sh {env name}
  ```

- Launcherをみると，`Python(env name)`というKernelが追加されているので，それをクリックすればOK．


  ![kernel.png](https://user-images.githubusercontent.com/63040751/101456179-04d6a780-3977-11eb-82d9-8ad8516921cb.png)