#! /usr/bin/env bash

cat <<EOT >> /opt/unbound/etc/unbound/unbound.conf
server:
  username: "unbound"
  num-threads: 1
  use-syslog: no
  ssl-service-key: "/opt/unbound/etc/unbound/private.key"
  ssl-service-pem: "/opt/unbound/etc/unbound/certificate.crt"
  auto-trust-anchor-file: "/opt/unbound/etc/unbound/var/root.key"
  verbosity: 2
  interface: 0.0.0.0@853
  ssl-port: 853
  access-control: 0.0.0.0/0 allow
  hide-version: yes
  hide-identity: yes
  do-ip4: yes
  do-ip6: no
  harden-dnssec-stripped: yes
  private-address: 192.168.0.0/16
  private-address: 172.16.0.0/12
  private-address: 10.0.0.0/8
  private-address: 169.254.0.0/16
  unwanted-reply-threshold: 1000000
EOT

#mkdir -p /opt/unbound/etc/unbound/dev && \
#cp -a /dev/random /dev/urandom /opt/unbound/etc/unbound/dev/

mkdir -p -m 700 /opt/unbound/etc/unbound/var && \
chown unbound:unbound /opt/unbound/etc/unbound/var && \
/opt/unbound/sbin/unbound-anchor -a /opt/unbound/etc/unbound/var/root.key

if [ ! -f /opt/unbound/etc/unbound/unbound_control.pem ]; then
  /opt/unbound/sbin/unbound-control-setup
fi

#exec /opt/unbound/sbin/unbound

