# Network stuff

This readme describes all the specific network stuff im doing at the house or abroad.

## Managing a 9HA network infrastructure as volunteer

[ soon ! ]

## Routing a /24 PI across the internet to my home

This readme is to document the setup of routing a /24 PI IP space towards my house via the internet

### Background

As i have a /24 space for some years (17 to be exact) .. and used it in various datacenters for use cases, i thought it might be cool to run this at thome as well. 

At home i have the availability of 2 different ISP's and internet feeds.

- Fiber 1000/1000mbit - connected via a mediaconverter in the house - directly to the switch and firewall (pfSense) 
- LTE 4G 60/30mbit - connected via Huawei USB modem, which is in passthrough mode towards the firewall.

### Goal

- Use the /24 PI space at home with full control of handing out IP's without (double) NATting ports and interfaces.
- Use both internet feeds as possibility to assign public IP's to both of them, depending on the entrypoint. Eg use some of the IP's on the fiber connection, other ones at the LTE connection

### Intended setup

I figured there where a few ways to setup a link. My intention is/was to use GRE tunnels across the internet to an another firewall where the IP's where originally routed to. A friend supplied me with access and has taken care of the BGP announcements and routing towards that firewal. That part is thus covered.

### Challenges

The first challenge i had to overcome was mainly the LTE part. LTE and/or 4G connections regularly use CGNat to provide internet connectivity. Also in my case using the USB modem. This means the usb modem (in passthrough) via a Mikrotik router hands out a RFC1918 address to pfSense, which i cannot use thus for setting up a GRE tunnel. The GRE tunnel requires to have a public ip outbound, and an inbound IP which is direct attached. 

See https://imgur.com/a/3vtqfUQ

