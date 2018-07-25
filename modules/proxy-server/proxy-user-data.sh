#!/bin/bash

exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

sed -i 's/SERVER_NAME/${server_name}/g' /home/ec2-user/default.conf
sed -i 's|LOCATION_PATH|${location}|g' /home/ec2-user/default.conf
sed -i 's|URL_TO_REDIRECT|${proxy_pass}|g' /home/ec2-user/default.conf
sed -i 's|SERVER_NAME|${server_name}|g' /tmp/templates/ca.crt.tpl
sed -i 's|SERVER_NAME|${server_name}|g' /tmp/templates/server.crt.tpl
sed -i 's|SERVER_NAME|${server_name}|g' /tmp/templates/server.key.tpl

consul-template -once -config="/tmp/templates/consul-template-config.hcl" -vault-addr=${vault_address} -vault-token=${vault_token}

sudo mv /home/ec2-user/default.conf /etc/nginx/conf.d/default.conf
sudo chmod 755 /home/ec2-user/run-nginx.sh

sudo nginx
