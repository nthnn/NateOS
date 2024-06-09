# NateOS

NateOS is a lightweight Linux distribution that you can build from source. I made NateOS for fun and obviously not for serious stuffs.

## What's in the box?

The NateOS distro includes the following programs and packages:

- [bottom](https://github.com/ClementTsang/bottom) - Yet another cross-platform graphical process/system monitor.
- [broot](https://github.com/Canop/broot) - Get an overview of a directory, even a big one.
- [BusyBox](https://www.busybox.net/about.html) - BusyBox combines tiny versions of many common UNIX utilities into a single small executable.
- [eza](https://github.com/eza-community/eza) - A modern, maintained replacement for the venerable file-listing command-line program ls that ships with Unix and Linux operating systems.
- [GCC 4.6.1-2](https://gcc.gnu.org/) - Toolchain that compiles code, links it with any library dependencies, converts that code to assembly, and then prepares executable files.
- [hex](https://github.com/sitkevij/hex) - Futuristic take on hexdump.
- [loc](https://github.com/cgag/loc) - Count lines of code quickly.
- [lynx](https://lynx.invisible-island.net/) - Lynx is the text web browser.
- [NodeJS 0.8.18-1](https://nodejs.org/en) - A cross-platform, open-source JavaScript runtime environment that can run on Windows, Linux, Unix, macOS, and more.
- [pfetch](https://github.com/dylanaraps/pfetch) - A pretty system information tool written in POSIX sh.
- [Python3.2](https://www.python.org/) - Python is a high-level, dynamic, general-purpose programming language.
- [Vim](https://www.vim.org/) - Vim is a free and open-source, screen-based text editor program.

## Getting Started

### Building from Start

To get started in Ubuntu, follow the steps below.

1. **Clone the Repository**: Pull the NateOS git repository to your local machine.

    ```bash
    # Clone NateOS build script
    git clone --depth 1 https://github.com/nthnn/NateOS
    cd NateOS
    ```

2. **Switch to `sudo` Mode**: Switch to `sudo` mode to ensure you have the necessary permissions for installation.

    ```bash
    sudo su
    ```

3. **Install `rustup`**: Install `rustup` to manage the Rust toolchain. Follow the instructions provided [here](https://www.rust-lang.org/tools/install). Then add the Linux MUSL target for Rust compiler.

    ```bash
    # Default installation for `rustup`
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

    # This will install the Linux MUSL for Rust compiler.
    rustup target add x86_64-unknown-linux-musl
    ```

4. **Build NateOS**: Run the build script to compile all necessary binaries, including the Linux kernel and BusyBox. Execute the following command:

    ```bash
    chmod +x build.sh
    ./build.sh
    ```

    This will generate `nate_os.img` in the current working directory upon successful execution.

### Emulating with QEMU

After successfully building NateOS, you can emulate it using QEMU. Ensure that QEMU, especially `qemu-system-x86_64`, is installed on your system. Run the following command:

```bash
sudo chmod +x emulate.sh
./emulate.sh
```

### Cleaning Up

To remove all downloaded files and Git repositories created by the `build.sh` script, use the following command:

```bash
sudo chmod +x clean.sh
./clean.sh
```