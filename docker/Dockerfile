# TWRP 12.1 build environment (AOSP 12 host requirements)
FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive TZ=UTC

RUN apt-get update && apt-get install -y --no-install-recommends \
        bc bison build-essential ca-certificates cpio curl flex git gnupg \
        libc6-dev-i386 libncurses5 libssl-dev libxml2-utils lib32z1-dev \
        openjdk-11-jdk-headless python-is-python3 python3 rsync unzip \
        xsltproc zip zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://storage.googleapis.com/git-repo-downloads/repo -o /usr/local/bin/repo \
    && chmod a+x /usr/local/bin/repo \
    && git config --system user.name builder \
    && git config --system user.email builder@localhost \
    && git config --system color.ui false

WORKDIR /src
