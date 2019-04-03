# daemon runs in the background
# run something like tail /var/log/hlebd/current to see the status
# be sure to run with volumes, ie:
# docker run -v $(pwd)/hlebd:/var/lib/hlebd -v $(pwd)/wallet:/home/hleb --rm -ti hleb:0.2.2
ARG base_image_version=0.10.0
FROM phusion/baseimage:$base_image_version

ADD https://github.com/just-containers/s6-overlay/releases/download/v1.21.2.2/s6-overlay-amd64.tar.gz /tmp/
RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C /

ADD https://github.com/just-containers/socklog-overlay/releases/download/v2.1.0-0/socklog-overlay-amd64.tar.gz /tmp/
RUN tar xzf /tmp/socklog-overlay-amd64.tar.gz -C /

ARG TURTLECOIN_BRANCH=master
ENV TURTLECOIN_BRANCH=${TURTLECOIN_BRANCH}

# install build dependencies
# checkout the latest tag
# build and install
RUN apt-get update && \
    apt-get install -y \
      build-essential \
      python-dev \
      gcc-4.9 \
      g++-4.9 \
      git cmake \
      libboost1.58-all-dev && \
    git clone https://github.com/hornie/hleb.git /src/hleb && \
    cd /src/hleb && \
    git checkout $TURTLECOIN_BRANCH && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_CXX_FLAGS="-g0 -Os -fPIC -std=gnu++11" .. && \
    make -j$(nproc) && \
    mkdir -p /usr/local/bin && \
    cp src/hlebd /usr/local/bin/hlebd && \
    cp src/walletd /usr/local/bin/walletd && \
    cp src/zedwallet /usr/local/bin/zedwallet && \
    cp src/miner /usr/local/bin/miner && \
    strip /usr/local/bin/hlebd && \
    strip /usr/local/bin/walletd && \
    strip /usr/local/bin/zedwallet && \
    strip /usr/local/bin/miner && \
    cd / && \
    rm -rf /src/hleb && \
    apt-get remove -y build-essential python-dev gcc-4.9 g++-4.9 git cmake libboost1.58-all-dev && \
    apt-get autoremove -y && \
    apt-get install -y  \
      libboost-system1.58.0 \
      libboost-filesystem1.58.0 \
      libboost-thread1.58.0 \
      libboost-date-time1.58.0 \
      libboost-chrono1.58.0 \
      libboost-regex1.58.0 \
      libboost-serialization1.58.0 \
      libboost-program-options1.58.0 \
      libicu55

# setup the hlebd service
RUN useradd -r -s /usr/sbin/nologin -m -d /var/lib/hlebd hlebd && \
    useradd -s /bin/bash -m -d /home/hleb hleb && \
    mkdir -p /etc/services.d/hlebd/log && \
    mkdir -p /var/log/hlebd && \
    echo "#!/usr/bin/execlineb" > /etc/services.d/hlebd/run && \
    echo "fdmove -c 2 1" >> /etc/services.d/hlebd/run && \
    echo "cd /var/lib/hlebd" >> /etc/services.d/hlebd/run && \
    echo "export HOME /var/lib/hlebd" >> /etc/services.d/hlebd/run && \
    echo "s6-setuidgid hlebd /usr/local/bin/hlebd" >> /etc/services.d/hlebd/run && \
    chmod +x /etc/services.d/hlebd/run && \
    chown nobody:nogroup /var/log/hlebd && \
    echo "#!/usr/bin/execlineb" > /etc/services.d/hlebd/log/run && \
    echo "s6-setuidgid nobody" >> /etc/services.d/hlebd/log/run && \
    echo "s6-log -bp -- n20 s1000000 /var/log/hlebd" >> /etc/services.d/hlebd/log/run && \
    chmod +x /etc/services.d/hlebd/log/run && \
    echo "/var/lib/hlebd true hlebd 0644 0755" > /etc/fix-attrs.d/hlebd-home && \
    echo "/home/hleb true hleb 0644 0755" > /etc/fix-attrs.d/hleb-home && \
    echo "/var/log/hlebd true nobody 0644 0755" > /etc/fix-attrs.d/hlebd-logs

VOLUME ["/var/lib/hlebd", "/home/hleb","/var/log/hlebd"]

ENTRYPOINT ["/init"]
CMD ["/usr/bin/execlineb", "-P", "-c", "emptyenv cd /home/hleb export HOME /home/hleb s6-setuidgid hleb /bin/bash"]
