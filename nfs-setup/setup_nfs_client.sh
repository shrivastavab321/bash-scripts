#!/bin/bash

# Usage: sudo ./setup_nfs_client.sh <server_ip> <remote_share_path> <local_mount_point> [--persist]

SERVER_IP="$1"
REMOTE_PATH="$2"
LOCAL_MOUNT="$3"
PERSIST="$4"

# Colors
GREEN="\e[32m"
RED="\e[31m"
RESET="\e[0m"

# Validate inputs
if [ -z "$SERVER_IP" ] || [ -z "$REMOTE_PATH" ] || [ -z "$LOCAL_MOUNT" ]; then
  echo -e "${RED}Usage: sudo $0 <server_ip> <remote_share_path> <local_mount_point> [--persist]${RESET}"
  exit 1
fi

echo -e "${GREEN}📦 Installing NFS client packages...${RESET}"
apt update
apt install -y nfs-common

echo -e "${GREEN}📁 Creating mount point at $LOCAL_MOUNT...${RESET}"
mkdir -p "$LOCAL_MOUNT"

echo -e "${GREEN}🔗 Mounting NFS share: $SERVER_IP:$REMOTE_PATH -> $LOCAL_MOUNT${RESET}"
mount -t nfs "$SERVER_IP:$REMOTE_PATH" "$LOCAL_MOUNT"

if [ $? -ne 0 ]; then
  echo -e "${RED}❌ Failed to mount NFS share. Please check server and network.${RESET}"
  exit 2
fi

# Persist if requested
if [ "$PERSIST" == "--persist" ]; then
  echo -e "${GREEN}📝 Adding mount to /etc/fstab for persistence...${RESET}"
  echo "$SERVER_IP:$REMOTE_PATH $LOCAL_MOUNT nfs defaults 0 0" >> /etc/fstab
fi

echo -e "${GREEN}✅ NFS client setup complete!${RESET}"
echo -e "📂 Mounted at: $LOCAL_MOUNT"
