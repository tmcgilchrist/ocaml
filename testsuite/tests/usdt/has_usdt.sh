#!/bin/sh
# Check if we have tools to verify USDT probes
PLATFORM="$(uname)"
if [ "$PLATFORM" = "Linux" ]; then
    # On Linux, we can use readelf (always available) or bpftrace
    if command -v readelf > /dev/null 2>&1; then
        exit ${TEST_PASS}
    else
        echo "USDT enabled but readelf not available" > "${ocamltest_response}"
        exit ${TEST_SKIP}
    fi
elif [ "$PLATFORM" = "Darwin" ] || [ "$PLATFORM" = "FreeBSD" ]; then
    # On macOS/FreeBSD, dtrace should be available
    if command -v dtrace > /dev/null 2>&1; then
        exit ${TEST_PASS}
    else
        echo "USDT enabled but dtrace not available" > "${ocamltest_response}"
        exit ${TEST_SKIP}
    fi
else
    echo "Unsupported platform for USDT testing: $PLATFORM" > "${ocamltest_response}"
    exit ${TEST_SKIP}
fi
