############################################################
              create_eMMC_partition.sh
###########################################################


How to Run:

chmod +x fdisk_partition.sh
sudo ./fdisk_partition.sh


what exactly this script will do:

  -Deletes all existing partitions on /dev/mmcblk0.

  -Creates new partitions (p1, p2, p3, p4) using fdisk.

  -Formats p2, p3, and p4 as ext4.

  -Leaves p1 untouched (not formatted).


⚠️  Warning:

This script will destroy existing data on /dev/mmcblk0. Run only if you're sure.
