apt install        \
    bzip2          \
    git            \
    make           \
    gcc            \
    libncurses-dev \
    flex           \
    bison          \
    bc             \
    cpio           \
    libelf-dev     \
    libssl-dev     \
    syslinux       \
    dosfstools     \
    rustc          \
    cargo

git clone --depth 1 https://github.com/torvalds/linux.git
cd linux
make defconfig
make -j 4
mkdir -p ../boot-files
cp arch/x86/boot/bzImage ../boot-files
cd ..

git clone --depth 1 https://git.busybox.net/busybox
cd busybox
make defconfig
sed -i 's/# CONFIG_STATIC is not set/CONFIG_STATIC=y/' .config
make -j 4
mkdir -p ../boot-files/initramfs
make CONFIG_PREFIX=../boot-files/initramfs install

cd ../boot-files/initramfs
mkdir -p etc dev man proc sys tmp

cat <<EOF > etc/init.d/rcS
#!/bin/sh
echo "root:x:0:0:root:/root:/bin/sh" > etc/passwd
echo "root:x:0:" > etc/group
echo "root::10933:0:99999:7:::" > etc/shadow
echo "root:root" | chpasswd

mount -t proc none /proc
mount -t tmpfs none /tmp

mkdir -p /var/run /var/log /var/tmp
mkdir -p etc/init.d etc/network etc/ssh

ln -sf /usr/share/zoneinfo/Asia/Manila /etc/localtime

echo "nateos" > /etc/hostname
echo "auto eth0" >> /etc/network/interfaces
echo "iface eth0 inet dhcp" >> /etc/network/interfaces

clear
echo "Welcome to NateOS v0.0.1"
/bin/sh +m
EOF

ln -s etc/init.d/rcS init
chmod +x etc/init.d/rcS init

rm linuxrc
find . | cpio -o -H newc > ../init.cpio
cd ..

truncate -s 50M nate_os.img
mkfs -t fat nate_os.img
syslinux nate_os.img

mkdir temp
mount nate_os.img temp
cp bzImage init.cpio temp
cat <<EOF > temp/syslinux.cfg
DEFAULT linux
    SAY Booting up NateOS image drive...
LABEL linux
    KERNEL bzImage
    INITRD init.cpio
    APPEND quiet loglevel=3 root=/dev/ram0 init=/init rw
EOF
umount temp
rm -rf temp

mv nate_os.img ..
cd ..
# rm -rf boot-files

echo "Bootable image created successfully as nate_os.img"