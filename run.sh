#!/bin/bash

# Configuration
VM_NAME="snowcrash-rtire"
DISK_IMAGE="${VM_NAME}.qcow2"
RAM_SIZE="2048"

# Launch VM from disk (after installation)
echo "Starting VM from disk..."
qemu-system-x86_64 \
    -enable-kvm \
    -m "$RAM_SIZE" \
    -hda "$DISK_IMAGE" \
    -netdev user,id=net0,hostfwd=tcp::5555-:4242 \
    -device e1000,netdev=net0
