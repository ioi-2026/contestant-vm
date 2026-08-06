#!/bin/bash

set -euo pipefail

settings_dir=/home/ioi/.config/Code/User
runtime_dir=/home/ioi/.vscode
install -d -o ioi -g ioi "$settings_dir"
install -d -o ioi -g ioi "$runtime_dir"

debug_adapter=$(find /home/ioi/.vscode/extensions -type f -name OpenDebugAD7 -print -quit)
if [ -z "$debug_adapter" ]; then
	echo "VS Code C++ debug adapter was not found" >&2
	exit 1
fi
chmod 0755 "$debug_adapter"

cat >"$settings_dir/settings.json" <<'EOF'
{
    "C_Cpp.default.cppStandard": "gnu++20",
    "C_Cpp.default.compilerPath": "/usr/bin/g++",
    "C_Cpp.default.intelliSenseMode": "linux-gcc-x64",
    "extensions.ignoreRecommendations": true,
    "extensions.showRecommendationsOnlyOnDemand": true,
    "launch": {
        "version": "0.2.0",
        "configurations": [
            {
                "name": "C++: Debug active file",
                "type": "cppdbg",
                "request": "launch",
                "program": "${fileDirname}/${fileBasenameNoExtension}",
                "args": [],
                "stopAtEntry": false,
                "cwd": "${fileDirname}",
                "environment": [
                    {
                        "name": "DEBUGINFOD_URLS",
                        "value": ""
                    }
                ],
                "externalConsole": true,
                "MIMode": "gdb",
                "miDebuggerPath": "/usr/bin/gdb",
                "setupCommands": [
                    {
                        "description": "Enable GDB pretty-printing",
                        "text": "-enable-pretty-printing",
                        "ignoreFailures": true
                    }
                ],
                "preLaunchTask": "C++: Build active file"
            }
        ]
    }
}
EOF

cat >"$settings_dir/tasks.json" <<'EOF'
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "C++: Build active file",
            "type": "process",
            "command": "/usr/bin/g++",
            "args": [
                "-std=gnu++20",
                "-g3",
                "-O0",
                "-Wall",
                "-Wextra",
                "${file}",
                "-o",
                "${fileDirname}/${fileBasenameNoExtension}"
            ],
            "options": {
                "cwd": "${fileDirname}"
            },
            "problemMatcher": ["$gcc"],
            "group": {
                "kind": "build",
                "isDefault": true
            }
        }
    ]
}
EOF

cat >"$runtime_dir/argv.json" <<'EOF'
{
    "password-store": "basic"
}
EOF

chown -R ioi:ioi /home/ioi/.config/Code "$runtime_dir"
