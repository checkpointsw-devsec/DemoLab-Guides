#!/usr/bin/env bash
cd ~/git-repos/AI-Workshop
#ansible-playbook -i inventories/lab.yml objects.yml
#ansible-playbook -i inventories/lab.yml vpn_community.yml
ansible-playbook -i inventories/lab.yml ai-network-firewall.yml
