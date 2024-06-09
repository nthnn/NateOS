qemu-system-x86_64 \
    -m 512M \
    -vga std \
    -drive file=nate_os.img,format=raw \
    -nic user,hostfwd=tcp::8888-:22 \
    -netdev user,id=n0 \
    -device virtio-net-pci,netdev=n0
