#!/bin/bash

xDER="pubcert.der"
xPRV="privkey.key"
xPEM="pubcert.pem"


sigINFO='/CN=SomeIdentifier/emailAddress=user@mailservice.com/'
# '/C=US/ST=California/L=Sunnyvale/O=MOC/CN=FakeUser/emailAddress=fakeuser@example.com/name=Faker'

echo "Generating private key, $1.$xPRV and public key/cert, $1.$xDER in DER binary format."
openssl req -nodes -new -x509 -newkey rsa:2048 -keyout $1.$xPRV -outform DER -out $1.$xDER -days 365000 -subj "${sigINFO}"

echo "Generating certificate, $1.$xPEM which is suitable for signing EFI & Kernel binaries"
openssl x509 -inform der -in $1.$xDER -out $1.$xPEM

echo "Printing DER certificate info.."
openssl x509 -inform der -in $1.$xDER -text -noout
echo "-------------------------------------------------------------------------"
echo -e "\n\n"
echo "FILES CREATED"
echo "-------------------------------------------------------------------------"
echo "$1.$xDER      - Use for ENROLLING INTO BIOS/EFI.                          CERTIFICATE, BINARY"  
echo "$1.$xPEM      - Use for SIGNING EFI & KERNEL BINARIES.                    CERTIFICATE, TEXT"
echo "$1.$xPRV      - KEEP SAFE FROM PRYING EYES, if security is your thing.    PRIVATE KEY, TEXT"

# ENROLLING
echo -e "\n"
echo "MOK Key Enrollment"
echo "-------------------------------------------------------------------------"
echo "To enroll your generated key/certs please run the following command:"
echo -e "mokutil --import $1.$xDER \n"

echo -e "To view keys queued to install during reboot, please run the following command:"
echo -e 'mokutil --list-new \n'

echo "After a reboot, check if your key is installed via:"
echo -e 'mokutil --list-enrolled '

# Signing binaries
echo -e "\n"
echo "Signing EFI BINARIES and KERNELS"
echo "-------------------------------------------------------------------------"
echo "To sign an EFI binary or kernel, use a command like this:"
echo "sbsign --key $1.$xPRV --cert $1.$xPEM BINARY.EFI --output BINARY-SIGNED.EFI"


# OTHER INFORMATION 
# Generate an X.509 certificate and a private key:
# openssl 
# req                   request a new key 
#  -nodes               don't encrypt private key
#  -new                 create a new certificate request, or to start the certification process.
#  -x509                output as an X.509 certificate (default for -out is PEM)
#  -newkey rsa:2048     specify that a new unique key should be generated during the process,
#                        and it will have RSA type with size of 2048 bits
#  -keyout MOK.priv     write the newly created private key to this file.
#  -outform DER         output format. If you want to use your certificate in Windows, you need to convert it from PEM (default) to DER.
#  -out MOK.der         specify where to save the generated X509 certificate
#  -days 365000         set the number of days for which this certificate will be valid.
#  -subj "/CN"          specifies the subject line in the format /C=XX/ST=XXX/L=XXXX/O=XXX/CN=XXX/emailAddress=XXX/name=XXX



