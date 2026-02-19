#!/bin/sh
# Check if we have tools to verify USDT probes
PLATFORM="$(uname)"
if [ "$PLATFORM" = "Linux" ]; then
    if command -v readelf > /dev/null 2>&1; then
        exit ${TEST_PASS}
    else
        echo "USDT enabled but readelf not available" \
          > "${ocamltest_response}"
        exit ${TEST_SKIP}
    fi
elif [ "$PLATFORM" = "Darwin" ]; then
    if command -v otool > /dev/null 2>&1; then
        exit ${TEST_PASS}
    else
        echo "USDT enabled but otool not available" \
          > "${ocamltest_response}"
        exit ${TEST_SKIP}
    fi
elif [ "$PLATFORM" = "FreeBSD" ]; then
    if command -v readelf > /dev/null 2>&1; then
        exit ${TEST_PASS}
    else
        echo "USDT enabled but readelf not available" \
          > "${ocamltest_response}"
        exit ${TEST_SKIP}
    fi
else
    echo "Unsupported platform: $PLATFORM" \
      > "${ocamltest_response}"
    exit ${TEST_SKIP}
fi
