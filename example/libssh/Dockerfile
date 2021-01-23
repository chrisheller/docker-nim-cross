FROM chrishellerappsian/docker-nim-cross

# Update libssh2 since Jessie only had version 1.4.3
# libssh2 1.9.0 was released June 20, 2019 and is current as of Jan 23, 2020
RUN cd /tmp && \
    wget https://www.libssh2.org/download/libssh2-1.9.0.tar.gz && \
    tar -xvf libssh2*.tar.gz && \
    cd libssh2* && \
    # TODO - add cross-compiled versions
    ./configure --includedir /usr/include/x86_64-linux-gnu \
                --libdir /usr/lib/x86_64-linux-gnu && \
    make install && \
    nimble -y install ssh2 && \
    rm -rf /tmp/libssh2-1.9.0
