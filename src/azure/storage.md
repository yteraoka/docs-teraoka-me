# Azure Storage

- Amazon S3 や Google Cloud Storage 同様、Storage Account 名は Global でユニークである必要がある
- ただし、Azure の場合はアルファベットの小文字と数字しか使えず、3文字から24文字までにする必要がある

## Redundancy

https://docs.microsoft.com/en-us/azure/storage/common/storage-redundancy

durability は高いが availability は 99.9% 程度

### Locally-redundant storage (LRS)

- 単一データセンター内に3つのコピーを持つ
- 99.999999999% (11 nines) durability (耐久性) (年間)
- 最も低コスト
- サーバー、ラック、ストレージの故障に対応
- 書き込みは 3 つのコピーへの書き込みが完了してからレスポンスが返される

### Zone-redundant storage (ZRS)

- リージョン内の 3 つの AZ にコピーが保存される
- 99.9999999999% (12 9's) over の durability (耐久性) (年間)
- Zone 障害に備えて exponential back-off つきの retry を検討するべし
- 書き込みは 3 つの AZ のコピーが完了してからレスポンスが返される
- 全てのリージョン、全ての Storage account type がサポートされているわけではない
- 例えば Japan East は対応しているが Japan West は非対応 (2021-03-03)

### Geo-redundant storage (GRS)

- Secondary リージョンへ複製を持つことでリージョン障害への耐性を持つ
- Primary リージョンと Secondary リージョンの組みは決まっており、任意の組み合わせを選択することはできない
- Primary, Secondary それぞれで LRS (特定ゾーン内での3つのコピー) が保持される
- 単一ゾーン内にしか保存されないため、リージョン障害でなくても Secondary へ切り替える必要が発生する可能性がある
- Secondary リージョンのデータへアクセスするためにはフェイルオーバーを行う必要がある
- 99.99999999999999% (16 9's) over の durability (耐久性) (年間)
- 書き込みは Primary の LRS への書き込み完了後に非同期で Secondary にコピーされる

https://docs.microsoft.com/en-us/azure/storage/common/storage-redundancy#read-access-to-data-in-the-secondary-region

https://docs.microsoft.com/en-us/azure/storage/common/storage-disaster-recovery-guidance

### Geo-zone-redundant storage (GZRS)

- GRS との違いは Primary が ZRS (3つのゾーンにコピー) されることだけ
- Secondary は LRS (単一ゾーン内の3つのコピー)
- general-purpose v2 storage accounts だけをサポート

対応リージョン

- Asia Southeast
- Europe North
- Europe West
- Japan East
- UK South
- US Central
- US East
- US East 2
- US West 2

## Data integrity

定期的に cyclic redundancy checks (CRCs) でチェックされており、不整合が見つかればコピーから復元される


## Types of storage accounts

Terraform では account_kind という項目

- **General-purpose v2 accounts**
  - BLOB、ファイル、キュー、およびテーブルの基本的なストレージアカウントタイプ
  - AzureStorage を使用するほとんどのシナリオに推奨される
- **General-purpose v1 accounts**
  - General-purpose v2 を使うべき
- **BlockBlobStorage accounts**
  - Block BLOB および Append BLOB の優れたパフォーマンス特性を備えたストレージアカウント
  - トランザクション率が高いシナリオ、またはより小さなオブジェクトを使用するシナリオ、または一貫して低いストレージレイテンシを必要とするシナリオに推奨される
- **FileStorage accounts**
  - プレミアムパフォーマンス特性を備えたファイルのみのストレージアカウント
  - エンタープライズまたは高性能スケールのアプリケーションに推奨される
- **BlobStorage accounts**
  - General-purpose v2 を使うべき

FileStorage と BlockBlobStorage では account tier を Premium にする必要がある

