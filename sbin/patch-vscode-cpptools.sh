#!/bin/bash

set -euo pipefail

mode=patch
if [ "${1:-}" = "--check" ]; then
	mode=check
	shift
fi

micore=${1:-}
if [ -z "$micore" ]; then
	micore=$(find /home/ioi/.vscode/extensions \
		-path '*/ms-vscode.cpptools-*/debugAdapters/bin/Microsoft.MICore.dll' \
		-type f -print | sort -V | tail -n 1)
fi

if [ -z "$micore" ] || [ ! -f "$micore" ]; then
	echo "Microsoft.MICore.dll was not found" >&2
	exit 1
fi

python3 - "$mode" "$micore" <<'PY'
import pathlib
import sys

mode = sys.argv[1]
path = pathlib.Path(sys.argv[2])
data = path.read_bytes()
original = "set -o monitor".encode("utf-16le")
patched = "set +o monitor".encode("utf-16le")
original_count = data.count(original)
patched_count = data.count(patched)

if mode == "check":
    if original_count != 0 or patched_count != 1:
        raise SystemExit("VS Code C++ terminal launcher patch is missing")
    print(f"VS Code C++ terminal launcher patch is present: {path}")
elif original_count == 1 and patched_count == 0:
    path.write_bytes(data.replace(original, patched))
    print(f"Patched VS Code C++ terminal launcher: {path}")
elif original_count == 0 and patched_count == 1:
    print(f"VS Code C++ terminal launcher is already patched: {path}")
else:
    raise SystemExit(
        f"unexpected launcher template count: original={original_count}, "
        f"patched={patched_count}"
    )
PY
