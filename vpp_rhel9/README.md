# VPP for RHEL 9

This dir contains alpha-alpha :-) testing packages compiled for RHEL 9 for whom wants to use VPP/DPDK.

Please note that this is VERY experimental as im still optimizing / figuring out a proper build proces.

Built on: RHEL 9.3 updated up to 01-12-2023. This version is with the native linux-cp. A new version with IPNG's control plugin will be build later.

To install: (work in progress!)

1 download
2 dnf remove libibverbs-46.0-1.el9.x86_6
3 dnf install libffi-devel net-tools python3-policycoreutils libpcap
3 rpm -i vpp*.rpm
