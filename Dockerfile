# Dockerfile for running SnowCrash VM using QEMU
FROM ubuntu:22.04

# Update and install QEMU and required dependencies
RUN apt-get update && apt-get install -y \
    qemu-system-x86 \
    qemu-utils \
    && rm -rf /var/lib/apt/lists/*

# Create a directory for VM data
WORKDIR /vm

# Copy the ISO file from the host (should be mounted as a volume or provided)
# The ISO should be available in the container at /vm/SnowCrash.iso

# Create script to run the VM
COPY <<EOF /vm/run-vm.sh
#!/bin/bash

# Configuration
VM_NAME="snowcrash-rtire"
DISK_IMAGE="/vm/${VM_NAME}.qcow2"
DISK_SIZE="8G"
RAM_SIZE="2048"
ISO_PATH="/vm/SnowCrash.iso"

# Create disk image if it doesn't exist
if [ ! -f "$DISK_IMAGE" ]; then
    echo "Creating disk image: $DISK_IMAGE ($DISK_SIZE)"
    qemu-img create -f qcow2 "$DISK_IMAGE" "$DISK_SIZE"
fi

# Check if ISO exists
if [ ! -f "$ISO_PATH" ]; then
    echo "Error: ISO file not found at $ISO_PATH"
    echo "Please ensure the ISO is mounted in the docker-compose.yml"
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
    -device e1000,netdev=net0 \
    -display none \
    -daemonize
EOF

RUN chmod +x /vm/run-vm.sh

# Expose the forwarded port
EXPOSE 5555

# Run the VM
CMD ["/vm/run-vm.sh"]
