# ascent-proxy-ami

---
### Description
Includes all terraform modules and packer scripts to create an nginx proxy secured with TLS and client certificate authentication using vault.

---
### Generating Certificates to Authenticate to the Proxy
We have automated the process of generating a csr, submitting it to vault to be signed, creating a .pfx file to load into the local keychain.

Before you use the `get-certificate.sh` script...

- You need to know the fully qualified domain name of the proxy server you are hitting. This is the first command line argument that you supply to the script

- Make sure you are hitting the correct vault address - You can either supply the script with the vault url as the _second_ command line argument, or you can have the script pull it from the `$VAULT_ADDR` environment variable.

- You need to either be authenticated to vault via `vault auth -method=github` or you need to supply the script with the vault token as the _third_ command line argument.

#### get-certificate.sh usage
```
./get-certificate mydomain.com [vault address] [vault token]  
```

The script will prompt for values for the csr, you can leave all of the values empty.

The script will also prompt you twice for a password for the pfx file, supply the password and make note of it for when you import the certs into your keychain.



### Importing the certificates into your keychain (mac)
After the get-certificate script runs, it will create a directory called certs. The contents of the directory are the key, csr, certificate, ca certificate, and the pkcs12-encoded file (extension .pfx).

#### Trusting the Domain of the Proxy
To trust the domain of the site, you're going to need to load the ca.crt file into your system's keychain.

- Open Keychain Access. You can find it by going to your Finder -> Applications -> Utilities folder.

- Load your ca.crt file located in the certs directory by clicking 'System' in the left panel of KeyChain access, followed by clicking 'Certificates' in the bottom left panel, the clicking and dragging the certificate into the middle where all of your certificates reside.

- After you see your CA certificate with all of the others, right click the certificate and choose 'Info'

- After the information window pops up, click the 'Trust' dropdown menu, and choose 'Always Trust' for Secure Socket Layer (SSL) Connections. Close the information window. You'll be prompted for a password for accepting the changes.

#### Authenticating with the Client Certificate
To authenticate to the domain with a client certificate, you're going to need to load the pkcs12-encoded file into you're system's keychain.

- Open Keychain Access. You can find it by going to your Finder -> Applications -> Utilities folder.

- After that, click 'System' in the top left window and click 'My Certificates' in the bottom left window. ***Note that this is different from simply clicking 'Certificates' like what you did for the CA cert.***

- Go to the top menus bar of the Keychain Access application and click File -> Import Items...

- Navigate to the `domain-name`.pfx file in the certs folder, and choose that file. You'll be prompted for an admin password for System changes and for the password to the pfx file. ***You're going to need this file, not the `domain-name`.crt because it includes the certificate and the key, not just the certificate.***

- Once you've imported the certificate, right click the certificate, choose Info -> the Trust drop-down -> 'Always Trust' for Secure Socket Layer (SSL) Connections. Close the information window. You'll be prompted for a password for accepting the changes.

#### Hitting the url
Once you've trusted everything and have your certs imported to your Keychain, you should be ready to hit the URL of your proxy. The browser will ask you to choose a certificate to authenticate with, and you'll choose the certificate that you loaded earlier into your keychain. You'll then be prompted for a password or two, then you're good to go if everything's set up right.
