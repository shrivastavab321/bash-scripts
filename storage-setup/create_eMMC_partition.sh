#!/bin/bash

DEVICE="/dev/mmcblk0"

echo "WARNING: This will DELETE ALL partitions and data on $DEVICE"
read -p "Type YES to continue: " confirm
if [[ "$confirm" != "YES" ]]; then
    echo "Aborted."
    exit 1
fi

# Unmount all partitions
for part in ${DEVICE}p*; do
    umount "$part" 2>/dev/null
done

# Clear existing partition table
echo "Wiping existing partition table..."
dd if=/dev/zero of=$DEVICE bs=512 count=1 conv=notrunc status=none

# Create partitions using fdisk
echo "Creating new partitions..."
fdisk $DEVICE <<EOF
o       # New DOS partition table

n       # New partition 1 (p1)
p
1
1417792
1417794

n       # New partition 2 (p2)
p
2
1419264
1421311

n       # New partition 3 (p3)
p
3
1421400
8411135

n       # New partition 4 (p4)
p
4
8411200
15307775

t       # Set type for p1
1
83

t       # Set type for p2
2
83

t       # Set type for p3
3
83

t       # Set type for p4
4
83

w       # Write changes
EOF

# Inform kernel of changes
echo "Refreshing partition table..."
sleep 2
partprobe $DEVICE
sleep 1

# Format p2, p3, and p4 with ext4
echo "Formatting partitions..."
for part in p2 p3 p4; do
    mkfs.ext4 "${DEVICE}${part}" -F
done

echo "✅ Done. p2, p3, p4 formatted as ext4. p1 preserved without formatting."
