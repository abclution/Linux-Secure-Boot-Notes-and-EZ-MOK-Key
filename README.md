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

Additionally, systemd-boot is NOT supported (as far as I know) if you need out of band drivers as the signed EFI shim only works with the GRUB bootloader.


