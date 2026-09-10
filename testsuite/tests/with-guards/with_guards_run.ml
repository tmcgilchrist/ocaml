(* TEST *)

(* Run-time behaviour of [with] guards, in bytecode and in native code. *)

type expr = Var of string | Const of int

let eval env e =
  match e with
  | Var x with Some v = List.assoc_opt x env -> v
  | Var x -> failwith ("Unbound variable " ^ x)
  | Const v -> v

type t = A of int | B of int | C

(* A guard whose pattern can fail in several places. *)
let alt x =
  match x with
  | y with (A n | B n) = y when n > 0 -> n
  | _ -> -1

(* Guards of both kinds, mixed. A [when] guard comes after every
   [with] guard. *)
let mixed x =
  match x with
  | y with true = (y >= 0) with Some v = List.nth_opt [0; 1; 2] y
     when v > 0 -> v
  | _ -> -1

(* Nested [with] guards. *)
let nested x =
  match x with
  | y with Some u = y with Some v = u -> v = 0
  | _ -> false

(* A [with] guard on an exception pattern falls through to the next
   handler when it fails. *)
exception E1
exception E2

let reraised () =
  try
    (try raise E1 with e with E2 = e -> "inner")
  with E1 -> "outer"

(* Guards on the alternatives of an or-pattern. Every alternative must
   bind the same variables, which is what the guard is for here. As it
   cannot fail, the matching stays exhaustive. *)
let alt2 x =
  match x with
  | A y
  | B y
  | C with y = -1 -> y

let () =
  Printf.printf "%d %d\n" (eval ["a", 42] (Var "a")) (eval [] (Const 7));
  (try ignore (eval [] (Var "b")) with Failure m -> print_endline m);
  List.iter (fun x -> Printf.printf "%d " (alt x))
    [A 3; B 4; A 0; B (-1); C];
  print_newline ();
  List.iter (fun x -> Printf.printf "%d " (mixed x)) [-1; 0; 1; 2; 3];
  print_newline ();
  List.iter (fun x -> Printf.printf "%b " (nested x))
    [Some (Some 0); Some (Some 1); Some None; None];
  print_newline ();
  List.iter (fun x -> Printf.printf "%d " (alt2 x)) [A 3; B 4; C];
  print_newline ();
  print_endline (reraised ())
