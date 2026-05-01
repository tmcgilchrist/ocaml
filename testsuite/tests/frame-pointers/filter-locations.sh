#!/bin/sh

set -eu

program="${1}"

# backtrace_symbols_fd output differs between glibc (Linux) and macOS.  This
# filter normalises both formats to a single canonical form: one line per
# frame, just the symbol name.
#
# On both platforms we additionally:
#   - keep only frames originating from the program binary (drop libc, dyld,
#     and other shared libraries);
#   - strip the OCaml-generated `_NN` numeric suffix from `caml*` symbols;
#   - drop the C startup wrappers `caml_main` and `caml_startup_common`,
#     which on Linux are typically not symbolicated by `backtrace_symbols_fd`
#     and so do not appear in the reference output.

case "$(uname -s)" in
  Darwin)
    # macOS backtrace_symbols_fd format:
    #   <idx>   <binary>    0xADDR <symbol> + <offset>
    program_basename=$(basename "${program}")
    awk -v prog="${program_basename}" '
      $2 == prog {
        sym = $4
        sub(/^_/, "", sym)        # strip macOS leading underscore
        sub(/_[0-9]+$/, "", sym)  # strip OCaml numeric suffix
        if (sym == "caml_main" || sym == "caml_startup_common") next
        print sym
      }
    '
    ;;
  *)
    # Linux glibc backtrace_symbols_fd format:
    #   /path/to/binary(symbol+0xOFFSET) [0xADDR]
    # https://stackoverflow.com/a/29626460
    program_escaped=$(echo "${program}" | \
      sed 's/[^^\\]/[&]/g; s/\^/\\^/g; s/\\/\\\\/g')
    regex_backtrace='^.*(\(.*\)+0x[[:xdigit:]]*)[0x[[:xdigit:]]*]$'
    regex_trim_fun='^\(caml.*\)_[[:digit:]]*$'

    # - Ignore backtrace not coming from the program binary
    # - Discard the number suffix from OCaml function name
    # - Keep the other lines
    sed -e \
      "/${regex_backtrace}/ {
        /^${program_escaped}/ ! d
        s/${regex_backtrace}/\1/
        s/${regex_trim_fun}/\1/
      }"
    ;;
esac
