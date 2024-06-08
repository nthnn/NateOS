# NateOS

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