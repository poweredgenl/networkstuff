# Put your ideas for the NetOne user portal here

- Peering sessions management
- Peeringdb login
- Downstream ASSET management
- Status of peering/transit/downstream sessions
- Sentryflow data for your ASN
- ... your wishes ... amend via MR/PR

- **Service Dashboard** – Show all active services, connections, VLANs, peerings and their current operational status in one place.
- **BGP Onboarding Wizard** – Guide customers through ASN, prefixes, peer IPs, route options, IRR and RPKI checks before activation.
- **IP & Peering Details** – Clearly show local/remote IP addresses, ASN, VLAN ID, MTU, MAC address and interface details for each connection.
- **Live BGP Status** – Display session state, uptime, last reset reason, received prefixes and advertised prefixes per peer.
- **Prefix Management** – Allow customers to add or request prefixes and track their status from requested to active.
- **IRR & RPKI Validation** – Automatically check route/route6 objects, origin ASN and ROA status, with clear warnings when something is missing or invalid.
- **Route Filtering Visibility** – Show which prefixes are accepted, rejected or filtered by NetOne, including the exact reason for rejection.
- **BGP Policy Options** – Allow customers to choose options such as default route, full table, communities, AS-path prepending and blackholing where supported.
- **Configuration Generator** – Generate ready-to-use configurations for FRR, BIRD, MikroTik, Juniper and Cisco based on the customer’s actual connection details.
- **BGP Pre-flight Check** – Validate Layer 2, Layer 3, TCP/179, ASN, IRR, RPKI and prefix filters before putting a session into production.
- **Looking Glass** – Let customers inspect how NetOne sees their prefixes, including AS-path, communities, MED, local preference and next-hop.
- **Route Propagation Check** – Show whether an announced prefix is visible within NetOne, upstream providers and public route collectors.
- **VLAN & Interface Overview** – Show VLAN IDs, tagged/untagged delivery, associated interfaces, MAC addresses, traffic counters and errors.
- **Monitoring & Alerts** – Provide latency, packet loss, traffic and BGP monitoring, with notifications for session loss, route changes or RPKI problems.
- **Maintenance & Outage Information** – Show planned maintenance and incidents specifically relevant to the customer’s own services and locations.
- **Audit Log** – Keep a history of configuration changes, prefix changes, routing-policy changes and user actions.
