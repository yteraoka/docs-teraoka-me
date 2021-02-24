# gcloud

## ディレクトリ

デフォルトでは `~/.config/gcloud` に設定ファイルとか認証情報の類が配置される

`gcloud init` コマンドを実行することで初期化することができるが、この設定情報は複数持って切り替えることができる

```bash
$ gcloud config configurations
ERROR: (gcloud.config.configurations) Command name argument expected.

Available commands for gcloud config configurations:

      activate                Activates an existing named configuration.
      create                  Creates a new named configuration.
      delete                  Deletes a named configuration.
      describe                Describes a named configuration by listing its
                              properties.
      list                    Lists existing named configurations.

For detailed information on this command and its flags, run:
  gcloud config configurations --help
```

また、このディレクトリは環境変数 `CLOUDSDK_CONFIG` で変更することができる

## ディレクトリ切り替えスクリプト

```zsh
function gcenv {
  case "$1" in
    create)
      if [ -z "$2" ] ; then
        echo "Usage: gcenv create <profile-name>" 1>&2
        return 1
      fi
      if [ ! -d "$HOME/.gcloud/$2" ] ; then
        mkdir -p "$HOME/.gcloud/$2"
        export CLOUDSDK_CONFIG="$HOME/.gcloud/$2"
      else
        echo "already exists" 1>&2
        return 0
      fi
      ;;
    show)
      echo "CLOUDSDK_CONFIG=${CLOUDSDK_CONFIG}"
      echo "GOOGLE_APPLICATION_CREDENTIALS=${GOOGLE_APPLICATION_CREDENTIALS}"
      ;;
    list|ls)
      ls -d $HOME/.gcloud/*
      ;;
    /*)
      if [ -d "$1" ] ; then
        export CLOUDSDK_CONFIG="$1"
      fi
      ;;
    *)
      if [ -z "$1" ] ; then
        export CLOUDSDK_CONFIG=$(ls -d $HOME/.gcloud/* | sort | fzf)
      elif [ -d "$HOME/.gcloud/$1" ] ; then
        export CLOUDSDK_CONFIG="$HOME/.gcloud/$1"
      else
        export CLOUDSDK_CONFIG=$(ls -d $HOME/.gcloud/* | sort | fzf)
      fi
      ;;
  esac
  
  if [ -n "${CLOUDSDK_CONFIG}" ] ; then
    if [ -f "${CLOUDSDK_CONFIG}/application_default_credentials.json" ] ; then
      export GOOGLE_APPLICATION_CREDENTIALS="${CLOUDSDK_CONFIG}/application_default_credentials.json"
    fi
  fi
}
```

## 認証

gcloud コマンドなどで GCP の API にアクセスするためにはログインが必要で、次のコマンドでログインすることができる

```
gcloud auth login --no-launch-browser
```

`--no-launch-browser` をつけない場合は最後に使ったブラウザで承認ウインドウが開くため、複数プロファイルで
ブラウザを使っている場合には嬉しくないことがある


## サービスアカウント

Terraform などを使う場合は ServiceAccount が必要になるが Google Account や Cloud Identity、Google Workspace (G Suite) のアカウントでやりたい
そういう場合に default credential というものが使える

次のコマンドで `~/.config/gcloud/application_default_credentials.json` に作成される

ディレクトリは `CLOUDSDK_CONFIG` が設定されていればそこに作成される

```
gcloud auth application-default login --no-launch-browser
```

これで作成されたファイルの PATH を環境変数 `GOOGLE_APPLICATION_CREDENTIALS` に設定する

## Project 設定

現在の config の project を変更するには次のコマンドを使う

```bash
gcloud config set project PROJECT-ID
```

## 現在の設定確認

```bash
gcloud config list
```

`gcloud config configurations` コマンドで config は複数持って切り替えることが可能

ただし、ファイルに書かれるため shell ごとに切り替えたいという場合はディレクトリを分けて
環境変数 `CLOUDSDK_CONFIG` で切り替える必要がある
