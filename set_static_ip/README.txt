🧪 Example Usage

sudo ./set_static_ip.sh enp0s3 192.168.1.100/24 192.168.1.1 8.8.8.8 1.1.1.1

enp0s3 — your network interface name (use ip link show to find it).

192.168.1.100/24 — desired static IP with subnet.

192.168.1.1 — default gateway.

8.8.8.8 1.1.1.1 — primary and optional secondary DNS servers.

🔐 Notes

- Always backup your existing Netplan files (e.g., /etc/netplan/*.yaml) before applying.

- You can test your config with:

bash
netplan try

- To roll back:

bash

sudo mv /etc/netplan/01-static-network.yaml.bak /etc/netplan/01-static-network.yaml
sudo netplan appl
