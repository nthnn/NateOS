# NateOS

## What's in the box?

The NateOS distro includes the following programs and packages:

- [amp](https://github.com/jmacdonald/amp) - A complete text editor for your terminal.
- [BusyBox](https://www.busybox.net/about.html) - BusyBox combines tiny versions of many common UNIX utilities into a single small executable.
- [eza](https://github.com/eza-community/eza) - A modern, maintained replacement for the venerable file-listing command-line program ls that ships with Unix and Linux operating systems.
- [GCC 4.6.1-2](https://gcc.gnu.org/) - Toolchain that compiles code, links it with any library dependencies, converts that code to assembly, and then prepares executable files.
- [NodeJS 0.8.18-1](https://nodejs.org/en) - A cross-platform, open-source JavaScript runtime environment that can run on Windows, Linux, Unix, macOS, and more.
- [pfetch](https://github.com/dylanaraps/pfetch) - A pretty system information tool written in POSIX sh.
- [Python3.2](https://www.python.org/) - Python is a high-level, dynamic, general-purpose programming language.
- [Vim](https://www.vim.org/) - Vim is a free and open-source, screen-based text editor program.

## Getting Started

To get started in Ubuntu, follow the steps below.

1. Pull the NateOS git repository.

    ```bash
    # Clone NateOS build script
    git clone --depth 1 https://github.com/nthnn/NateOS
    cd NateOS
    ```

2. Switch to `sudo` mode via:

    ```bash
    sudo su
    ```

3. Install `rustup` by following the instructions [here](https://www.rust-lang.org/tools/install).

    ```bash
    # Default installation for `rustup`
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

    # This will install the Linux MUSL for Rust compiler.
    rustup target add x86_64-unknown-linux-musl
    ```

4. Finally, build NateOS by typing the command below:

    ```bash
    chmod +x build.sh
    ./build.sh
    ```

    This will build all necessary binaries such Linux kernel, BusyBox, etc. And will generate nate_os.img on the same working directory if everything was successfully executed.