FROM debian:stretch-slim

RUN apt-get update && apt-get install -y \
    bash \
    wget \
    make \
    gcc \
    tar \
    autoconf \
    libldns-dev \
    libevent-dev \
    musl-dev \
    libexpat1-dev \
    file 

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
    ./configure --prefix=/opt/unbound --with-pthreads \
    --with-username=unbound --with-libevent && \
    make install && \
    mv /opt/unbound/etc/unbound/unbound.conf /opt/unbound/etc/unbound/unbound.conf.example && \
    rm -fr /opt/unbound/share/man && \
    rm -fr /tmp/* /var/tmp/*

COPY unbound.sh /tmp
COPY certificate.crt /opt/unbound/etc/unbound/
COPY private.key /opt/unbound/etc/unbound/

RUN /bin/bash /tmp/unbound.sh
run rm -f /tmp/unbound.sh

EXPOSE 80/tcp
EXPOSE 853/tcp

#ENTRYPOINT /opt/unbound/sbin/unbound -d -vv
