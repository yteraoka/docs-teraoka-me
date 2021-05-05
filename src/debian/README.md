# Debian (Ubuntu)

## パッケージに含まれるファイルを確認する

```
dpkg-query -L <package_name>
```

```
dpkg-deb -c <package_name.deb>
```

### インストールされていないパッケージの場合

```
sudo apt-get install apt-file
sudo apt-file update
```

この後

```
apt-file list <package_name>
```
