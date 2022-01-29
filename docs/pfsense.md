# PfSense / network related configuration

## TL/DR

1. Set your domain name to a domain you own or any `.localdomain`
2. If you use a `10.0.0.0/8` local network, for a 3 controller and 3 worker node cluster create the folloing static mappings:
|     MAC Address     |      IP      |
| ------------------- | ------------ |
| `00:50:56:80:f3:20` |  `10.1.4.0`  |
| `00:50:56:80:f3:21` |  `10.1.4.1`  |
| `00:50:56:80:f3:22` |  `10.1.4.2`  |
| `00:50:56:80:f3:30` | `10.1.4.100` |
| `00:50:56:80:f3:31` | `10.1.4.101` |
| `00:50:56:80:f3:32` | `10.1.4.102` |

## Long story (Prerequisites)

1. Domain name

   It is advised to have a publicly resolvable domain name. Alternatively you can use one of the reserved DNS names as per [RFC2606-2](https://www.ietf.org/archive/id/draft-chapin-rfc2606bis-00.html#legacy) and [RFC2606-2](https://www.ietf.org/archive/id/draft-chapin-rfc2606bis-00.html#new) like `yourdomainofchoice.localdomain`

2. Another?

## Configurations

* Set the `Domain` to a valid (preferrably one you own) domain in `System -> General Setup`
* Make sure Static DHCP is enabled in `Services -> DNS Resolver`

Create DHCP reservations for your cluster nodes

* Create static mappings for the hosts that will make up your cluster in `Services -> DHCP Server`
    `MAC Address` - set that to a mac address of your choice. Please read below to understand the MAC and IP addresses this automation expects.

    `Client Identifier` - A name for your

<!-- TODO decide if I am needed
Create Virtual IP (Loadbalancer) for your control-plane-endpoint

* Create a virtual IP I use the last valid IP within the kubernetes IP space (10.1.4.255)
* Fiddle with Nat :( -->

Static Mapping MAC addresses

If you are simply reusing this code check the MAC addresses specified [here](https://github.com/atanaspam/homekube-terraform/blob/257d8ff7d6c535ce2e500c3f2ea73ae23031dd15/terraform/variables.tf#L44) and [here](https://github.com/atanaspam/homekube-terraform/blob/257d8ff7d6c535ce2e500c3f2ea73ae23031dd15/terraform/variables.tf#L54), and make sure those have the appropriate static mappings.

This automation uses the `00:50:56:XX:XX:XX` space since it belongs to VMWare.

As defined in the variables.tf file, Controller nodes get MAC addresses in the `00:50:56:80:f3:20` - `00:50:56:80:f3:2E`, each increased by one. For example the first controller gets `00:50:56:80:f3:20`, second one `00:50:56:80:f3:21` third one  `00:50:56:80:f3:22` etc.

Worker nodes get `00:50:56:80:f3:30` - `00:50:56:80:f3:3E` in a simmilar fashion.

As a result you need to create static mappings the following way:

* For a 3 controller and 3 worker node cluster:
    `00:50:56:80:f3:20` -> `10.1.4.0`,
    `00:50:56:80:f3:21` -> `10.1.4.1`,
    `00:50:56:80:f3:22` -> `10.1.4.2`.

    `00:50:56:80:f3:30` -> `10.1.4.100`,
    `00:50:56:80:f3:31` -> `10.1.4.101`,
    `00:50:56:80:f3:32` -> `10.1.4.102`.
