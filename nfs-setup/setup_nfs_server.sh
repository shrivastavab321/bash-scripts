#!/bin/bash

# Usage: sudo ./setup_nfs_server.sh [share_dir] [client_ip_subnet]

SHARE_DIR="${1:-/srv/nfs/share}"
CLIENT_SUBNET="${2:-*(rw,sync,no_subtree_check)}"

# "Assign to VAR the value of $1 (the first argument to the script) if it is provided and not empty."

# "Otherwise, use the default value."

# * → wildcard for any IP/client

# rw → read/write access

# sync → changes are written immediately (safer)

# no_subtree_check → skips subtree validation for performance

# Colors
GREEN="\e[32m"
RED="\e[31m"
RESET="\e[0m"

echo -e "${GREEN}📦 Installing NFS server packages...${RESET}"
apt update
apt install -y nfs-kernel-server

echo -e "${GREEN}📁 Creating shared directory at $SHARE_DIR...${RESET}"
mkdir -p "$SHARE_DIR"
chmod 777 "$SHARE_DIR"

echo -e "${GREEN}📝 Configuring /etc/exports...${RESET}"

# Backup existing exports
cp /etc/exports /etc/exports.bak

# Add new export
echo "$SHARE_DIR $CLIENT_SUBNET" >> /etc/exports

echo -e "${GREEN}🔄 Exporting shared directories...${RESET}"
exportfs -ra

echo -e "${GREEN}🚀 Enabling and starting NFS server...${RESET}"
systemctl enable nfs-server
systemctl restart nfs-server

echo -e "${GREEN}✅ NFS Server setup complete!${RESET}"
echo -e "🔗 Shared directory: ${SHARE_DIR}"
echo -e "🌐 Client access rule: ${CLIENT_SUBNET}"
echo -e "📄 Original exports file backed up to /etc/exports.bak"
