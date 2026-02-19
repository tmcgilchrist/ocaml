#!/bin/sh
set -eu

# Verify USDT probes are present in a compiled binary by listing them
# and comparing against a reference file.
# Usage: verify_probes.sh <binary_path>

BINARY="$1"

if [ -z "$BINARY" ] || [ ! -f "$BINARY" ]; then
    echo "Error: Binary not found: $BINARY" \
      > "${ocamltest_response}"
    exit ${TEST_FAIL}
fi

if [ "$(uname)" = "Linux" ]; then
    REFERENCE="${test_source_directory}/probes.ebpf.reference"
    PROBES=$(readelf -n "$BINARY" 2>/dev/null | \
      awk '/Provider: ocaml/{getline; sub(/^[[:space:]]*Name: /, ""); print "ocaml:" $0}' | \
      sort -u)
elif [ "$(uname)" = "Darwin" ] \
     || [ "$(uname)" = "FreeBSD" ]; then
    REFERENCE="${test_source_directory}/probes.dtrace.reference"

    # Step 1: Quick check that DOF section exists
    if [ "$(uname)" = "Darwin" ]; then
        if ! otool -l "$BINARY" 2>/dev/null \
             | grep -q '__dof'; then
            echo "ERROR: No __dof section in binary" \
              > "${ocamltest_response}"
            exit ${TEST_FAIL}
        fi
    else
        if ! readelf -S "$BINARY" 2>/dev/null \
             | grep -q '.SUNW_dof'; then
            echo "ERROR: No .SUNW_dof section" \
              > "${ocamltest_response}"
            exit ${TEST_FAIL}
        fi
    fi

    # Step 2: Compile and run standalone DOF parser
    DOF_SRC="${test_source_directory}/dof_parser.ml"
    DOF_BUILD="${test_build_directory}/dof_parser.ml"
    DOF_EXE="${test_build_directory}/dof_parser"

    cp "$DOF_SRC" "$DOF_BUILD"
    if ! "${ocamlsrcdir}/ocamlopt.opt" \
           -nostdlib \
           -I "${ocamlsrcdir}/stdlib" \
           -o "$DOF_EXE" "$DOF_BUILD" \
           2>"${test_build_directory}/dof_compile.log"
    then
        echo "ERROR: Failed to compile DOF parser" \
          > "${ocamltest_response}"
        cat "${test_build_directory}/dof_compile.log" \
          >> "${ocamltest_response}"
        exit ${TEST_FAIL}
    fi

    PROBES=$("$DOF_EXE" "$BINARY" 2>/dev/null)
else
    echo "Unsupported platform: $(uname)" \
      > "${ocamltest_response}"
    exit ${TEST_FAIL}
fi

# Verify reference file exists
if [ ! -f "$REFERENCE" ]; then
    echo "Error: Reference file not found: $REFERENCE" \
      > "${ocamltest_response}"
    exit ${TEST_FAIL}
fi

if [ -z "$PROBES" ]; then
    echo "ERROR: No USDT probes found in $BINARY" \
      > "${ocamltest_response}"
    echo "" >> "${ocamltest_response}"
    echo "OCaml may not have been built with" \
      >> "${ocamltest_response}"
    echo "--enable-usdt" >> "${ocamltest_response}"
    exit ${TEST_FAIL}
fi

# Write actual probes to output file for comparison
OUTPUT="${test_build_directory}/probes.output"
echo "$PROBES" > "$OUTPUT"

# Compare against reference
if diff -q "$REFERENCE" "$OUTPUT" > /dev/null 2>&1; then
    exit ${TEST_PASS}
else
    echo "ERROR: Probe list differs from reference" \
      > "${ocamltest_response}"
    echo "" >> "${ocamltest_response}"
    echo "Differences:" >> "${ocamltest_response}"
    diff -u "$REFERENCE" "$OUTPUT" \
      >> "${ocamltest_response}" 2>&1
    exit ${TEST_FAIL}
fi
