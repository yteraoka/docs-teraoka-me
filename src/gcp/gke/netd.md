# netd

DaemonSet

https://github.com/GoogleCloudPlatform/netd

```
% k get cm netd-config -o yaml | neat
```

```yaml
apiVersion: v1
data:
  cni_spec_name: 10-gke-ptp.conflist
  cni_spec_template: |-
    {
      "name": "gke-pod-network",
      "cniVersion": "0.3.1",
      "plugins": [
        {
          "type": "@cniType",
          "mtu": @mtu,
          "ipam": {
              "type": "host-local",
              "ranges": [
              @ipv4Subnet@ipv6SubnetOptional
              ],
              "routes": [
                {"dst": "0.0.0.0/0"}@ipv6RouteOptional
              ]
          }
        },
        {
          "type": "portmap",
          "capabilities": {
            "portMappings": true
          }
        }@cniBandwidthPlugin@cniCiliumPlugin
      ]
    }
  enable_bandwidth_plugin: "true"
  enable_calico_network_policy: "false"
  enable_cilium_plugin: "true"
  enable_masquerade: "false"
  enable_policy_routing: "true"
  enable_private_ipv6_access: "false"
  master_ip: 172.31.254.2
  reconcile_interval_seconds: 60s
kind: ConfigMap
metadata:
  labels:
    addonmanager.kubernetes.io/mode: Reconcile
  name: netd-config
  namespace: kube-system
```
