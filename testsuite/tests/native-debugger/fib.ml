(* Minimal program with some recursion. *)
let[@inline never] rec fib n =
  if n = 0 then 0
  else if n = 1 then 1
  else fib (n-1) + fib (n-2)

let[@inline never] main () =
  let a = 5 in
  let r = fib a in
  Printf.printf "fib(%d) = %d" a r

let _ = main ()
