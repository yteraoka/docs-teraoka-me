# Azure

## AZ LOGIN

```bash
az login [-u user@domain]
```

## AZ ACCOUNT SHOW

今どのアカウントでログインしているかなどの確認

```bash
az account show
```

## AKS の KUBECONFIG 取得

```bash
az aks get-credentials --resource-group myResourceGroup --name myAKSCluster
```

clusterAdmin

```bash
az aks get-credentials --resource-group myResourceGroup --name myAKSCluster --admin
```

## AAD

https://github.com/Azure/aad-pod-identity


## Microsoft のクラウド Azure の入門講座を和訳した (後編)

https://qiita.com/chomado/items/439eeea4b3ce318fb5a8
