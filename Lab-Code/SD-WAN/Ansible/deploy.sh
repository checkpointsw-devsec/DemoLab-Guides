#!/usr/bin/env bash
cd ~/git-repos/understanding-sd-wan-policy
#ansible-playbook -i inventories/lab.yml objects.yml
#ansible-playbook -i inventories/lab.yml vpn_community.yml
ansible-playbook -i inventories/lab.yml rules_branch.yml
ansible-playbook -i inventories/lab.yml rules_dc.yml
