# ascent-proxy-ami

---
### Description
Includes all terraform modules and packer scripts to create an nginx proxy secured with TLS and client certificate authentication using vault.

---
## Developer Instructions
To authenticate to the kibana proxy, you'll need the following:
- The fully qualified domain name (such as dev-kibana.internal.vetservices.gov)
- A signed certificate from the issuing certificate authority so that the kibana site will trust you.
- A trust certificate for of the Certificate Authority so you can trust the kibana site.
#### The fully qualified domain name (fqdn)
For the fqdn, you'll need to know the url of the kibana server. Pretty much whatever is between the 'https://' and the first '/' after that is your fqdn. You'll need this for generating your Certificate Signing Request.

#### Generating your Certificate Signing Request (csr)
To get a signed certificate from your issuing certificate authority, you'll need to first make a certificate signing request (csr) file to send to your ops admin. To generate your CSR file, use the scripts/generate-csr.sh shell script...
```
chmod 755 generate-csr.sh
./generate-csr [my-fully-qualified-domain-name-of-the-kibana-server.com]
```
**Note:** You'll get a lot of questions about the country, organization, etc, but you can keep it all blank and just hit the `Enter` key all the way through.

After running that file, you'll get a [fqdn].key and [fqdn].csr file. Keep the .key file and send the .csr file to your ops administrator.

Once your administrator gets the csr file signed, they will return to you two .crt files. One will be for the CA and the other for your client certificate.

#### Importing the certificates into your keychain (mac)

##### Trusting the Domain of the Proxy
To trust the domain of the site, you're going to need to load the CA certificate file into your system's keychain.

- Open Keychain Access. You can find it by going to your Finder -> Applications -> Utilities folder.

- Load your ca.crt file located in the certs directory by clicking 'System' in the left panel of KeyChain access, followed by clicking 'Certificates' in the bottom left panel, the clicking and dragging the certificate into the middle where all of your certificates reside.

- After you see your CA certificate with all of the others, right click the certificate and choose 'Info'

- After the information window pops up, click the 'Trust' dropdown menu, and choose 'Always Trust' for Secure Socket Layer (SSL) Connections. Close the information window. You'll be prompted for a password for accepting the changes.

#### Authenticating with the Client Certificate
To authenticate to the domain with a client certificate, you're going to need to get your key and your signed certificate into a pkcs12-encoded file. To do this, run the scripts/make-pfx.sh script *in the same directory as your certificate and key.*
```
chmod 755 make-pfx.sh
./make-pfx.sh [my fully qualified domain name of kibana]
```
The script will produce a .pfx file which you will need to load into you're system's keychain.

*Note that these instructions are for a mac.*
- Open Keychain Access. You can find it by going to your Finder -> Applications -> Utilities folder.

- After that, click 'System' in the top left window and click 'My Certificates' in the bottom left window. ***Note that this is different from simply clicking 'Certificates' like what you did for the CA cert.***

- Go to the top menus bar of the Keychain Access application and click File -> Import Items...

- Navigate to the `fully-qualified-domain-name`.pfx file in the certs folder, and choose that file. You'll be prompted for an admin password for System changes and for the password to the pfx file (if you set one). ***You're going to need just this file, not the `domain-name`.crt because it includes the certificate and the key, not just the certificate.***

- Once you've imported the certificate, right click the certificate, choose Info -> the Trust drop-down -> 'Always Trust' for Secure Socket Layer (SSL) Connections. Close the information window. You'll be prompted for a password for accepting the changes.

#### Hitting the url
Once you've trusted everything and have your certs imported to your Keychain, you should be ready to hit the URL of your proxy. The browser will ask you to choose a certificate to authenticate with, and you'll choose the certificate that you loaded earlier into your keychain. You'll then be prompted for a password or two, then you're good to go if everything's set up right. If you are getting an error, go back over the instructions and make sure you didn't miss anything.

---

## Administrator Instructions
### Generating Certificates to Authenticate to the Proxy
When you get a .csr file from a developer, you'll need to submit it to vault to get it signed. To do that, you use the `generate-certificate.sh` script in the scripts directory of this repo.

Before you use the `get-certificate.sh` script...

- You need to know the fully qualified domain name of the proxy server you are hitting. This is the first command line argument that you supply to the script.

- Make sure you are hitting the correct vault address - You can either supply the script with the vault url as the _second_ command line argument, or you can have the script pull it from the `$VAULT_ADDR` environment variable.

- You need to either be authenticated to vault via `vault auth -method=github` or you need to supply the script with the vault token as the _third_ command line argument. Note that it must be the third. This means you can only supply this command line argument if you've provided a vault address.

#### get-certificate.sh usage
```
./get-certificate mydomain.com [vault address] [vault token]  
```

If all goes well, you'll end up with a ca.crt file and a `domain-name`.crt file in the current directory. Send both of these files to the requesting developer.
