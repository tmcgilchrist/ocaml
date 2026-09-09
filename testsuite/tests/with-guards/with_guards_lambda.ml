(* TEST
 flags = "-dlambda -dno-unique-ids";
 expect;
*)

type t = A of int | B of int | C;;
[%%expect{|
0
type t = A of int | B of int | C
|}]

(* A case with a single guard fails in one place, which the
   pattern-match compiler patches with the code for the cases that
   remain to be tried. *)

let f x =
  match x with
  | y with Some v = y -> v
  | _ -> 0
;;
[%%expect{|
(let (f = (function x : int (if x (field_imm 0 x) 0)))
  (apply (field_mut 1 (global Toploop!)) "f" f))
val f : int option -> int = <fun>
|}]

(* All the ways of failing to match the pattern of a [with] guard lead to
   the same place. *)

let g x =
  match x with
  | y with (A 1 | B 2) = y -> 0
  | _ -> 1
;;
[%%expect{|
(let
  (g =
     (function x : int
       (catch
         (catch
           (switch* x
            case int 0: (exit 8)
            case tag 0: (if (!= (field_imm 0 x) 1) (exit 8) (exit 6))
            case tag 1: (if (!= (field_imm 0 x) 2) (exit 8) (exit 6)))
          with (6) 0)
        with (8) 1)))
  (apply (field_mut 1 (global Toploop!)) "g" g))
val g : t -> int = <fun>
|}]

(* When a case has several guards, they jump to a common exit whose
   handler is the failure of the case as a whole. *)

let h x =
  match x with
  | y when y >= 0 with Some v = Some y when v < 10 -> v
  | _ -> -1
;;
[%%expect{|
(let
  (h =
     (function x[int] : int
       (catch
         (if (>= x 0)
           (let (*match* = (makeblock 0 (int) x))
             (if *match*
               (let (v =a (field_imm 0 *match*)) (if (< v 10) v (exit 13)))
               (exit 13)))
           (exit 13))
        with (13) -1)))
  (apply (field_mut 1 (global Toploop!)) "h" h))
val h : int -> int = <fun>
|}]
