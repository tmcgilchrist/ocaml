(* TEST
 include unix;
 hasunix;
 {
   bytecode;
 }{
   native;
 }
*)

(* The number this library uses to identify a process is the identifier the
   operating system uses on every platform but Windows, where it is a process
   handle instead. The conversions between the two hold on both. *)

let () =
  match Sys.argv with
  | [| _; "child" |] -> exit 0
  | _ ->
    let self = Unix.getpid_os () in
    assert (self <> 0l);
    (* Whatever the platform makes of it, [getpid] identifies this process. *)
    assert (Unix.os_pid_of_process (Unix.getpid ()) = self);
    (* An identifier obtained from outside the library converts back. *)
    assert (Unix.os_pid_of_process (Unix.process_of_os_pid self) = self);
    let child =
      Unix.create_process Sys.executable_name
        [| Sys.executable_name; "child" |] Unix.stdin Unix.stdout Unix.stderr
    in
    (* Read it before [waitpid], which closes the handle on Windows. *)
    let child_os_pid = Unix.os_pid_of_process child in
    assert (child_os_pid <> 0l);
    assert (child_os_pid <> self);
    assert (snd (Unix.waitpid [] child) = Unix.WEXITED 0);
    print_string "passed\n"
