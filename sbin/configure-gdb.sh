#!/bin/bash

set -euo pipefail

contestant_user=ioi
contestant_home=$(getent passwd "$contestant_user" | cut -d: -f6)

if [ -z "$contestant_home" ]; then
	echo "The $contestant_user account does not exist" >&2
	exit 1
fi

cat >"$contestant_home/.gdbinit" <<'EOF'
# Contest machines must not contact external debuginfod services.
set debuginfod enabled off
EOF

if ! grep -Fqx "export DEBUGINFOD_URLS=''" "$contestant_home/.profile"; then
	echo "export DEBUGINFOD_URLS=''" >>"$contestant_home/.profile"
fi

chown "$contestant_user:$contestant_user" \
	"$contestant_home/.gdbinit" "$contestant_home/.profile"
chmod 0644 "$contestant_home/.gdbinit" "$contestant_home/.profile"
