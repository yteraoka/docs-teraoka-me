# Go

## クロスコンパイル

`GOOS`, `GOARCH` を指定して go build する

環境変数の一覧は https://golang.org/doc/install/source#environment にある

```bash
GOOS=windows GOARCH=amd64
```

Arm の場合は `GOARM` というのもある。Arm 環境でビルドするなら自動でその version がセットされるが、
クロスコンパイルの場合は設定すると良い。クロスコンパイルで未設定の場合は `6` になる。

うちの古いラズパイは armv6l なので `GOOS=linux GOARCH=arm GOARM=6` とする。
`armv6l` の `l` は Little Endian の意味らしい。`b` の Big Endian もある。

```bash
% uname -m
armv6l
```

GitHub Actions での実行なら [goreleaser](https://github.com/goreleaser/goreleaser) が便利

## Bookmarks

- [Goを学ぶときにつまずきやすいポイントFAQ](https://future-architect.github.io/articles/20190713/)