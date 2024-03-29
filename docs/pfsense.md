# PfSense / network related configuration

## TL/DR

1. Set your domain name to a domain you own or any `.localdomain`
2. If you specified a `10.1.4.0` for the `target_subnet` terraform variable, and assuming a 3 Control-plane and 3 worker node cluster create the folloing static mappings:

 Node Type   | MAC Address         | IP           |
| ---------- | ------------------- | ------------ |
| controller | `00:50:56:80:f3:20` |  `10.1.4.0`  |
| controller | `00:50:56:80:f3:21` |  `10.1.4.1`  |
| controller | `00:50:56:80:f3:22` |  `10.1.4.2`  |
| worker     | `00:50:56:80:f3:30` | `10.1.4.100` |
| worker     | `00:50:56:80:f3:31` | `10.1.4.101` |
| worker     | `00:50:56:80:f3:32` | `10.1.4.102` |

## Long story (Prerequisites)

1. Domain name

   It is advised to have a publicly resolvable domain name. Alternatively you can use one of the reserved DNS names as per [RFC2606-2](https://www.ietf.org/archive/id/draft-chapin-rfc2606bis-00.html#legacy) and [RFC2606-2](https://www.ietf.org/archive/id/draft-chapin-rfc2606bis-00.html#new) like `yourdomainofchoice.localdomain`

2. `/24` subnet that is routable and not used by anything else.

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

If you are simply reusing this code, make sure that the MAC addresses specified [here](https://github.com/atanaspam/homekube-terraform/blob/257d8ff7d6c535ce2e500c3f2ea73ae23031dd15/terraform/variables.tf#L44) and [here](https://github.com/atanaspam/homekube-terraform/blob/257d8ff7d6c535ce2e500c3f2ea73ae23031dd15/terraform/variables.tf#L54) are mapped to IPs `0` to `100` for Control-plane nodes and `100` to `255` for workers.

As defined in the variables.tf file, Control-plane nodes get MAC addresses in the `00:50:56:80:f3:20` - `00:50:56:80:f3:2E`, each increased by one. For example the first Control-plane node gets `00:50:56:80:f3:20`, second one `00:50:56:80:f3:21` third one  `00:50:56:80:f3:22` etc.

Worker nodes get `00:50:56:80:f3:30` - `00:50:56:80:f3:3E` in a simmilar fashion.

As a result you need to create static mappings the following way:

* For each MAC in the Control-plane nodes:
    | MAC Address          | IP                    |
    | -------------------- | --------------------- |
    | `<controller MAC 0>` | `<target_subnet>.0`   |
    | `<controller MAC 1>` | `<target_subnet>.1`   |
    | `<controller MAC 2>` | `<target_subnet>.2`   |
    | `<worker MAC 0>`     | `<target_subnet>.100` |
    | `<worker MAC 1>`     | `<target_subnet>.101` |
    | `<worker MAC 2>`     | `<target_subnet>.102` |
    | ...                  | ...                   |
