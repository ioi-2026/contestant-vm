#!/bin/bash

set -x
set -e

apt -y install openssh-server rsyslog snmpd

cat > /etc/snmp/snmpd.conf <<EOF
agentAddress udp:16161
rocommunity lepublicagent
sysLocation "CAEx (Central Asian Expocenter), Tashkent, Uzbekistan, [41.3268, 69.4228]"
sysContact "IOI HTC"
defaultMonitors yes
master agentx
EOF

# TODO: syslog, firewall
