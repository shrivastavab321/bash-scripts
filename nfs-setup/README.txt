
🧪 Example Usage for setup_nfs_server

sudo ./setup_nfs_server.sh /srv/nfs/data 192.168.1.0/24(rw,sync,no_subtree_check)
This shares /srv/nfs/data with clients in 192.168.1.0/24 subnet.

Clients will have read/write access with syncing.

🔐 Notes
Firewall: If ufw is enabled, allow NFS ports:


sudo ufw allow from 192.168.1.0/24 to any port nfs
Security: You can tighten permissions by adjusting /etc/exports options.

🧪 Example Usage for setup_nfs_client

sudo ./setup_nfs_client.sh 192.168.1.100 /srv/nfs/share /mnt/nfs_share --persist
This mounts the NFS share from 192.168.1.100:/srv/nfs/share to /mnt/nfs_share

Adds it to /etc/fstab so it mounts automatically on reboot

 🔐 Notes
-To verify the mount:

df -h | grep nfs

-To test manually:

showmount -e 192.168.1.100