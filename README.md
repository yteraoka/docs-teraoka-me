# honkit でドキュメント管理

https://github.com/honkit/honkit

## docker build

honkit 環境は docker image に封じ込めるため必要なものを入れた image を作る

```
./docker-build.sh
```

`myhonkit:latest` という image が作られる


## serve

```
./serve.sh
```

`docker run` で `--init` をつけないと Ctrl-C ですぐに終了してくれなかった


## build

```
./build.sh
```

src 内の Markdown ファイルなどから docs ディレクトリに HTML などを出力する

`docs` を GitHub Pages で後悔する


## 参考資料

- https://zenn.dev/mebiusbox/articles/703e934c78fa20
- https://qiita.com/tukiyo3/items/6c9c51de8745878624e9
- https://qiita.com/ktat/items/028175492b0512ccb88c

