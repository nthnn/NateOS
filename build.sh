 #!/bin/sh
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

if [ ! -d "minos-static" ]; then
    git clone --depth 1 https://github.com/minos-org/minos-static.git
fi

if ! command -v rustup &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    source $HOME/.cargo/env
fi

if ! rustup target list | grep -q "x86_64-unknown-linux-musl (installed)"; then
    rustup target add x86_64-unknown-linux-musl
fi

if [ ! -d "linux" ]; then
    git clone --depth 1 https://github.com/torvalds/linux.git
fi

cd linux
make defconfig
sed -i 's/# CONFIG_NET is not set/CONFIG_NET=y/' .config
sed -i 's/# CONFIG_NETDEVICES is not set/CONFIG_NETDEVICES=y/' .config
sed -i 's/# CONFIG_ETHERNET is not set/CONFIG_ETHERNET=y/' .config
sed -i 's/# CONFIG_TUN is not set/CONFIG_TUN=y/' .config
sed -i 's/# CONFIG_E1000 is not set/CONFIG_E1000=y/' .config
sed -i 's/# CONFIG_VIRTIO_NET is not set/CONFIG_VIRTIO_NET=y/' .config
make -j $(nproc)
mkdir -p ../boot-files
cp arch/x86/boot/bzImage ../boot-files
cd ..

if [ ! -d "busybox" ]; then
    git clone --depth 1 https://git.busybox.net/busybox
fi

cd busybox
make defconfig
sed -i 's/# CONFIG_STATIC is not set/CONFIG_STATIC=y/' .config
sed -i 's/# CONFIG_IFCONFIG is not set/CONFIG_IFCONFIG=y/' .config
sed -i 's/# CONFIG_UDHCPC is not set/CONFIG_UDHCPC=y/' .config
sed -i 's/# CONFIG_PING is not set/CONFIG_PING=y/' .config
make oldconfig
make -j $(nproc)
mkdir -p ../boot-files/initramfs
make CONFIG_PREFIX=../boot-files/initramfs install
cd ..

if [ ! -d "amp" ]; then
    git clone --depth 1 https://github.com/jmacdonald/amp.git
fi

cd amp
cargo build --target=x86_64-unknown-linux-musl --release
cp ./target/x86_64-unknown-linux-musl/release/amp ../boot-files/initramfs/bin
cd ..

if [ ! -d "eza" ]; then
    git clone --depth 1 https://github.com/eza-community/eza.git
fi

cd eza
cargo build --target=x86_64-unknown-linux-musl --release
cp ./target/x86_64-unknown-linux-musl/release/eza ../boot-files/initramfs/bin
cd ..

if [ ! -d "broot" ]; then
    git clone --depth 1 https://github.com/Canop/broot.git
fi

cd broot
cargo build --target=x86_64-unknown-linux-musl --release
cp ./target/x86_64-unknown-linux-musl/release/broot ../boot-files/initramfs/bin
cd ..

if [ ! -d "loc" ]; then
    git clone --depth 1 https://github.com/cgag/loc.git
fi

cd loc
cargo build --target=x86_64-unknown-linux-musl --release
cp ./target/x86_64-unknown-linux-musl/release/loc ../boot-files/initramfs/bin/
cd ..

if [ ! -d "bottom" ]; then
    git clone --depth 1 https://github.com/ClementTsang/bottom.git
fi

cd bottom
cargo build --target=x86_64-unknown-linux-musl --release
cp ./target/x86_64-unknown-linux-musl/release/btm ../boot-files/initramfs/bin/
cd ..

if [ ! -d "hex" ]; then
    git clone --depth 1 https://github.com/sitkevij/hex.git
fi

cd hex
cargo build --target=x86_64-unknown-linux-musl --release
cp ./target/x86_64-unknown-linux-musl/release/hx ../boot-files/initramfs/bin/
cd ..

if [ ! -d "gcc-4.6.1-2" ]; then
    ./minos-static/static-get -c
    ./minos-static/static-get -v -x gcc
fi
cp -r gcc-4.6.1-2/* boot-files/initramfs

if [ ! -d "python3.2-static-raw.githubusercontent.com" ]; then
    ./minos-static/static-get -c
    ./minos-static/static-get -v -x python3.2
fi
cp python3.2-static-raw.githubusercontent.com/python3.2-static boot-files/initramfs/bin/python3
chmod +x boot-files/initramfs/bin/python3

if [ ! -d "opt-nodejs-0.8.18-1" ]; then
    ./minos-static/static-get -c
    ./minos-static/static-get -v -x opt-nodejs-0.8.18-1
fi
cp -r opt-nodejs-0.8.18-1/* boot-files/initramfs/
chmod +x boot-files/initramfs/opt/nodejs/bin/*

if [ ! -d "vim" ]; then
    ./minos-static/static-get -c
    ./minos-static/static-get -v -x vim
fi
rm vim/bin/vi
chmod +x vim/bin/*
cp -r vim/* boot-files/initramfs/

cp internals/netconf boot-files/initramfs/bin/netconf
chmod +x boot-files/initramfs/bin/netconf

cd boot-files/initramfs
wget -O bin/pfetch https://raw.githubusercontent.com/dylanaraps/pfetch/master/pfetch
chmod +x bin/pfetch

mkdir -p etc dev man proc sys tmp
mkdir -p etc/init.d

cp ../../internals/nthnn.ascii etc/nthnn.ascii
cp ../../internals/rcS etc/init.d/rcS
ln -s etc/init.d/rcS init
chmod +x etc/init.d/rcS init

rm linuxrc
find . | cpio -o -H newc > ../init.cpio
cd ..

truncate -s 350M nate_os.img
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
    APPEND loglevel=3 root=/dev/ram0 init=/init rw
EOF
umount temp
rm -rf temp

mv nate_os.img ..
cd ..

echo "Bootable image created successfully as nate_os.img"