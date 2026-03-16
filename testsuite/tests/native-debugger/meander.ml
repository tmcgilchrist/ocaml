open Effect
open Effect.Deep

(* Test caml_c_call and caml_start_program: C-to-OCaml callback with exception *)
external ocaml_to_c
         : unit -> int = "ocaml_to_c"
exception E1
exception E2
let c_to_ocaml () = raise E1
let _ = Callback.register
          "c_to_ocaml" c_to_ocaml
let omain () =
  try (* h1 *)
    try (* h2 *) ocaml_to_c ()
    with E2 -> 0
  with E1 -> 42
let _ = assert (omain () = 42)

(* Test caml_runstack: run function on a new fiber stack *)
let[@inline never] on_fiber () =
  Sys.opaque_identity 42

let () =
  let result = match_with on_fiber ()
    { retc = Fun.id;
      exnc = raise;
      effc = (fun (type a) (_ : a t) -> None) }
  in
  assert (result = 42)

(* Test caml_perform/caml_resume: effect handler perform and resume *)
type _ Effect.t += Yield : unit Effect.t

let[@inline never] on_perform () =
  Sys.opaque_identity 99

let[@inline never] performer () =
  Effect.perform Yield;
  on_perform ()

let () =
  let result = match_with performer ()
    { retc = Fun.id;
      exnc = raise;
      effc = (fun (type a) (eff : a Effect.t) ->
        match eff with
        | Yield -> Some (fun (k : (a, _) continuation) ->
            continue k ())
        | _ -> None) }
  in
  assert (result = 99)
