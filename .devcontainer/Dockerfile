FROM mcr.microsoft.com/vscode/devcontainers/base:ubuntu22.04

# install requirements
RUN apt-get update \
    # && apt-get upgrade -y \
    && apt-get install -y build-essential cmake ninja-build gcc-arm-none-eabi libnewlib-arm-none-eabi python3-pip

# install pico-sdk
RUN cd /opt && git clone https://github.com/raspberrypi/pico-sdk && cd pico-sdk && git submodule update --init
ENV PICO_SDK_PATH=/opt/pico-sdk

# install swift
ARG SWIFT_VERSION="swift-DEVELOPMENT-SNAPSHOT-2024-09-25-a"
RUN mkdir -p /tmp/swift && cd /tmp/swift \
    && wget https://download.swift.org/development/ubuntu2204-$(uname -m)/$SWIFT_VERSION/$SWIFT_VERSION-ubuntu22.04-$(uname -m).tar.gz \
    && tar -xvf $SWIFT_VERSION-ubuntu22.04-$(uname -m).tar.gz \
    && mv $SWIFT_VERSION-ubuntu22.04-$(uname -m) /opt/swift \
    && rm -rf /tmp/swift
ENV PATH=/opt/swift/usr/bin:$PATH
