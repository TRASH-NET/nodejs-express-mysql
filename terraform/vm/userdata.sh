#!/usr/bin/env bash
set -x
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
export PATH="$PATH:/usr/bin"
sleep 10
sudo apt update
sudo apt install -y git python3-pip ansible
pip3 install ansible
git clone https://github.com/TRASH-NET/nodejs-express-mysql.git
cd nodejs-express-mysql/ansible
ansible-playbook mysql.yml