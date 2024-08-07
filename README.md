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

these modules will build and compile but the kernel will reject them when booting or modprobing them.
