# Linux-Secure-Boot-Notes-and-EZ-MOK-Key
Collection of notes and scripts for having secure boot enabled on Linux.

Secureboot is both easy and hard.
Here are some notes regarding getting some stuff done with it in Linux.

With secureboot on, everything from 
EFI Bootloader, to kernel, to drivers, must be signed.

Default keys that are embedded in hardware include manufacturer keys and Microsoft Windows keys.
In general, Linux distros boot from an Microsoft UEFI CA signed EFI shim, which then lets the distros signed kernels to also work. 

This means if you are using secureboot, and you wish to install an out of distro driver or kernel modules such as..
 
The ability to tweak your AMD processor voltages
ryzen_smu
ex. https://gitlab.com/leogx9r/ryzen_smu


or perhaps you need a driver to view your motherboard sensors.. 
Nuvoton NCT6687-R
ex. https://github.com/Fred78290/nct6687d

and you don't have access to your distros signing keys (You don't!) you are out of luck.

These modules will build and compile but the kernel will reject them when booting or modprobing them.

A similar problem arises when you want to use refind as your EFI boot loader as well on your Secure Boot system.

When building DKMS modules on most systems, DKMS will notice you need a signed module and usually create set of keys and certs, called the MOK certificate / key, or Machine Owner Key. It will sign the modules with these but it is your responsibility to enroll the certificate in your machines BIOS. This was the case for me.

Additionally, systemd-boot is NOT supported (as far as I know) if you need out of band drivers as the signed EFI shim only works with the GRUB bootloader and the software, Mok Manager is part of the signed grub package as far as I know.

Additionally, most tutorials and documentation use inconsistent naming for the related files, keys and certs as well as inconsistent placement. I've collected what I know here.

MOK.der - Common name in most tutorials showing how to create your own key.
mok.pub - Created by DKMS (On Debian 12/Proxmox) when trying to install out of band drivers.

Can be found if generated,  
Usually here named:  /var/lib/shim-signed/mok/MOK.priv
Usually here named:  /var/lib/dkms/mok.key

What it is: An x509 certificate (public) in the DER binary format.
Used for: Enrollment into your BIOS to authorize binaries signed with the private key.

--------------------------------
mok.pem - Not referenced or created by DKMS auto sign generator 
MOK.pem - Most tutorials tell you to generate this.

Most tutorials say to create it here: /var/lib/shim-signed/mok/MOK.pem    
Is not present when DKMS module signing happens: /var/lib/dkms/mok.pem

What it is: An x509 certificate (public) in ASCII format. It can be generated from the DER bin format file. (openssl x509 -inform der -in certificate-in-der-format.der -out certificate-in-pem-format.pem

Used for: Signing EFI BINARIES and custom KERNELS.

--------------------------------

mok.key / MOK.key - DKMS auto generates the first. 
MOK.priv - Most tutorials tell you to generate this.

Most tutorials say to create it here:  /var/lib/shim-signed/mok/MOK.priv
DKMS can autogenerate it here named:   /var/lib/dkms/mok.key

What it is: x509 private key (ASCII format) 
Used for: Generating public certificates which the certificates are used for enrollment and signing binaries. Keep it private.


----------------------------------

### How to use all this stuff.

- Either use the previously generated private keys and certs or create your own from scratch. The included bash script can assist with this.
- Once generated, enroll your DER format certificate in your bios, reboot.
- Check/edit your /etc/dkms/framework.conf and make sure your files match the positions in there.
- Recompile your out of band modules with your MOK and they should be able to load.

### Signing a custom kernel or EFI binary 

- To sign an EFI binary or kernel, you need the PEM certificate and your PRIVATE KEY. 
- sbsign --key MOK.privkey.key --cert MOK.cert.pem BINARY.EFI --output BINARY-SIGNED.EFI
- The move / rename the signed binary to where it is needed.
- The same process works for vmlinuz kernels etc.

------------------------------------------


I was successfully able to sign both the EFI and component (kernel + init) of ZFSBootMenu.
However on my system I am only able to boot the component version and could not test the EFI version.


