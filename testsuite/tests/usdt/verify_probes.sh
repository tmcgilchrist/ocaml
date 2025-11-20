#!/bin/sh
set -eu

# Verify USDT probes are present in a compiled binary by listing them
# and comparing against a reference file
# Usage: verify_probes.sh <binary_path>

BINARY="$1"
REFERENCE="${test_source_directory}/probes.reference"

if [ -z "$BINARY" ] || [ ! -f "$BINARY" ]; then
    echo "Error: Binary not found: $BINARY" > "${ocamltest_response}"
    exit ${TEST_FAIL}
fi

if [ ! -f "$REFERENCE" ]; then
    echo "Error: Reference file not found: $REFERENCE" > "${ocamltest_response}"
    exit ${TEST_FAIL}
fi

# List probes based on platform
if [ "$(uname)" = "Linux" ]; then
    # Try bpftrace first if available (requires root)
    if command -v bpftrace > /dev/null 2>&1; then
        PROBES=$(bpftrace -l "usdt:$BINARY:ocaml:*" 2>/dev/null | \
                 sed 's/^usdt:[^:]*://' | \
                 sort)
    fi
    # Fallback to readelf if bpftrace not available or failed
    if [ -z "$PROBES" ]; then
        PROBES=$(readelf -n "$BINARY" 2>/dev/null | \
                 awk '/Provider: ocaml/{getline; sub(/^[[:space:]]*Name: /, ""); print "ocaml:" $0}' | \
                 sort -u)
    fi
elif [ "$(uname)" = "Darwin" ] || [ "$(uname)" = "FreeBSD" ]; then
    # Use dtrace on macOS/FreeBSD
    PROBES=$(dtrace -l -n "ocaml*:::*" -c "$BINARY" 2>/dev/null | \
             grep -v "ID.*PROVIDER" | \
             awk '{print $2":"$4}' | \
             sort -u)
else
    echo "Unsupported platform: $(uname)" > "${ocamltest_response}"
    exit ${TEST_FAIL}
fi

if [ -z "$PROBES" ]; then
    echo "ERROR: No USDT probes found in $BINARY" > "${ocamltest_response}"
    echo "" >> "${ocamltest_response}"
    echo "This indicates OCaml was not built with --enable-usdt" >> "${ocamltest_response}"
    exit ${TEST_FAIL}
fi

# # Write actual probes to output file for comparison
OUTPUT="${test_build_directory}/probes.output"
echo "$PROBES" > "$OUTPUT"

# Compare against reference
if diff -q "$REFERENCE" "$OUTPUT" > /dev/null 2>&1; then
    # Success - no need to write to response file
    exit ${TEST_PASS}
else
    echo "ERROR: Probe list differs from reference" > "${ocamltest_response}"
    echo "" >> "${ocamltest_response}"
    echo "Differences:" >> "${ocamltest_response}"
    diff -u "$REFERENCE" "$OUTPUT" >> "${ocamltest_response}" 2>&1
    exit ${TEST_FAIL}
fi
