(* TEST
 expect;
*)

(* A [with] guard succeeds when the value of its expression matches its
   pattern; the case is then selected and the variables bound by the
   pattern are in scope in the right-hand side. Otherwise the matching is
   resumed with the following cases, as for a failing [when] guard. *)

type expr = Var of string | Const of int

let eval env e =
  match e with
  | Var x with Some v = List.assoc_opt x env -> v
  | Var x -> failwith ("Unbound variable " ^ x)
  | Const v -> v
;;
[%%expect{|
type expr = Var of string | Const of int
val eval : (string * int) list -> expr -> int = <fun>
|}]

let bound = eval ["a", 42] (Var "a")
let constant = eval [] (Const 7);;
[%%expect{|
val bound : int = 42
val constant : int = 7
|}]

let unbound = eval [] (Var "b");;
[%%expect{|
Exception: Failure "Unbound variable b".
|}]

(* Guards are tried from left to right and can be mixed freely; the
   variables bound by a [with] guard are in scope in the guards that
   follow it. *)

let f x =
  match x with
  | y when y >= 0 with Some v = List.nth_opt [0; 1; 2] y when v > 0 -> v
  | _ -> -1
;;
[%%expect{|
val f : int -> int = <fun>
|}]

let results = List.map f [-1; 0; 1; 2; 3];;
[%%expect{|
val results : int list = [-1; -1; 1; 2; -1]
|}]

(* Every guard is evaluated at most once, in order. *)

let trace : string list ref = ref []
let note s x = trace := s :: !trace; x

let g x =
  match x with
  | () with Some _ = note "one" None -> "first"
  | () with Some v = note "two" (Some "second") when note "three" true -> v
  | () -> "last"
;;
[%%expect{|
val trace : string list ref = {contents = []}
val note : string -> 'a -> 'a = <fun>
val g : unit -> string = <fun>
|}]

let selected = g ()
let evaluated = List.rev !trace;;
[%%expect{|
val selected : string = "second"
val evaluated : string list = ["one"; "two"; "three"]
|}]

(* A case with a [with] guard does not make a matching exhaustive. *)

let h = function
  | Some x with true = (x > 0) -> x
  | None -> 0
;;
[%%expect{|
Lines 1-3, characters 8-13:
1 | ........function
2 |   | Some x with true = (x > 0) -> x
3 |   | None -> 0
Warning 8 [partial-match]: this pattern-matching is not exhaustive.
  Here is an example of a case that is not matched:
    "Some _"
    (However, some guarded clause may match this value.)

val h : int option -> int = <fun>
|}]

(* Unused variables bound by a [with] guard are reported. *)

[@@@warning "+27"]
let i x =
  match x with
  | () with (a, b) = (1, 2) -> b
;;
[%%expect{|
Lines 3-4, characters 2-32:
3 | ..match x with
4 |   | () with (a, b) = (1, 2) -> b
Warning 8 [partial-match]: this pattern-matching is not exhaustive.
  All clauses in this pattern-matching are guarded.

Line 4, characters 13-14:
4 |   | () with (a, b) = (1, 2) -> b
                 ^
Warning 27 [unused-var-strict]: unused variable "a".

val i : unit -> int = <fun>
|}]
[@@@warning "-27"]
[%%expect{|
|}]

(* The pattern of a [with] guard is an ordinary value pattern, so it can
   be an or-pattern. *)

let j x =
  match x with
  | y with (`A n | `B n) = y -> n
  | `C -> 0
;;
[%%expect{|
Lines 2-4, characters 2-11:
2 | ..match x with
3 |   | y with (`A n | `B n) = y -> n
4 |   | `C -> 0
Warning 8 [partial-match]: this pattern-matching is not exhaustive.
  Here is an example of a case that is not matched:
    "(`A _|`B _)"
    (However, some guarded clause may match this value.)

val j : [< `A of int | `B of int | `C > `C ] -> int = <fun>
|}]

(* Module and existential bindings are not allowed in a [with] guard. *)

let k (x : (module Set.OrderedType)) =
  match x with
  | _ with (module M) = x -> M.compare 1 2
;;
[%%expect{|
Line 3, characters 11-21:
3 |   | _ with (module M) = x -> M.compare 1 2
               ^^^^^^^^^^
Error: Modules are not allowed in this pattern.
|}]

type t = E : 'a * ('a -> string) -> t

let l x =
  match x with
  | () with E (v, p) = E (1, string_of_int) -> p v
;;
[%%expect{|
type t = E : 'a * ('a -> string) -> t
Line 5, characters 12-20:
5 |   | () with E (v, p) = E (1, string_of_int) -> p v
                ^^^^^^^^
Error: Existential types are not allowed in "with" guards,
       but the constructor "E" introduces existential types.
|}]

(* [with] guards are allowed wherever [when] guards are: in [function],
   [match] and [try]. *)

let m = function
  | x with Some y = x -> y
  | _ -> 0
;;
[%%expect{|
val m : int option -> int = <fun>
|}]

exception E1
exception E2

let n () =
  try
    (try raise E1 with e with E2 = e -> "inner")
  with E1 -> "outer"
;;
[%%expect{|
exception E1
exception E2
val n : unit -> string = <fun>
|}]

let handled = n ();;
[%%expect{|
val handled : string = "outer"
|}]
