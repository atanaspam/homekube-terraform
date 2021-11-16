# PfSense related configuration

## Prerequisites

1. Domain name
It is advised to have a publicly resolvable domain name. Alternatively you can use one of the reserved DNS names as per [RFC2606-2](https://www.ietf.org/archive/id/draft-chapin-rfc2606bis-00.html#legacy) and [RFC2606-2](https://www.ietf.org/archive/id/draft-chapin-rfc2606bis-00.html#new) like `yourdomainofchoice.localdomain`


Configurations
* Set the `Domain` to a valid (preferrably one you own) domain in `System -> General Setup`
* Make sure Static DHCP is enabled in `Services -> DNS Resolver`


Create DHCP reservations for your cluster nodes
* Create static mappings for the hosts that will make up your cluster in `Services -> DHCP Server`
    `MAC Address` - set that to a mac address of your choice. I use the `00:50:56:XX:XX:XX` space since it belongs to VMWare. Make sure this is unique accross all your VMs.
    `Client Identifier` - A name for your


Create Virtual IP (Loadbalancer) for your control-plane-endpoint
* Create a virtual IP I use the last valid IP within the kubernetes IP space (10.1.4.255)
* Fiddle with Nat :(
