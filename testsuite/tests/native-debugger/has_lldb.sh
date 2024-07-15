#!/bin/bash

OCAML_OS="$1"

# Extract the first 4 parts of an LLDB version number
version () {
    echo "$@" | awk -F. '{ printf("%d%03d%03d%03d\n", $1,$2,$3,$4); }'
}

if ! which lldb > /dev/null 2>&1; then
    echo "lldb not available" > "${ocamltest_response}"
    exit ${TEST_SKIP}
else
    if [ "$OCAML_OS" = "macos" ]; then
        # macOS version
        LLDB_VERSION=$(lldb --version |head -n 1 | awk -F'-' '{print $2}')
    elif [ "$OCAML_OS" = "linux" ]; then
        # Linux version
        LLDB_VERSION=$(lldb --version |awk -F' ' '{print $3}')
    else
        exit ${TEST_SKIP}
    fi

    if [ $(version "$LLDB_VERSION") -ge $(version "14.0.0") ]; then
        exit ${TEST_PASS}
    else
        exit ${TEST_SKIP}
    fi
fi
