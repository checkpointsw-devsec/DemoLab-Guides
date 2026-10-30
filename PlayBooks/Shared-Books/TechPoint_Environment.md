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

- **ISP1** 
- **ISP2**

in the center of the image below.
<a href="https://checkpointsw-devsec.github.io/DemoLab-Guides/PlayBooks/Shared-Books/index.html" target="_blank" rel="noopener noreferrer">Network topology (open in a new Tab)</a>

<img width="2193" height="1168" alt="image" src="https://github.com/user-attachments/assets/00713b2e-c73f-4ab4-9876-8205d622c3c5" />


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

<img width="755" height="604" alt="image" src="https://github.com/user-attachments/assets/558e509c-7e12-4bbe-838e-ee2e102f601f" />


Connect to your lab over the web link: open the desktop of your admin PC from the tab.

> This option gives you the advantage of getting assistance over a simple chat function and a simple desktop sharing with the instructor.

**Once you are connected to the VMs, please select or add the desired keyboard setting.**

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

<img width="755" height="604" alt="image" src="https://github.com/user-attachments/assets/de697f17-87ae-42bf-8e3a-d5a41ca1355d" />



