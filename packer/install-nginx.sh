#!/bin/bash
set -e

echo "[nginx]
name=nginx repo
baseurl=https://nginx.org/packages/rhel/7/x86_64
gpgcheck=0
enabled=1" | sudo tee -a /etc/yum.repos.d/nginx.repo >/dev/null

sudo yum -y install nginx

sudo nginx

# For SSL
sudo mkdir /etc/nginx/certs

curl -I 127.0.0.1
