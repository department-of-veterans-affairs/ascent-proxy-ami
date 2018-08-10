#!/bin/bash
#Required
domain=$1
commonname=$domain

echo
echo "Generating key request for $domain"
echo

password=dummypassword

#Generate a key
openssl genrsa -des3 -passout pass:$password -out $domain.key 2048 -noout

#Remove passphrase from the key. Comment the line out to keep the passphrase
echo
echo "Removing passphrase from key"
echo
openssl rsa -in $domain.key -passin pass:$password -out $domain.key

#Create the request
echo
echo "---------------------------"
echo "Creating CSR"
echo "You will be prompted for a bunch of values. You're cool just to keep them blank and press Enter a bunch of times."
echo "---------------------------"
openssl req -new -key $domain.key -out $domain.csr -passin pass:$password

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
