#!/bin/bash

echo "starting playbook"
export ANSIBLE_HOST_KEY_CHECKING=false 
ansible-playbook -i hosts test.yml -v  -e 'host_key_checking=False'

exit 0
