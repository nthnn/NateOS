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

cd ../boot-files/initramfs/
echo -e '#!/bin/sh\n\n/bin/sh .bash_profile\n/bin/sh +m' > init
chmod +x init

cat <<EOF > .bash_profile
clear
echo "Welcome to NateOS v0.0.1"
EOF

rm linuxrc
find . | cpio -o -H newc > ../init.cpio
cd ..

truncate -s 200M nate_os.img
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
rm -rf boot-files

echo "Bootable image created successfully as nate_os.img"