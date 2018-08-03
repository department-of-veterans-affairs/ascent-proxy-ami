#!/bin/bash

curl -s -L -o consul-template_0.19.0_linux_amd64.tgz https://releases.hashicorp.com/consul-template/0.19.0/consul-template_0.19.0_linux_amd64.tgz; \
    sudo tar -xzf consul-template_0.19.0_linux_amd64.tgz; \
    sudo mv consul-template /usr/local/bin/consul-template; \
    sudo chmod +x /usr/local/bin/consul-template; \
    sudo rm -f consul-template_0.19.0_linux_amd64.tgz
