# Argo CD

## Badge 表示できる

https://argo-cd.readthedocs.io/en/stable/user-guide/status-badge/


## Sync Option

大きな ConfigMap などを kubectl apply すると annotation のサイズが 256KB に収まらなくなって
エラーになる。そういう場合は syncOptions を Replace にすることで delete & create されるのでうまくいく。

https://argo-cd.readthedocs.io/en/stable/user-guide/sync-options/#replace-resource-instead-of-applying-changes
