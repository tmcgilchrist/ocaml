(* TEST
 include unix;
 libunix;
 native;
*)
open Sys

let () =
  let r = ref false in
  Sys.set_signal Sys.sigint (Signal_handle (fun _ -> r := true));
  Unix.kill (Unix.getpid ()) Sys.sigint;
  let x = !r in
  assert (x == true); (* Should trigger signal_handle for sigint *)
  r := false;

  Sys.set_signal Sys.sigint (Signal_handle (fun _ -> r := true));
  Unix.kill (Unix.getpid ()) Sys.siginfo;
  let x = !r in
  (* Sending siginfo shouldn't trigger signal_handle for sigint. *)
  assert (x == false);
  r := false;

  Sys.set_signal Sys.siginfo (Signal_handle (fun _ -> r := true));
  Unix.kill (Unix.getpid ()) Sys.siginfo;
  let x = !r in
  assert (x == true); (* Should trigger signal_handle for siginfo *)
  r := false;

  Sys.set_signal Sys.sigwinch (Signal_handle (fun _ -> r := true));
  Unix.kill (Unix.getpid ()) Sys.sigwinch;
  let x = !r in
  assert (x == true); (* Should trigger signal_handle for sigwinch *)
  r := false;

  Sys.set_signal Sys.sigemt (Signal_handle (fun _ -> r := true));
  Unix.kill (Unix.getpid ()) Sys.sigemt;
  let x = !r in
  assert (x == true); (* Should trigger signal_handle for sigemt *)
  r := false;

  Sys.set_signal Sys.sigio (Signal_handle (fun _ -> r := true));
  Unix.kill (Unix.getpid ()) Sys.sigio;
  let x = !r in
  assert (x == true); (* Should trigger signal_handle for sigio *)

  (* Signals should map to POSIX standard names *)
  let signals = [(sighup, "SIGHUP");
                 (sigint, "SIGINT");
                 (sigquit, "SIGQUIT");
                 (sigill, "SIGILL");
                 (sigtrap, "SIGTRAP");
                 (sigabrt, "SIGABRT");
                 (sigemt, "SIGEMT");
                 (sigfpe, "SIGFPE");
                 (sigkill, "SIGKILL");
                 (sigbus, "SIGBUS");
                 (sigsegv, "SIGSEGV");
                 (sigsys, "SIGSYS");
                 (sigpipe, "SIGPIPE");
                 (sigalrm, "SIGALRM");
                 (sigterm, "SIGTERM");
                 (sigurg, "SIGURG");
                 (sigstop, "SIGSTOP");
                 (sigtstp, "SIGTSTP");
                 (sigcont, "SIGCONT");
                 (sigchld, "SIGCHLD");
                 (sigttin, "SIGTTIN");
                 (sigttou, "SIGTTOU");
                 (sigio, "SIGIO");
                 (sigxcpu, "SIGXCPU");
                 (sigxfsz, "SIGXFSZ");
                 (sigvtalrm, "SIGVTALRM");
                 (sigprof, "SIGPROF");
                 (sigwinch, "SIGWINCH");
                 (siginfo, "SIGINFO");
                 (sigusr1, "SIGUSR1");
                 (sigusr2, "SIGUSR2")] in
  List.iter (fun (s,str) -> assert (String.equal (Sys.signal_to_string s) str)) signals;

  r := false;

  Sys.set_signal 1 (Signal_handle (fun _ -> r := true));
  Unix.kill (Unix.getpid ()) 1;
  let x = !r in
 (* Should trigger signal_handle for signal corresponding to 1 SIGHUP? *)
  assert (x == true);

  print_endline "Sys.set_signal works!"
