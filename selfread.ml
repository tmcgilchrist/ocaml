let () =
  Runtime_events.start ();
  let cursor = Runtime_events.create_cursor None in
  let n = ref 0 in
  let runtime_begin _ _ _ = incr n in
  let cb = Runtime_events.Callbacks.create ~runtime_begin () in
  let acc = ref [] in
  for i = 1 to 200_000 do
    acc := Array.make 8 i :: !acc;
    if i mod 1000 = 0 then acc := []
  done;
  ignore (Sys.opaque_identity !acc);
  ignore (Runtime_events.read_poll cursor cb None);
  Printf.printf "read %d runtime_begin events\n" !n
