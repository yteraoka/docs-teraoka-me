# EC2

## SessionManager と send-ssh-public-key を組み合わせて SSH 接続する

### send-ssh-public-key での public key 登録

`aws ec2-instance-connect send-ssh-public-key` コマンドで一時的 (60秒間だけ有効) な public key の登録が可能

```bash
aws ec2-instance-connect send-ssh-public-key \
  --instance-id i-xxxxxxxxxxxxxxxxx \
  --instance-os-user ec2-user \
  --availability-zone ap-northeast-1c \
  --ssh-public-key file://$HOME/.ssh/id_rsa.pub
```

availability-zone をいちいち指定するのは面倒なので instance-id から aws コマンドで取得する

```bash
aws ec2 describe-instances \
  --instance-ids i-xxxxxxxxxxxxxxxxx \
  --query 'Reservations[0].Instances[0].Placement.AvailabilityZone' \
  --output text
```

## Instance Id 一覧の取得

```
aws ec2 describe-instances \
  --query 'Reservations[].Instances[].InstanceId, Reservations[].Instances[].InstanceType' \
  --output text
```
