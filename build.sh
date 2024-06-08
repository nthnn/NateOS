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
    cargo          \
    musl-tools

git clone --depth 1 https://github.com/minos-org/minos-static.git

if ! command -v rustup &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    source $HOME/.cargo/env
fi

if ! rustup target list | grep -q "x86_64-unknown-linux-musl (installed)"; then
    rustup target add x86_64-unknown-linux-musl
fi

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
cd ..

git clone --depth 1 https://github.com/jmacdonald/amp.git
cd amp
cargo build --target=x86_64-unknown-linux-musl --release
cp ./target/x86_64-unknown-linux-musl/release/amp ../boot-files/initramfs/bin
cd ..

git clone --depth 1 https://github.com/eza-community/eza.git
cd eza
cargo build --target=x86_64-unknown-linux-musl --release
cp ./target/x86_64-unknown-linux-musl/release/eza ../boot-files/initramfs/bin
cd ..

./minos-static/static-get -c
./minos-static/static-get -v -x gcc
cp -r gcc-4.6.1-2/* boot-files/initramfs

./minos-static/static-get -c
./minos-static/static-get -v -x python3.2
cp python3.2-static-raw.githubusercontent.com/python3.2-static boot-files/initramfs/bin/python3
chmod +x boot-files/initramfs/bin/python3

./minos-static/static-get -c
./minos-static/static-get -v -x opt-nodejs-0.8.18-1
cp -r opt-nodejs-0.8.18-1/* boot-files/initramfs/
chmod +x boot-files/initramfs/opt/nodejs/bin/*

./minos-static/static-get -c
./minos-static/static-get -v -x opt-php-7.1.2-1
cp -r opt-php-7.1.2-1/* boot-files/initramfs/
chmod +x boot-files/initramfs/opt/php-7.1/bin/*

./minos-static/static-get -c
./minos-static/static-get -v -x vim
rm vim/bin/vi
chmod +x vim/bin/*
cp -r vim/* boot-files/initramfs/

./minos-static/static-get -c
./minos-static/static-get -v -x git
chmod +x git-1.9.2/bin/*
cp -r git-1.9.2/* boot-files/initramfs/

cd boot-files/initramfs
wget -O bin/pfetch https://raw.githubusercontent.com/dylanaraps/pfetch/master/pfetch
chmod +x bin/pfetch

mkdir -p etc dev man proc sys tmp
mkdir -p etc/init.d

cat <<EOF > etc/init.d/rcS
#!/bin/sh
echo "root:x:0:0:root:/root:/bin/sh" > /etc/passwd
echo "root:x:0:" > /etc/group
echo "root::10933:0:99999:7:::" > /etc/shadow
echo "root:root" | chpasswd

mount -t proc none /proc
mount -t tmpfs none /tmp

mkdir -p /var/run /var/log /var/tmp
mkdir -p /etc/network /etc/ssh

ln -sf /usr/share/zoneinfo/Asia/Manila /etc/localtime
export PATH=$PATH:/usr/libexec/gcc/i586-linux-uclibc/4.6.1:/opt/nodejs/bin:/opt/php-7.1/bin

echo "auto eth0" >> /etc/network/interfaces
echo "iface eth0 inet dhcp" >> /etc/network/interfaces

echo "nateos" > /etc/hostname
hostname $(cat /etc/hostname)
clear

pfetch
echo "Welcome to NateOS v0.0.1"

/bin/sh +m
EOF

ln -s etc/init.d/rcS init
chmod +x etc/init.d/rcS init

rm linuxrc
find . | cpio -o -H newc > ../init.cpio
cd ..

truncate -s 1G nate_os.img
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

echo "Bootable image created successfully as nate_os.img"