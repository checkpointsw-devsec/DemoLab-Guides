# TechPoint Environment

## Contents

- [Introduction](#introduction)
- [How to connect](#how-to-connect)
- [Credentials](#credentials)
- [How to access](#how-to-access)
- [Reset or revert a VM](#reset-or-revert-a-vm)

## Introduction

This demo infrastructure is created to give you a flexible playground and tool to demo Check Point security solutions.

The environment represents two different sites connected over two routers with three interfaces:

- **Blue:** vyos1
- **Orange:** vyos2

in the center of the image below.
([link](https://checkpointsw-devsec.github.io/DemoLab-Guides/index.html))

<img width="1655" height="891" alt="network-overview" src="https://github.com/user-attachments/assets/5eb91492-4b5f-410d-baf5-a24fff8396d8" />


**Left block: HQ side**

- 1 x Domain controller
- 1 x Windows 10 client
- 1 x Linux client
- 4 x Full Gaia gateways (2 x ElasticXL + 2 x VSNext enabled)

**Upper right block: Branch 1**

- 1 x Windows 10 client
- 1 x Linux client
- 1 x Full Gaia in ElasticXL mode

**Lower right block: Branch 2**

- 1 x Embedded Gaia gateway in cluster

## How to connect

The instructor will send you an email with a web link.

After receiving your mail:

- Open the link.
- VMs in your lab need 5 to 10 minutes to start after clicking on **"VM List"**.

<img width="2048" height="481" alt="vm-list" src="https://github.com/user-attachments/assets/3cafc4e1-574b-43a9-9712-1bf9008fc4fa" />


Connect to your lab over the web link: open the desktop of your admin PC from the tab.

> This option gives you the advantage of getting assistance over a simple chat function and a simple desktop sharing with the instructor.

**Once you are connected to the VMs, please select or add the desired keyboard setting.**

## Credentials

### Admin-Net and Router

| Host | Creds | ISP1 | ISP2 | Client | Sync | Admin-Net |
|---|---|---|---|---|---|---|
| adminPC | student / Cpwins1! | 10.160.201.254 | | | | |
| ISP1-RTR | vyos / vpn123 | eth2: 10.160.201.65 | | | - | |
| ISP2-RTR | vyos / vpn123 | eth2: 10.160.201.66 | | | | |

### Branch1

| Host | Creds | ISP1 | ISP2 | Client | Sync | Admin-Net |
|---|---|---|---|---|---|---|
| *Subnet* | | 10.160.31.0/24<br>1000:160:31::0/64 | 10.160.32.0/24<br>1000:160:32::0/64 | 172.30.1.0/24<br>a172:30:1::/64 | | 10.160.200.0/24 |
| Branch-gw-1 | admin / vpn123 | eth2: .1 | eth3: .1 | magg1: .1 | | - |
| Branch-Win10 | student@cp-demo / Cpwins1! | | | .70 | | .70 |
| Branch-Linux | uadmin / vpn123 | | | .60 | | .60 |
| ISP1-RTR | vyos / vpn123 | eth3: .254 | | | - | |
| ISP2-RTR | vyos / vpn123 | | eth3: .254 | | - | |

### Branch2

| Host | Creds | ISP1 | ISP2 | Client | Sync | Admin-Net |
|---|---|---|---|---|---|---|
| *Subnet* | | 10.160.41.0/24<br>1000:160:41::/64 | 10.160.42.0/24<br>1000:160:42::/64 | 172.40.1.0/24<br>a172:40:1::/64 | | |
| Branch2-smb-1 | admin / vpn123 | WAN: .1 | DMZ: .1 | LAN2: .1 | | - |
| ISP1-RTR | vyos / vpn123 | eth4: .254 | | | - | - |
| ISP2-RTR | vyos / vpn123 | | eth4: .254 | | - | - |

### HQ

| Host | Creds | ISP1 | ISP2 | Management | Sync | Remote-Access |
|---|---|---|---|---|---|---|
| *Subnet* | | 10.160.11.0/24<br>1000:160::11::/64 | 10.160.12.0/24<br>1000:160::11::/64 | 192.168.30.0/24<br>a192:168:30::/64 | 172.16.10.0/24 | 10.160.200.0/24 |
| HQ-exl-gw | admin / vpn123 | eth2: .2 | eth3: .2 | magg1: .1 | eth1-Sync | - |

### HQ-VSN

| Host | Creds | ISP1 | ISP2 | Management | Sync | Remote-Access |
|---|---|---|---|---|---|---|
| *Subnet* | | 10.160.21.0/24<br>1000:160::21::/64 | 10.160.22.0/24<br>1000:160:22::/64 | 192.168.30.0/24<br>a192:168:30::/64 | 172.16.20.0/24 | 10.160.200.0/24 |
| HQ-vsn-gw | admin / vpn123 | eth2: .10 | eth3: .10 | magg1: .10 | eth1-Syc | - |

### HQ-VMs

| Host | Creds | ISP1 | ISP2 | Management | Sync | Remote-Access |
|---|---|---|---|---|---|---|
| HQ-Win10 | sstudent@cp-demo / Cpwins1! | | | .20 | | .20 |
| HQ-Win-DC | administrator / Cpwins1! | | | .30 | | |
| HQ-Linux | OS: uadmin / vpn123 | | | .40 | | |
| MDS-Global | vpn123 | | | .50 | | |
| MDS-HQ-Domain | vpn123 | | | .51 | | - |

### Additional services on HQ-Linux host (root / vpn123)

- **Radius Server** (administrator / Cpwins1!), access over admin PC: <http://10.160.201.40/daloradius/login.php>
- **Proxy:** config `/etc/squid/squid.conf`, port 3128
- **GitLab** (root / vpn123vpn123), access over admin PC: <https://gitlab.cp-demo.lab>
- **AWX** (admin / vpn123), access over admin PC: <https://gitlab.cp-demo.lab:8443>

### Additional services on Branch-Linux host

> **These services are enabled but not in use at the moment.**

- **Radius Server** (administrator / Cpwins1!), access over admin PC: <http://10.160.201.60/daloradius/login.php>
- **Proxy:** config `/etc/squid/squid.conf`, port 3128

## How to access

Open the **HQ-Win10** or **Branch-Win10** tab to connect to the HQ and Branch side of the infrastructure.

<img width="1067" height="610" alt="win10-tabs" src="https://github.com/user-attachments/assets/32fdaa1d-2bdb-492d-b2f5-194cbbe2fd24" />


Send **Ctrl+Alt+Del** to log in:

- **Username:** student
- **Password:** Cpwins1!

<img width="795" height="719" alt="win10-login" src="https://github.com/user-attachments/assets/a0191d16-0a67-4d91-a2d6-1490b06b2c95" />


Over the **MobaXterm** application you can access:

- Both Branch sites
- HQ site
- Routers

<img width="1062" height="713" alt="mobaxterm-sessions" src="https://github.com/user-attachments/assets/ac02aad2-e9bf-4d50-9063-a14865b084cf" />


## Reset or revert a VM

In the VM List you can go to the VM that you want to reset or revert.

<img width="1079" height="479" alt="reset-revert-vm" src="https://github.com/user-attachments/assets/85edb06e-ac0a-4672-951c-3c77272a0ed5" />

