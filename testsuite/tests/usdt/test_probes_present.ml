(* TEST
   usdt;
   script = "sh ${test_source_directory}/has_usdt.sh";
   native;
   script;
   linux || macosx || bsd;
   script = "sh ${test_source_directory}/verify_probes.sh ${program}";
   script;
*)

(* Simple test program to verify USDT probes are embedded in compiled binaries.
 * This test compiles to native code and then checks that USDT probes are present
 * using readelf (Linux) or dtrace (macOS/FreeBSD).
 *)

let allocate_some_memory () =
  (* Allocate to trigger minor GC - ensures gc__minor probes are meaningful *)
  let _ = Array.make 1000 42 in
  let _ = Array.make 10000 0 in
  ()

let () =
  allocate_some_memory ();
  Gc.full_major ();
  print_endline "USDT probe presence test"
