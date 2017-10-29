FROM debian:stretch-slim

RUN apt-get update && apt-get install --no-install-recommends -y \
    bash \
    wget \
    make \
    gcc \
    tar \
    autoconf \
    libldns-dev \
    libevent-2.0 \
    libevent-dev \
    ca-certificates \
    musl-dev \
    libc-dev \
    libexpat1 \
    libexpat1-dev \
    file && \
    rm -rf /var/lib/apt/lists/*

ENV UNBOUND_VERSION 1.6.7
ENV UNBOUND_SHA256 4e7bd43d827004c6d51bef73adf941798e4588bdb40de5e79d89034d69751c9f
ENV UNBOUND_DOWNLOAD_URL https://www.unbound.net/downloads/unbound-${UNBOUND_VERSION}.tar.gz

RUN set -x && \
    mkdir -p /tmp/src && \
    cd /tmp/src && \
    wget -O unbound.tar.gz $UNBOUND_DOWNLOAD_URL && \
    echo "${UNBOUND_SHA256} *unbound.tar.gz" | sha256sum -c - && \
    tar xzf unbound.tar.gz && \
    rm -f unbound.tar.gz && \
    cd unbound-${UNBOUND_VERSION} && \
    groupadd unbound && \
    useradd -g unbound -s /etc -d /dev/null unbound && \
    ./configure --disable-dependency-tracking --prefix=/opt/unbound --with-pthreads \
    --with-username=unbound --with-libevent && \
    make install && \
    mv /opt/unbound/etc/unbound/unbound.conf /opt/unbound/etc/unbound/unbound.conf.example && \
    rm -fr /opt/unbound/share/man && \
    rm -fr /tmp/* /var/tmp/*

COPY unbound.sh /opt
RUN chmod 777 /opt/unbound.sh

COPY certificate.crt /opt/unbound/etc/unbound/
COPY private.key /opt/unbound/etc/unbound/

#RUN /bin/bash /opt/unbound.sh

EXPOSE 853/tcp

#CMD /opt/unbound/sbin/unbound -vv
CMD ["/opt/unbound.sh"]
