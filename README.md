# bash-scripts

# 🔧 Bash Scripts Collection

Welcome to the **Bash Scripts** repository! This is a growing collection of useful and reusable Bash scripts designed to automate and simplify various Linux system administration and networking tasks.

## 📂 Repository Structure

Each script in this repository is self-contained and comes with usage instructions inside the script or below in this README. You can use these scripts as-is, or modify them to suit your specific needs.

## ✅ Available Scripts

### `set_static_ip.sh`
Set a static IP address on Ubuntu 22.04 LTS using Netplan.

**Usage:**
```bash
sudo ./set_static_ip.sh <interface> <ip/mask> <gateway> <dns1> [dns2]
