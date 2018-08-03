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

savedir="certs"
mkdir $savedir

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

echo
echo "Generating key request for $domain"
echo

#Generate a key
openssl genrsa -des3 -passout pass:$password -out $savedir/$domain.key 2048 -noout

#Remove passphrase from the key. Comment the line out to keep the passphrase
echo
echo "Removing passphrase from key"
echo
openssl rsa -in $savedir/$domain.key -passin pass:$password -out $savedir/$domain.key

#Create the request
echo
echo "Creating CSR"
echo "You will be prompted for a bunch of values. You're cool just to keep them blank and press Enter a bunch of times."
openssl req -new -key $savedir/$domain.key -out $savedir/$domain.csr -passin pass:$password

echo "---------------------------"
echo "-----Below is your CSR-----"
echo "---------------------------"
echo
cat $domain.csr

echo
echo "---------------------------"
echo "-----Below is your Key-----"
echo "---------------------------"
echo
cat $domain.key


echo
echo "---------------------------"
echo "---- You will find them ---"
echo "----  saved in current  ---"
echo "----      directory     ---"
echo "---------------------------"
echo

csr=$(cat $savedir/$domain.csr | awk '{printf "%s",$0} END {print ""}' | awk '{ sub(/BEGIN CERTIFICATE REQUEST-----/, "BEGIN CERTIFICATE REQUEST-----\\n"); print }' | awk '{ sub(/-----END/, "\\n-----END"); print }')
echo "{ \"csr\" : \"$csr\", \"common_name\" : \"$commonname\"}" >> $savedir/payload.json


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

cd $savedir
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

echo
echo "Creating the pfx file for the Keychain."
echo "You will be prompted for an export password"
echo
openssl pkcs12 -export -out $domain.pfx -inkey $domain.key -in $domain.crt

echo "All certs stored in $savedir"
echo "Load the .pfx and ca.crt files into your system's keychain for authentication and trusting the domain, $domain"
echo "Cleaning up the payload.json and response files..."
rm payload.json
rm response.json
cd ..
echo "Bye!"
