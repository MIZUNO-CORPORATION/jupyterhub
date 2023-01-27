# Welcome to Mizuno-Colab!!

このファイルは，マニュアルを記述したファイルなので，削除しないでください．

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


## Fileのダウンロード

Jupyterhubでは，ディレクトリ単位でダウンロードできない（2020/02/18現在）ので，SCPがおすすめ．

※上述のSSH設定をしている必要あり

（Windowsの場合）Git bashを開いて，以下のコマンドでローカルのホームディレクトリにディレクトリごとダウンロードできる．

`{host}`は上述のホスト名，`{hoge}`含め`shared/{hoge}`はJupyterhub上の任意のパス

```bash
scp -r {host}:~/shared/{hoge} ~/
```

