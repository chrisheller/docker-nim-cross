FROM debian:jessie

# This is the combination of several projects to provide
# a Docker image with a recent version of Nim and a 
# (semi-)recent version of the Mac OS X SDK for cross compiling
# Nim programs.
#
# This supports compiling Nim programs to run on:
# - 32 and 64 bit Mac OS X
# - 32 and 64 bit Windows
# - 32 and 64 bit Linux
# - Musl
#
# See
#
# https://github.com/tpoechtrager/osxcross
# https://github.com/andrew-d/docker-osxcross
# https://github.com/apriorit/docker-osxcross-10.11
# https://github.com/miyabisun/docker-nim-cross


COPY install-nim.sh cross-compile.nim.cfg /root/

ENV OSXCROSS_REVISION=9498bfdc621716959e575bd6779c853a03cf5f8d
ENV OSXCROSS_SDK_VERSION=10.11
ENV OSXCROSS_SDK_REMOTE_ROOT_DIR=https://github.com/apriorit/osxcross-sdks/raw/master/
ENV CHOOSENIM_CHOOSE_VERSION=1.4.2

# NOTE: The Docker Hub's build machines run varying types of CPUs, so an image
# built with `-march=native` on one of those may not run on every machine - I
# ran into this problem when the images wouldn't run on my 2013-era Macbook
# Pro.  As such, we remove this flag entirely.

# Install build tools
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -yy && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yy \
        automake            \
        bison               \
        curl                \
        file                \
        flex                \
        git                 \
        libtool             \
        pkg-config          \
        python              \
        texinfo             \
        cmake               \
        wget                \
        gcc-multilib        \
        apt-transport-https \
        ca-certificates     \
        software-properties-common \
        python-software-properties && \
    apt-add-repository "deb http://llvm.org/apt/trusty/ llvm-toolchain-trusty-3.8 main" && \
    apt-get update && \
    apt-get -yy -qq --force-yes install clang-3.8 lldb-3.8 && \
    ln -f -s /usr/bin/clang-3.8 /usr/bin/clang && \
    ln -f -s /usr/bin/clang++-3.8 /usr/bin/clang++ && \
    SDK_VERSION=$OSXCROSS_SDK_VERSION                           \
    mkdir /opt/osxcross &&                                      \
    cd /opt &&                                                  \
    git clone https://github.com/tpoechtrager/osxcross.git &&   \
    cd osxcross &&                                              \
    git checkout ${OSXCROSS_REVISION} &&    \
    sed -i -e 's|-march=native||g' ./build_clang.sh ./wrapper/build.sh && \
    ./tools/get_dependencies.sh &&                              \
    curl -L -o ./tarballs/MacOSX${OSXCROSS_SDK_VERSION}.sdk.tar.xz \
    ${OSXCROSS_SDK_REMOTE_ROOT_DIR}MacOSX${OSXCROSS_SDK_VERSION}.sdk.tar.xz && \
    yes | PORTABLE=true ./build.sh &&                           \
    ./build_compiler_rt.sh   && \
    bash /root/install-nim.sh && \
    rm /root/install-nim.sh && \
    apt -y update && apt -y install \
      musl \
      musl-dev \
      musl-tools \
      mingw-w64 && \
    cat /root/cross-compile.nim.cfg >> $(find /root/.choosenim/toolchains/*/config/nim.cfg) && \
    rm /root/cross-compile.nim.cfg && \
    rm -rf /root/.choosenim/downloads/* && \
    rm -rf /root/.choosenim/toolchains/*/c_code && \
    rm -rf /root/.cache/* && \
    rm -rf /tmp/*nim* && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /usr/local/src
ENV PATH $PATH:/opt/osxcross/target/bin:/root/.nimble/bin
CMD /bin/bash
