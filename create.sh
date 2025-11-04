#!/bin/bash

# Configuration
VM_NAME="snowcrash-rtire"
DISK_IMAGE="${VM_NAME}.qcow2"
DISK_SIZE="8G"
RAM_SIZE="2048"  # 2GB in MB
ISO_PATH="/path/to/your/linux.iso"  # Change this to your ISO path

# Create disk image if it doesn't exist
if [ ! -f "$DISK_IMAGE" ]; then
    echo "Creating disk image: $DISK_IMAGE ($DISK_SIZE)"
    qemu-img create -f qcow2 "$DISK_IMAGE" "$DISK_SIZE"
fi

# Check if ISO exists
if [ ! -f "$ISO_PATH" ]; then
    echo "Error: ISO file not found at $ISO_PATH"
    echo "Please set the correct ISO_PATH in the script"
    exit 1
fi

# Launch VM with ISO (for installation)
echo "Starting VM with ISO..."
qemu-system-x86_64 \
    -enable-kvm \
    -m "$RAM_SIZE" \
    -hda "$DISK_IMAGE" \
    -cdrom "$ISO_PATH" \
    -boot d \
    -netdev user,id=net0,hostfwd=tcp::5555-:4242 \
    -device e1000,netdev=net0
