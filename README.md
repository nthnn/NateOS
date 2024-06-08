# NateOS

## Getting Started

1. Pull the NateOS git repository.

```bash
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