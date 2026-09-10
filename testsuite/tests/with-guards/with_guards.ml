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

(* Guards are tried from left to right, and the variables bound by one
   are in scope in the ones that follow. A [when] guard belongs to the
   case as a whole, so it comes after all of them. *)

let f x =
  match x with
  | y with true = (y >= 0)
          with Some v = List.nth_opt [0; 1; 2] y
     when v > 0 -> v
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

val j : [> `A of int | `B of int | `C ] -> int = <fun>
|}]

(* A [with] guard can unpack a first-class module. *)

let k (x : (module Set.OrderedType with type t = int)) =
  match x with
  | _ with (module M) = x -> M.compare 1 2
;;
[%%expect{|
val k : (module Set.OrderedType with type t = int) -> int = <fun>
|}]

(* Existential types are not allowed in a [with] guard. *)

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

(* A [with] guard binds more tightly than [|], so it attaches to the
   alternative of the or-pattern that it follows. This is what lets the
   alternatives of an or-pattern bind the same variables. *)

type expr2 = Foo of int * int | Bar of int

let o x =
  match x with
  | Foo (y, z)
  | Bar y with z = 3 -> y + z
;;
[%%expect{|
type expr2 = Foo of int * int | Bar of int
val o : expr2 -> int = <fun>
|}]

let alternatives = o (Foo (1, 2)), o (Bar 10);;
[%%expect{|
val alternatives : int * int = (3, 13)
|}]

(* A guard that cannot fail does not make the matching partial. *)

let p (Some x | None with x = 0) = x;;
[%%expect{|
val p : int option -> int = <fun>
|}]

let irrefutable = p (Some 7), p None;;
[%%expect{|
val irrefutable : int * int = (7, 0)
|}]

(* A guard that can fail does, and the alternatives that follow it in the
   or-pattern are tried when it fails. *)

let q x =
  match x with
  | (`A y | `B _ with `C y = x) -> y
  | `B y -> y * 2
;;
[%%expect{|
Lines 2-4, characters 2-17:
2 | ..match x with
3 |   | (`A y | `B _ with `C y = x) -> y
4 |   | `B y -> y * 2
Warning 8 [partial-match]: this pattern-matching is not exhaustive.
  Here is an example of a case that is not matched:
    "(`A _|`C _)"
    (However, some guarded clause may match this value.)

val q : [< `A of int | `B of int | `C of int ] -> int = <fun>
|}]

let refutable = q (`A 1), q (`B 2);;
[%%expect{|
val refutable : int * int = (1, 4)
|}]

(* Parenthesise to attach a guard to several alternatives at once. *)

let r x =
  match x with
  | (Foo (y, _) | Bar y) with z = y * 2 -> z
;;
[%%expect{|
val r : expr2 -> int = <fun>
|}]

(* A failing [when] guard abandons the case, without trying the
   remaining alternatives of its or-pattern. *)

let s () =
  match (3, 2) with
  | (x, y) with z = x - y with `A = `B
  | (y, x) with z = x - y
  | (x, y) with z = 10
     when z > 0 -> z
  | (x, y) with z = x - y -> z + z
;;
[%%expect{|
Line 4, characters 4-10:
4 |   | (y, x) with z = x - y
        ^^^^^^
Warning 12 [redundant-subpat]: this sub-pattern is unused.

Line 5, characters 4-10:
5 |   | (x, y) with z = 10
        ^^^^^^
Warning 12 [redundant-subpat]: this sub-pattern is unused.

val s : unit -> int = <fun>
|}]

let aborted = s ();;
[%%expect{|
val aborted : int = 2
|}]

(* A [with] guard can fail, so it is only allowed where the matching can
   resume with something else. *)

type wrap = Wrap of int option

let t x =
  match x with
  | Wrap (Some z | None with z = 0) -> z
;;
[%%expect{|
type wrap = Wrap of int option
Line 5, characters 19-34:
5 |   | Wrap (Some z | None with z = 0) -> z
                       ^^^^^^^^^^^^^^^
Error: A "with" guard is only allowed on the pattern of a match case
       or of a function parameter, or on an alternative of an or-pattern
       in such a position.
|}]

let u = let (Some x | None with x = 0) = Some 3 in x;;
[%%expect{|
Line 1, characters 22-37:
1 | let u = let (Some x | None with x = 0) = Some 3 in x;;
                          ^^^^^^^^^^^^^^^
Error: A "with" guard is only allowed on the pattern of a match case
       or of a function parameter, or on an alternative of an or-pattern
       in such a position.
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
