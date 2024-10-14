# pico-swift-example (multiplatform)
Raspberry Pi Pico + Embedded Swift + VSCode Example Project

Build binary for Pico, Pico W, and Pico 2 from single project.

## Setup

### Devcontainer (Docker)

1. Set up Devcontainer environment according to [VSCode documentation](https://code.visualstudio.com/docs/devcontainers/containers)
2. Open this project directory in VSCode
3. Run `Dev Containers: Reopen in Container`

<!--
## macOS

### Install Swift Development Snapshot

1. Install Xcode.
2. Install Command Line Tools from Xcode Settings.
3. Make sure xcode-select points to Xcode
```sh
$ xcode-select --print-path
/Applications/Xcode.app/Contents/Developer

# If xcode-select points to /Library/Developer/CommandLineTools, run this command to switch.
$ sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
```
4. Download latest swift snapshot (`Trunk Development (main)` `Xcode` `Universal`) from [official page](https://www.swift.org/download/#snapshots), and install it for all users.
5. Check new swift compiler can resolved by `xcrun`.
```sh
$ xcrun --toolchain $(plutil -extract CFBundleIdentifier raw /Library/Developer/Toolchains/swift-latest.xctoolchain/Info.plist) -f swiftc
/Library/Developer/Toolchains/swift-DEVELOPMENT-SNAPSHOT-2024-09-25-a.xctoolchain/usr/bin/swiftc
```
-->

## Build

### From terminal
```sh
# Make sure build directory is cleaned.
$ rm -rf build

# for Raspberry Pi Pico
$ cmake --preset pico
$ cmake --build build

# for Raspberry Pi Pico W
$ cmake --preset pico_w
$ cmake --build build

# for Raspberry Pi Pico 2
$ cmake --preset pico2
$ cmake --build build
```

### From VSCode CMake Extension

Select your board from `CMake: Select Configure Preset`, and click `Build` button in bottom status bar.

## Flash

Hold BOOTSEL button on Raspberry Pi Board while plugging your machine, and copy `build/pico-swift.uf2` into `RPI_RP2` or `RP2350` storage.

## References

- https://github.com/apple/swift-embedded-examples/
