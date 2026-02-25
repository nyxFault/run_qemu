#!/usr/bin/env bash

set -e

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <path-to-bzImage> <path-to-trixie.img>"
    exit 1
fi

BZIMAGE="$1"
IMAGE="$2"

if [ ! -f "$BZIMAGE" ]; then
    echo "Error: bzImage not found at $BZIMAGE"
    exit 1
fi

if [ ! -f "$IMAGE" ]; then
    echo "Error: Disk image not found at $IMAGE"
    exit 1
fi

qemu-system-x86_64 \
    -m 2G \
    -smp 2 \
    -kernel "$BZIMAGE" \
    -append "console=ttyS0 root=/dev/sda earlyprintk=serial net.ifnames=0" \
    -drive file="$IMAGE",format=raw \
    -net user,host=10.0.2.10,hostfwd=tcp:127.0.0.1:10021-:22 \
    -net nic,model=e1000 \
    -enable-kvm \
    -nographic \
    -pidfile vm.pid
