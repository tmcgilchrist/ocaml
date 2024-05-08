(* TEST
   native-compiler;
   macos;
   arch_arm64;
   script = "sh ${test_source_directory}/has_lldb.sh";
   script;
   readonly_files = "fib.ml lldb_test.py";
   setup-ocamlopt.byte-build-env;
   program = "${test_build_directory}/fib";
   flags = "-g";
   all_modules = "fib.ml";
   ocamlopt.byte;
   debugger_script = "${test_source_directory}/lldb-script";
   lldb;
   script = "sh ${test_source_directory}/sanitize.sh ${test_source_directory} ${test_build_directory} ${ocamltest_response} macos-lldb-arm64";
   script;
   check-program-output;
 *)