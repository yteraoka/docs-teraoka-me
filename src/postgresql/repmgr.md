# repmgr

- https://repmgr.org/
- https://github.com/EnterpriseDB/repmgr

## Vagrant で試す

RHEL8

```
[vagrant@db1 ~]$ sudo subscription-manager status
+-------------------------------------------+
   System Status Details
+-------------------------------------------+
Overall Status: Unknown

System Purpose Status: Unknown


WARNING

The yum/dnf plugins: /etc/dnf/plugins/subscription-manager.conf were automatically enabled for the benefit of Red Hat Subscription Management. If not desired, use "subscription-manager config --rhsm.auto_enable_yum_plugins=0" to block this behavior.
```

```
[vagrant@db1 ~]$ sudo subscription-manager list
+-------------------------------------------+
    Installed Product Status
+-------------------------------------------+
Product Name:   Red Hat Enterprise Linux for x86_64
Product ID:     479
Version:        8.3
Arch:           x86_64
Status:         Unknown
Status Details: 
Starts:         
Ends:           
```

```
[vagrant@db1 ~]$ sudo subscription-manager register --username rh-teraoka --password liss4VAUX@lo1supt --name db1
Registering to: subscription.rhsm.redhat.com:443/subscription
The system has been registered with ID: 5ae1cb3b-fcdc-4674-85b0-54adbc684227
The registered system name is: db1

WARNING

The yum/dnf plugins: /etc/dnf/plugins/subscription-manager.conf were automatically enabled for the benefit of Red Hat Subscription Management. If not desired, use "subscription-manager config --rhsm.auto_enable_yum_plugins=0" to block this behavior.
```

```
[vagrant@db1 ~]$ sudo subscription-manager attach
Installed Product Current Status:
Product Name: Red Hat Enterprise Linux for x86_64
Status:       Subscribed
```

```
[vagrant@db1 ~]$ sudo subscription-manager list
+-------------------------------------------+
    Installed Product Status
+-------------------------------------------+
Product Name:   Red Hat Enterprise Linux for x86_64
Product ID:     479
Version:        8.3
Arch:           x86_64
Status:         Subscribed
Status Details: 
Starts:         04/17/2021
Ends:           04/17/2022
```

## Vagrantfile

```
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "generic/rhel8"

  config.vm.define :db1 do |m|
    m.vm.hostname = "db1"
    m.vm.provider "virtualbos" do |v|
      v.memory = 512
    end
    m.vm.network :private_network, ip: "192.168.33.11"
    m.vm.provision "shell", path: "setup.sh"
  end

  config.vm.define :db2 do |m|
    m.vm.hostname = "db2"
    m.vm.provider "virtualbos" do |v|
      v.memory = 512
    end
    m.vm.network :private_network, ip: "192.168.33.12"
    m.vm.provision "shell", path: "setup.sh"
  end

  config.vm.define :db3 do |m|
    m.vm.hostname = "db3"
    m.vm.provider "virtualbos" do |v|
      v.memory = 512
    end
    m.vm.network :private_network, ip: "192.168.33.13"
    m.vm.provision "shell", path: "setup.sh"
  end
end
```
