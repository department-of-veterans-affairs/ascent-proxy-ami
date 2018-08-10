#!/bin/bash

#Required
domain=$1
vault_url=$2
vault_token=$3
commonname=$domain


#Change to your company details
country=""
state=""
locality=""
organization=""
organizationalunit=""
email=""

#Optional
password=dummypassword

if [ -z "$domain" ]
then
    echo "Argument not present."
    echo "Useage $0 [common name]"

    exit 99
fi

if [ -z "$vault_url" ]
then
    echo "Vault URL argument not present."
    echo "Check for environment variable"
    if [ -z "$VAULT_ADDR" ]
    then
        echo "VAULT_ADDR environment variable not provided either."
        echo "Useage: $0 [common name] [vault url]"
        echo
        echo "If [vault url] not provided, check environment variable"
        exit 99
    else
        vault_url=$VAULT_ADDR
    fi
fi

if [ -z "$vault_token" ]
then
    echo "Vault Token argument not present."
    echo "Check for ${HOME}/.vault-token..."
    if [ ! -f "${HOME}/.vault-token" ]
    then
        echo "${HOME}/.vault-token is not present either."
        echo "You need to either provide the vault token as"
        echo "   third arugment..."
        echo "Useage: $0 [common name] [vault url] [vault token]"
        echo "   Or, authenticate to vault using..."
        echo "vault auth -method=github"
        exit 99
    else
        vault_token=$(cat ${HOME}/.vault-token)
    fi
fi


csr=$(cat $domain.csr | awk '{printf "%s",$0} END {print ""}' | awk '{ sub(/BEGIN CERTIFICATE REQUEST-----/, "BEGIN CERTIFICATE REQUEST-----\\n"); print }' | awk '{ sub(/-----END/, "\\n-----END"); print }')
echo "{ \"csr\" : \"$csr\", \"common_name\" : \"$commonname\"}" >> payload.json


echo
echo "---------------------------"
echo "--- Submitting csr to   ---"
echo "---     vault at        ---"
echo
echo "$vault_url"
echo
echo "---     using token     ---"
echo
echo "$vault_token"
echo
echo "---------------------------"
echo

curl -k --header "X-Vault-Token: $vault_token" --request POST --data @payload.json $vault_url/v1/pki/sign/vetservices >> response.json

cat response.json | jq '.data.certificate' | awk '{ gsub(/\"/, ""); print }' | awk '{ gsub(/\\n/, "\n"); print }' >> $domain.crt
cat response.json | jq '.data.issuing_ca' | awk '{ gsub(/\"/, ""); print }' | awk '{ gsub(/\\n/, "\n"); print }'  >> ca.crt

echo
echo "---------------------------"
echo "-----  Below is your  -----"
echo "-----   signed cert   -----"
echo "---------------------------"
echo
cat $domain.crt

echo
echo "---------------------------"
echo "-----  Below is your  -----"
echo "-----     CA cert     -----"
echo "---------------------------"
echo
cat ca.crt
