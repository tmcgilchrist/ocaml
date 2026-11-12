#include <caml/mlvalues.h>
#include <caml/callback.h>

value ocaml_to_c (value unit) {
    caml_callback(*caml_named_value
                  ("c_to_ocaml"), Val_unit);
    return Val_int(0);
}

/* More than 8 integer arguments, so the surplus is passed on the stack.
   On POWER this routes the call through caml_c_call_stack_args. */
value ocaml_to_c_many (value a1, value a2, value a3, value a4,
                       value a5, value a6, value a7, value a8,
                       value a9, value a10, value a11, value a12) {
    return Val_long(Long_val(a1) + Long_val(a2) + Long_val(a3) + Long_val(a4)
                    + Long_val(a5) + Long_val(a6) + Long_val(a7) + Long_val(a8)
                    + Long_val(a9) + Long_val(a10) + Long_val(a11)
                    + Long_val(a12));
}

value ocaml_to_c_many_byte (value *argv, int argn) {
    (void) argn;
    return ocaml_to_c_many(argv[0], argv[1], argv[2], argv[3], argv[4],
                           argv[5], argv[6], argv[7], argv[8], argv[9],
                           argv[10], argv[11]);
}

/* Declared [@@noalloc], so the call is emitted inline rather than through
   caml_c_call. */
value ocaml_to_c_noalloc (value unit) {
    (void) unit;
    return Val_long(7);
}
