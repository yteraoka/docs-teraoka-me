# anetd

DaemonSet

実体は Cilium (`k8s-app: cilium`)

```
% k get cm cilium-config -o yaml | neat
```

```yaml
apiVersion: v1
data:
  auto-direct-node-routes: "false"
  blacklist-conflicting-routes: "false"
  bpf-lb-sock-hostns-only: "true"
  bpf-map-dynamic-size-ratio: "0.0025"
  bpf-policy-map-max: "16384"
  cluster-name: default
  cni-chaining-mode: generic-veth
  custom-cni-conf: "true"
  debug: "false"
  enable-auto-protect-node-port-range: "true"
  enable-bpf-clock-probe: "true"
  enable-bpf-masquerade: "false"
  enable-endpoint-health-checking: "false"
  enable-endpoint-routes: "true"
  enable-host-firewall: "false"
  enable-hubble: "true"
  enable-ipv4: "true"
  enable-ipv6: "false"
  enable-local-node-route: "false"
  enable-local-redirect-policy: "true"
  enable-metrics: "true"
  enable-redirect-service: "true"
  enable-remote-node-identity: "true"
  enable-well-known-identities: "false"
  enable-xt-socket-fallback: "true"
  identity-allocation-mode: crd
  install-iptables-rules: "true"
  ipam: kubernetes
  k8s-api-server: https://172.31.254.2:443
  k8s-require-ipv4-pod-cidr: "true"
  k8s-require-ipv6-pod-cidr: "false"
  kube-proxy-replacement: strict
  local-router-ip: 169.254.4.6
  masquerade: "false"
  monitor-aggregation: medium
  monitor-aggregation-flags: all
  monitor-aggregation-interval: 5s
  node-port-bind-protection: "true"
  operator-api-serve-addr: 127.0.0.1:9234
  operator-prometheus-serve-addr: :6942
  preallocate-bpf-maps: "false"
  prometheus-serve-addr: :9990
  sidecar-istio-proxy-image: cilium/istio_proxy
  tofqdns-enable-poller: "false"
  tunnel: disabled
  wait-bpf-mount: "false"
kind: ConfigMap
metadata:
  labels:
    addonmanager.kubernetes.io/mode: Reconcile
  name: cilium-config
  namespace: kube-system
```