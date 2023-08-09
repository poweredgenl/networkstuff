# Network stuff

This readme describes all the specific network stuff im doing at the house or abroad.

## Routing a /24 PI for home usage 

This readme is to document the setup of routing a /24 PI IP space towards my house via the internet

### Background

As i have a /24 space for some years (17 to be exact) .. and used it in various datacenters for use cases, i thought it might be cool to run this at thome as well. 

At home i have the availability of 2 different ISP's and internet feeds.

- Fiber 1000/1000mbit - connected via a mediaconverter in the house - directly to the switch and firewall (pfSense) 
- LTE 4G 60/30mbit - connected via Huawei USB modem, which is in passthrough mode towards the firewall.

### Goal

- Use the /24 PI space at home with full control of handing out IP's without (double) NATting ports and interfaces.
- Use both internet feeds as possibility to assign public IP's to both of them, depending on the entrypoint. Eg use some of the IP's on the fiber connection, other ones at the LTE connection.
- Use of my own router in the DFZ to make use of the IP space

### New setup 10-03-2023

As of this date - the PI space is routed via my own AS network. I requested a AS nr from RIPE to setup my own ISP/personal internet breakout. The principle stays the same as down below with using tunnels / routing across the 2 links mentioned above here - however now directly connected to my router in the default free zone.

For all information on this project - see my NOC website at https://noc.netone.nl

You can find:

- Picture of the router - yeay :-)
- Peerings active
- BGP routes active
- Updates im doing to the network
- About section with history
- A network weathermap graph on all current traffic volumes.

### Old setup 01-06-2022 - static routes and firewall from a friend

I figured there where a few ways to setup a link. My intention is/was to use GRE tunnels across the internet to an another firewall where the IP's where originally routed to. A friend supplied me with access and has taken care of the BGP announcements and routing towards that firewal. That part is thus covered.

### Challenges

The first challenge i had to overcome was mainly the LTE part. LTE and/or 4G connections regularly use CGNat to provide internet connectivity. Also in my case using the USB modem. This means the usb modem (in passthrough) via a Mikrotik router hands out a RFC1918 address to pfSense, which i cannot use thus for setting up a GRE tunnel. The GRE tunnel requires to have a public ip outbound, and an inbound IP which is direct attached. 

<img src="https://imgur.com/0WMF3KT.jpg" />

To mitigate this issue, still want to use GRE for both the fiber and the LTE connection, i used an outbound VPN setup to create an another layer. 

For this i setup an OpenVPN server on the datacenter firewall which allows for incoming connections from my home firewall. This way i can create a virtual tunnel on which on top i can run my GRE tunnel and routing. 

## Final design

After creating the tunnels i ended up with the following design which allowed me to run the whole show and route the IPs accordingly

<img src="https://imgur.com/Ygb8Fbq.jpg " /> 



