# Route53

## CLI によるレコードの更新

```bash
# zone id の取得
zone_id=$(basename $(aws route53 list-hosted-zones-by-name --dns-name $domain | jq -r '.HostedZones[] | select(.Config.PrivateZone == false) | .Id'))
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
