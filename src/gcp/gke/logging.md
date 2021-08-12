# GKE の logging

- [GKE 用 Google Cloud のオペレーション スイートの概要](https://cloud.google.com/stackdriver/docs/solutions/gke?hl=ja)
- [GKE 用 Cloud Operations への移行](https://cloud.google.com/stackdriver/docs/solutions/gke/migration?hl=ja)
- [構造化ロギング](https://cloud.google.com/logging/docs/structured-logging?hl=ja)
- [GKE ログの管理](https://cloud.google.com/stackdriver/docs/solutions/gke/managing-logs?hl=ja)

JSON で出力して [severity](https://cloud.google.com/logging/docs/reference/v2/rest/v2/LogEntry?hl=ja#LogSeverity) field を設定するのが良い

時刻は [時間関連フィールド](https://cloud.google.com/logging/docs/agent/configuration?hl=ja#timestamp-processing) を設定しておくとそこから timestamp に取り出してくれる
