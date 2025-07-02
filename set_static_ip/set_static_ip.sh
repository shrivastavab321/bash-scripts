#!/bin/bash

# Usage: sudo ./set_static_ip.sh <interface> <static_ip> <gateway> <dns1> [dns2]

INTERFACE="$1"
STATIC_IP="$2"
GATEWAY="$3"
DNS1="$4"
DNS2="$5"

# Function to find netplan config file
get_netplan_file() {
    local files=(/etc/netplan/*.yaml)
    if [ ${#files[@]} -eq 0 ]; then
        echo "❌ No Netplan YAML files found in /etc/netplan/"
        exit 1
    elif [ ${#files[@]} -eq 1 ]; then
        echo "${files[0]}"
    else
        echo "⚠️ Multiple Netplan YAML files found:"
        local i=1
        for f in "${files[@]}"; do
            echo "  [$i] $f"
            ((i++))
        done
        echo -n "Select the file number to modify: "
        read choice
        echo "${files[$((choice-1))]}"
    fi
}

NETPLAN_FILE=$(get_netplan_file)


if [ "$(id -u)" -ne 0 ]; then
  echo "Please run as root: sudo $0 <interface> <ip> <gateway> <dns1> [dns2]"
  exit 1
fi

if [ -z "$INTERFACE" ] || [ -z "$STATIC_IP" ] || [ -z "$GATEWAY" ] || [ -z "$DNS1" ]; then
  echo "Usage: sudo $0 <interface> <ip> <gateway> <dns1> [dns2]"
  exit 1
fi

echo "Creating Netplan configuration..."

cat > "$NETPLAN_FILE" <<EOF
network:
  version: 2
  renderer: networkd
  ethernets:
    $INTERFACE:
      dhcp4: no
      addresses:
        - $STATIC_IP
      gateway4: $GATEWAY
      nameservers:
        addresses:
          - $DNS1
EOF

if [ -n "$DNS2" ]; then
  echo "          - $DNS2" >> "$NETPLAN_FILE"
fi

echo "Applying Netplan configuration..."
netplan apply

if [ $? -eq 0 ]; then
  echo "Static IP set successfully on $INTERFACE"
else
  echo "Failed to apply Netplan configuration"
  exit 2
fi
