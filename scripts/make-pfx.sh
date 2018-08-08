#!/bin/bash
domain=$1
if [ -z "$domain" ]
then
    echo "Argument not present."
    echo "Useage $0 [common name]"

    exit 99
fi

if [ ! -f "$domain.key" ]
then
    echo "$domain.key not present. Please make sure you have a private key generated in this directory and that you have a signed certificate"
    exit 99
fi

if [ ! -f "$domain.crt" ]
then
    echo "$domain.crt not present. Please make sure that you have a signed certificate by the name of $domain.crt in this directory and that you have a private key with the same name."
    exit 99
fi

echo
echo "-----------------------------------------------"
echo "Creating the pfx file for the Keychain."
echo "You will be prompted for an export password"
echo "-----------------------------------------------"
echo
openssl pkcs12 -export -out $domain.pfx -inkey $domain.key -in $domain.crt

echo "Load the .pfx and ca.crt files into your system's keychain for authentication and trusting the domain, $domain"
echo "Bye!"
