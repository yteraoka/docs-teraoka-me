# Hashicorp Vault

- https://future-architect.github.io/articles/20190713/
- https://learn.hashicorp.com/tutorials/vault/getting-started-help?in=vault/getting-started
- https://learn.hashicorp.com/tutorials/terraform/secrets-vault?in=vault/secrets-management
- https://learn.hashicorp.com/tutorials/vault/oidc-auth?in=vault/auth-methods
- https://learn.hashicorp.com/tutorials/vault/getting-started-policies
- https://github.com/hashicorp/vault-guides/tree/master/identity/oidc-auth

## Secret Engine

path を指定して Secret Engine を有効にする。
デフォルトでは Secret Engine と同名の path で設定される。
例えば aws なら `aws/` になる。

```bash
vault secrets enable -path=aws aws
```

デフォルトでは `secret/` という path で kv Engine が有効になっている

```bash
% vault secrets list
Path          Type         Accessor              Description
----          ----         --------              -----------
aws/          aws          aws_8d7be6d3          n/a
cubbyhole/    cubbyhole    cubbyhole_1cc2c6b0    per-token private secret storage
identity/     identity     identity_5c824d0b     identity store
secret/       kv           kv_4e25297c           key/value secret storage
sys/          system       system_30fd9b1a       system endpoints used for control, policy and debugging
```

## Policy

Policy でアクセスを制御する。Policy は HCL で定義する。

```bash
% vault policy list
default
root
```

`root` policy には何も含まれていない。

> The root policy does not contain any rules but can do anything within Vault. It should be used with extreme care.

`default` は次のようになっている。

```
% vault policy read default
# Allow tokens to look up their own properties
path "auth/token/lookup-self" {
    capabilities = ["read"]
}

# Allow tokens to renew themselves
path "auth/token/renew-self" {
    capabilities = ["update"]
}

# Allow tokens to revoke themselves
path "auth/token/revoke-self" {
    capabilities = ["update"]
}

# Allow a token to look up its own capabilities on a path
path "sys/capabilities-self" {
    capabilities = ["update"]
}

# Allow a token to look up its own entity by id or name
path "identity/entity/id/{{identity.entity.id}}" {
  capabilities = ["read"]
}
path "identity/entity/name/{{identity.entity.name}}" {
  capabilities = ["read"]
}


# Allow a token to look up its resultant ACL from all policies. This is useful
# for UIs. It is an internal path because the format may change at any time
# based on how the internal ACL features and capabilities change.
path "sys/internal/ui/resultant-acl" {
    capabilities = ["read"]
}

# Allow a token to renew a lease via lease_id in the request body; old path for
# old clients, new path for newer
path "sys/renew" {
    capabilities = ["update"]
}
path "sys/leases/renew" {
    capabilities = ["update"]
}

# Allow looking up lease properties. This requires knowing the lease ID ahead
# of time and does not divulge any sensitive information.
path "sys/leases/lookup" {
    capabilities = ["update"]
}

# Allow a token to manage its own cubbyhole
path "cubbyhole/*" {
    capabilities = ["create", "read", "update", "delete", "list"]
}

# Allow a token to wrap arbitrary values in a response-wrapping token
path "sys/wrapping/wrap" {
    capabilities = ["update"]
}

# Allow a token to look up the creation time and TTL of a given
# response-wrapping token
path "sys/wrapping/lookup" {
    capabilities = ["update"]
}

# Allow a token to unwrap a response-wrapping token. This is a convenience to
# avoid client token swapping since this is also part of the response wrapping
# policy.
path "sys/wrapping/unwrap" {
    capabilities = ["update"]
}

# Allow general purpose tools
path "sys/tools/hash" {
    capabilities = ["update"]
}
path "sys/tools/hash/*" {
    capabilities = ["update"]
}

# Allow checking the status of a Control Group request if the user has the
# accessor
path "sys/control-group/request" {
    capabilities = ["update"]
}
```

### Policy を作成する

```
$ vault policy write my-policy - << EOF
# Dev servers have version 2 of KV secrets engine mounted by default, so will
# need these paths to grant permissions:
path "secret/data/*" {
  capabilities = ["create", "update"]
}

path "secret/data/foo" {
  capabilities = ["read"]
}
EOF
```

`vault policy write -h` でヘルプを確認することができる。

```
% vault policy list
default
my-policy
root
```

```
% vault policy read my-policy
# Dev servers have version 2 of KV secrets engine mounted by default, so will
# need these paths to grant permissions:
path "secret/data/*" {
  capabilities = ["create", "update"]
}

path "secret/data/foo" {
  capabilities = ["read"]
}
```

### Policy を指定して token を作成する

```
% vault token create -policy=my-policy
Key                  Value
---                  -----
token                s.EcbgRDFEjvut2iLdUx83heYT
token_accessor       rc9HAxlw8i9HWKhn78P9kHip
token_duration       768h
token_renewable      true
token_policies       ["default" "my-policy"]
identity_policies    []
policies             ["default" "my-policy"]
```

この token を使った場合は `my-policy` が適用される。

`secret/` 配下への put は可能。([kv-v2](https://www.vaultproject.io/docs/secrets/kv/kv-v2/) は data という subpath が入る)

```
% VAULT_TOKEN=s.EcbgRDFEjvut2iLdUx83heYT vault kv put secret/creds password="my-long-password"
Key              Value
---              -----
created_time     2021-04-09T11:35:46.371454Z
deletion_time    n/a
destroyed        false
version          1
```

`secret/` 配下でも `secret/data/foo` は read しか許可していないため、put には失敗する。

```
% VAULT_TOKEN=s.EcbgRDFEjvut2iLdUx83heYT vault kv put secret/foo robot=beepboop               
Error writing data to secret/data/foo: Error making API request.

URL: PUT http://127.0.0.1:8200/v1/secret/data/foo
Code: 403. Errors:

* 1 error occurred:
	* permission denied
```

また、put した `secret/creds` も get はできない。

```
% VAULT_TOKEN=s.EcbgRDFEjvut2iLdUx83heYT vault kv get secret/creds
Error reading secret/data/creds: Error making API request.

URL: GET http://127.0.0.1:8200/v1/secret/data/creds
Code: 403. Errors:

* 1 error occurred:
	* permission denied
```

sys への権限もないため、`vault policy list` や `vault secrets list` はエラーになる。
