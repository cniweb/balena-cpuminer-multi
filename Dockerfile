FROM balenalib/aarch64-debian:bookworm
RUN set -x \
    # Runtime dependencies.
 && apt-get update \
 && apt-get upgrade -y \
 # apt-get install -y automake autoconf pkg-config libcurl4-openssl-dev libjansson-dev libssl-dev libgmp-dev zlib1g-dev make g++
# && apt-get install -y \
#        libcurl4 \
#        libgmp \
#        libjansson \
#        libssl \
#        openssl \
    # Build dependencies.
 && apt-get install -y \
        autoconf \
        automake \
        curl \
        g++ \
        git \
        libcurl4-openssl-dev \
        libjansson-dev \
        libssl-dev \
        libgmp-dev \
        libz-dev \
        make \
        pkg-config \
    # Compile from source code.
 && git clone --recursive https://github.com/tpruvot/cpuminer-multi.git -b linux /tmp/cpuminer \
 && cd /tmp/cpuminer \
 && ./autogen.sh \
 && extracflags="$extracflags -Ofast -flto -fuse-linker-plugin -ftree-loop-if-convert-stores" \
 && ./configure --with-crypto --with-curl CFLAGS="-O2 $extracflags -DUSE_ASM -pg" \
 && make install -j 4 \
    # Clean-up
 && cd / \
 && apt-get purge --auto-remove -y \
        autoconf \
        automake \
        curl \
        g++ \
        git \
#        libcurl4-openssl-dev \
#        libjansson-dev \
#        libssl-dev \
#        libgmp-dev \
        make \
        pkg-config \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /tmp/* \
    # Verify
 && cpuminer --cputest \
 && cpuminer --version

WORKDIR /cpuminer
COPY config.json /cpuminer
CMD ["cpuminer", "--config=config.json"]