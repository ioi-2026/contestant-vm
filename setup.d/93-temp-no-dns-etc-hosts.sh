#!/bin/bash

set -x
set -e

cat <<EOM >>/etc/hosts
172.16.1.1 cms.ioi2026.uz
172.16.2.1 backup.ioi2026.uz
EOM

sudo resolvectl flush-caches
