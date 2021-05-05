# Route53

## CLI によるレコードの更新

```bash
# zone id の取得
domain=example.com
zone_id=$(basename $(aws route53 list-hosted-zones-by-name --dns-name ${domain} | jq -r ".HostedZones[] | select(.Config.PrivateZone == false) | select(.Name == \"${domain}.\") | .Id"))
```

```json
{
  "Changes": [
    {
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "www.example.com",
        "Type": "A",
        "TTL": 60,
        "ResourceRecords": [
          {
            "Value": "192.168.0.1"
          },
          {
            "Value": "192.168.0.2"
          }
        ]
      }
    }
  ]
}
```

```bash
aws route53 change-resource-record-sets --hosted-zone-id $zone_id --change-batch file://request.json
```

DELETE 時にも結構全部必須とされる

```bash
% aws route53 change-resource-record-sets --hosted-zone-id $zone_id --change-batch '
{
  "Changes": [
    {
      "Action": "DELETE",
      "ResourceRecordSet": {
        "Name": "www.example.com.",
        "Type": "CNAME",
        "TTL": 600,
        "ResourceRecords": [
          {
            "Value": "xxxx-1671238278.ap-northeast-1.elb.amazonaws.com"
          }
        ]
      }
    }
  ]
}
'
```

レスポンス

```json
{
    "ChangeInfo": {
        "Id": "/change/C09876892V612NX8953V2",
        "Status": "PENDING",
        "SubmittedAt": "2021-03-02T02:03:41.597000+00:00"
    }
}
```

get-change で伝搬の状態を確認できる

```bash
% aws route53 get-change --id /change/C09876892V612NX8953V2
{
    "ChangeInfo": {
        "Id": "/change/C09876892V612NX8953V2",
        "Status": "PENDING",
        "SubmittedAt": "2021-03-02T02:03:41.597000+00:00"
    }
}
```

INSYNC になったら完了

```bash
% aws route53 get-change --id /change/C09876892V612NX8953V2
{
    "ChangeInfo": {
        "Id": "/change/C09876892V612NX8953V2",
        "Status": "INSYNC",
        "SubmittedAt": "2021-03-02T02:03:41.597000+00:00"
    }
}
```

```bash
% aws route53 list-resource-record-sets --hosted-zone-id $zone_id --query "ResourceRecordSets[?Name == 'www.example.com.']"
[
    {
        "Name": "www.example.com.",
        "Type": "CNAME",
        "TTL": 600,
        "ResourceRecords": [
            {
                "Value": "xxxx-1671238278.ap-northeast-1.elb.amazonaws.com"
            }
        ]
    }
]
```

