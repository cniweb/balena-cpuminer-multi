FROM balenalib/aarch64-debian:bookworm
RUN set -x \
    # Runtime dependencies.
 && apt-get update \
 && apt-get upgrade -y \
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
 && ./configure --with-crypto --with-curl CFLAGS="-O2 $extracflags -march=armv8-a+crypto -mtune=cortex-a53 -DUSE_ASM -pg" \
 && make -C /tmp/cpuminer install -j 4 \
    # Clean-up
 && cd / \
 && apt-get purge --auto-remove -y \
        autoconf \
        automake \
        curl \
        g++ \
        git \
        make \
        pkg-config \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /tmp/* \
    # Verify
 && /usr/local/bin/cpuminer --cputest \
 && /usr/local/bin/cpuminer -V
WORKDIR /cpuminer
# Config and Start-Script
COPY config.json /cpuminer
COPY start_cpuminer.sh /cpuminer
ENTRYPOINT ["./start_cpuminer.sh"]
