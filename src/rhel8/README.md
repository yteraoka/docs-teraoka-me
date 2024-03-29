# Red Hat Enterprise Linux 8

Red Hat Developer Program で 16 システムで RHEL 8 が使える

https://rheb.hatenablog.com/entry/developer-program

https://www.publickey1.jp/blog/21/red_hat_enterprise_linux16okred_hat.html

dnf リポジトリを使う為には subscription 登録が必要

## アカウント登録

- https://developers.redhat.com/register
- https://developers.redhat.com/login
- https://access.redhat.com/management


## subscription-manager でシステムの登録

https://nwengblog.com/redhat-memo/

```
sudo subscription-manager register --username rh-teraoka --password PASSWORD [--name HOSTNAME]
```

```
sudo subscription-manager attach
```

https://access.redhat.com/management/systems で登録されたシステムを確認することができる

不要になったら `remove` と `unregister` で解除して `clean` でローカルのファイルをきれいにする（のかな）

```
$ sudo subscription-manager remove --all
1 local certificate has been deleted.
1 subscription removed at the server.
```

```
$ sudo subscription-manager unregister
Unregistering from: subscription.rhsm.redhat.com:443/subscription
System has been unregistered.
```

```
$ sudo subscription-manager clean
All local data removed
```

## Ansible でやる方法

https://qiita.com/hiroyuki_onodera/items/85c06d0d7a15aaea97a6
