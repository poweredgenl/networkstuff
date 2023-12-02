# VPP for RHEL 9

This dir contains alpha-alpha :-) testing packages compiled for RHEL 9 for whom wants to use VPP/DPDK.

Please note that this is VERY experimental as im still optimizing / figuring out a proper build proces.

Built on: RHEL 9.3 updated up to 01-12-2023. This version is with the native linux-cp. A new version with IPNG's control plugin will be build later.

To install: (work in progress!)

- download
- dnf remove libibverbs-46.0-1.el9.x86_6
- wget https://rpmfind.net/linux/centos-stream/9-stream/BaseOS/x86_64/os/Packages/libpcap-1.10.0-4.el9.x86_64.rpm
- rpm -Uvh libpcap-1.10.0-4.el9.x86_64.rpm --nodeps
- dnf install libffi-devel net-tools python3-policycoreutils 
- rpm -i vpp*.rpm


## Configuration stuff (WIP!)

THe driver to work with a vmxnet3 adapter needs to be loaded / either manually or at boot:

- modprobe vfio-pci
- ifconfig ens192 down # interface i want to control with VPP/LCPNG
- Disable / let NetworkManager ignore this interface as it conflicts with the bootstrap file in the next step.

create a file (eg 'ignore.conf') in /etc/NetworkManager/conf.d/ and add the following:

[main]
plugins=ifcfg-rh,keyfile
[keyfile]
unmanaged-devices=mac:00:11:22:33:44:55
  
- Follow instructions at https://ipng.ch/s/articles/2021/12/23/vpp-playground.html to create a similar bootstrap file for adding your interface.


