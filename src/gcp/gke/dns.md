# DNS

GKE の DNS サーバー (kube-dns) は skydns で、kube-dns-autoscaler が必要に応じて pod の数を増やす。

さらには node-local-dns を addon で有効にすることで DaemonSet がデプロイされる。
