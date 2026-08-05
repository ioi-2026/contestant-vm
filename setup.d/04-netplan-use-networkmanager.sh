#!/bin/bash

set -x
set -e

cat >/etc/netplan/01-netcfg.yaml <<EOF
network:
  version: 2
  renderer: NetworkManager
EOF

netplan generate
netplan apply

# Contestant workstations must not delay boot while waiting for a network.
# Mask both implementations so network-online.target cannot start either one.
systemctl disable systemd-networkd-wait-online.service || true
systemctl mask systemd-networkd-wait-online.service || true
systemctl disable NetworkManager-wait-online.service || true
systemctl mask NetworkManager-wait-online.service || true
