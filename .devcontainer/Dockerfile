FROM mcr.microsoft.com/vscode/devcontainers/base:ubuntu22.04

# install requirements
RUN apt-get update \
    # && apt-get upgrade -y \
    && apt-get install -y build-essential cmake ninja-build python3-pip

# install pico-sdk
RUN cd /opt && git clone https://github.com/raspberrypi/pico-sdk && cd pico-sdk && git submodule update --init
ENV PICO_SDK_PATH=/opt/pico-sdk

# install arm toolchain
ARG ARM_TOOLCHAIN="13.3.rel1"
RUN mkdir -p /tmp/arm-toolchain && cd /tmp/arm-toolchain \
    && wget https://developer.arm.com/-/media/Files/downloads/gnu/$ARM_TOOLCHAIN/binrel/arm-gnu-toolchain-$ARM_TOOLCHAIN-$(uname -m)-arm-none-eabi.tar.xz \
    && tar -xvf arm-gnu-toolchain-$ARM_TOOLCHAIN-$(uname -m)-arm-none-eabi.tar.xz \
    && mv arm-gnu-toolchain-$ARM_TOOLCHAIN-$(uname -m)-arm-none-eabi /opt/arm-none-eabi \
    && rm -rf /tmp/arm-toolchain
ENV PATH=/opt/arm-none-eabi/bin:$PATH
ENV PICO_TOOLCHAIN_PATH=/opt/arm-none-eabi

# install swift
ARG SWIFT_VERSION="swift-DEVELOPMENT-SNAPSHOT-2024-09-25-a"
RUN mkdir -p /tmp/swift && cd /tmp/swift \
    && wget https://download.swift.org/development/ubuntu2204-$(uname -m)/$SWIFT_VERSION/$SWIFT_VERSION-ubuntu22.04-$(uname -m).tar.gz \
    && tar -xvf $SWIFT_VERSION-ubuntu22.04-$(uname -m).tar.gz \
    && mv $SWIFT_VERSION-ubuntu22.04-$(uname -m) /opt/swift \
    && rm -rf /tmp/swift
ENV PATH=/opt/swift/usr/bin:$PATH
