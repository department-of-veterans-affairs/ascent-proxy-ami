#!/bin/bash

exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

sed -i 's/SERVER_NAME/${server_name}/g' /home/ec2-user/default.conf
sed -i 's|LOCATION_PATH|${location}|g' /home/ec2-user/default.conf
sed -i 's|URL_TO_REDIRECT|${proxy_pass}|g' /home/ec2-user/default.conf
sed -i 's|SERVER_NAME|${server_name}|g' /tmp/templates/ca.crt.tpl
sed -i 's|SERVER_NAME|${server_name}|g' /tmp/templates/server.crt.tpl
sed -i 's|SERVER_NAME|${server_name}|g' /tmp/templates/server.key.tpl

VAULT_TOKEN=$(curl --insecure -X POST "${vault_address}/v1/auth/aws/login" -d '{"role":"vetservices","pkcs7":"'$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/pkcs7 | tr -d '\n')'","nonce":"5defbf9e-a8f9-3063-bdfc-54b7a42a1f95"}' | jq '.auth.client_token' | tr -d '"')

echo "<<DEBUG>>"
echo "[consul-template -once -config="/tmp/templates/consul-template-config.hcl" -vault-addr=${vault_address} -vault-token=$${VAULT_TOKEN}]"

consul-template -once -config="/tmp/templates/consul-template-config.hcl" -vault-addr=${vault_address} -vault-token=$${VAULT_TOKEN}

sudo mv /home/ec2-user/default.conf /etc/nginx/conf.d/default.conf

sudo nginx
