#!/bin/sh
if ! which lldb > /dev/null 2>&1; then
    echo "lldb not available" > ${ocamltest_response}
    exit ${TEST_SKIP}
else
    exit ${TEST_PASS}
fi
