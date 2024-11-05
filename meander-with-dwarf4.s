	.section	__TEXT,__text,regular,pure_instructions
	.build_version macos, 14, 0	sdk_version 14, 5
	.file	1 "/Users/tsmc/projects/ocaml" "meander.ml"
	.loc	1	1	0	; meander.ml
	.data
	.globl	_camlMeander$data_begin
_camlMeander$data_begin:
	.text
	.globl	_camlMeander$code_begin
_camlMeander$code_begin:
Lfunc_begin0:
	nop
	.align	3
	.data
	.align	3
	.data
	.align	3
	.quad	3063
	.globl	_camlMeander$7
_camlMeander$7:
	.quad	_camlMeander$c_to_ocaml_273
	.quad	72057594037927941
	.data
	.align	3
	.quad	3063
	.globl	_camlMeander$6
_camlMeander$6:
	.quad	_camlMeander$omain_278
	.quad	72057594037927941
	.data
	.align	3
	.quad	4864
	.globl	_camlMeander
	.globl	_camlMeander
_camlMeander:
	.quad	1
	.quad	1
	.quad	1
	.quad	1
	.data
	.align	3
	.globl	_camlMeander$gc_roots
	.globl	_camlMeander$gc_roots
_camlMeander$gc_roots:
	.quad	_camlMeander
	.quad	0
	.text
	.align	3
	.globl	_camlMeander$c_to_ocaml_273
_camlMeander$c_to_ocaml_273:
	.loc	1	5	15	; meander.ml
	.cfi_startproc
	sub	sp, sp, #16
	.cfi_adjust_cfa_offset	16
	.cfi_offset 30, -8
	str	x30, [sp, #8]
L100:
	adrp	x1, _camlMeander@GOTPAGE
	ldr	x1, [x1, _camlMeander@GOTPAGEOFF]
	ldr	x0, [x1, #0]
	.loc	1	5	20	; meander.ml
	bl	_caml_raise_exn
L101:
	.cfi_endproc
	.text
	.align	3
	.globl	_camlMeander$omain_278
_camlMeander$omain_278:
	.loc	1	8	10	; meander.ml
	.cfi_startproc
	sub	sp, sp, #16
	.cfi_adjust_cfa_offset	16
	.cfi_offset 30, -8
	str	x30, [sp, #8]
L108:
	adr	x16, L104
	stp	x26, x16, [sp, -16]!
	.cfi_adjust_cfa_offset	16
	mov	x26, sp
	adr	x16, L107
	stp	x26, x16, [sp, -16]!
	.cfi_adjust_cfa_offset	16
	mov	x26, sp
	orr	x0, xzr, #1
	.loc	1	10	17	; meander.ml
	adrp	x8, _ocaml_to_c@GOTPAGE
	ldr	x8, [x8, _ocaml_to_c@GOTPAGEOFF]
	bl	_caml_c_call
L109:
	ldr	x26, [sp], 16
	.cfi_adjust_cfa_offset	-16
	b	L105
L107:
	adrp	x4, _camlMeander@GOTPAGE
	ldr	x4, [x4, _camlMeander@GOTPAGEOFF]
	ldr	x5, [x4, #8]
	cmp	x0, x5
	b.ne	L106
	orr	x0, xzr, #1
	b	L105
L106:
	bl	_caml_reraise_exn
L110:
L105:
	ldr	x26, [sp], 16
	.cfi_adjust_cfa_offset	-16
	b	L102
L104:
	adrp	x8, _camlMeander@GOTPAGE
	ldr	x8, [x8, _camlMeander@GOTPAGEOFF]
	ldr	x9, [x8, #0]
	cmp	x0, x9
	b.ne	L103
	movz	x0, #85, lsl #0
	ldr	x30, [sp, #8]
	add	sp, sp, #16
	.cfi_adjust_cfa_offset	-16
	ret
	.cfi_adjust_cfa_offset	16
L103:
	bl	_caml_reraise_exn
L111:
L102:
	ldr	x30, [sp, #8]
	add	sp, sp, #16
	.cfi_adjust_cfa_offset	-16
	ret
	.cfi_adjust_cfa_offset	16
	.cfi_endproc
	.data
	.align	3
	.quad	3840
	.globl	_camlMeander$5
_camlMeander$5:
	.quad	_camlMeander$4
	.quad	27
	.quad	17
	.data
	.align	3
	.quad	3068
	.globl	_camlMeander$4
_camlMeander$4:
	.ascii  "meander.ml"
	.space	5
	.byte	5
	.data
	.align	3
	.quad	3068
	.globl	_camlMeander$3
_camlMeander$3:
	.ascii  "c_to_ocaml"
	.space	5
	.byte	5
	.data
	.align	3
	.quad	3068
	.globl	_camlMeander$2
	.globl	_camlMeander$2
_camlMeander$2:
	.ascii  "Meander.E2"
	.space	5
	.byte	5
	.data
	.align	3
	.quad	3068
	.globl	_camlMeander$1
	.globl	_camlMeander$1
_camlMeander$1:
	.ascii  "Meander.E1"
	.space	5
	.byte	5
	.text
	.align	3
	.globl	_camlMeander$entry
L114:
	mov	x16, #34
	stp	x16, x30, [sp, #-16]!
	bl	_caml_call_realloc_stack
	ldp	x16, x30, [sp], #16
_camlMeander$entry:
	.cfi_startproc
	ldr	x16, [x28, #40]
	add	x16, x16, #328
	cmp	sp, x16
	bcc	L114
	sub	sp, sp, #16
	.cfi_adjust_cfa_offset	16
	.cfi_offset 30, -8
	str	x30, [sp, #8]
L113:
	orr	x0, xzr, #1
	.loc	1	3	0	; meander.ml
	str	x29, [sp, -16]!
	mov	x29, sp
	.cfi_remember_state
	.cfi_def_cfa_register 29
	ldr	x16, [x28, 64]
	mov	sp, x16
	bl	_caml_fresh_oo_id
	mov	sp, x29
	ldr	x29, [sp], 16
	.cfi_restore_state
	.loc	1	3	0	; meander.ml
	bl	_caml_alloc2
L115:	add	x1, x27, #8
	movz	x3, #2296, lsl #0
	str	x3, [x1, #-8]
	adrp	x4, _camlMeander$1@GOTPAGE
	ldr	x4, [x4, _camlMeander$1@GOTPAGEOFF]
	str	x4, [x1, #0]
	str	x0, [x1, #8]
	adrp	x0, _camlMeander@GOTPAGE
	ldr	x0, [x0, _camlMeander@GOTPAGEOFF]
	.loc	1	3	0	; meander.ml
	str	x29, [sp, -16]!
	mov	x29, sp
	.cfi_remember_state
	.cfi_def_cfa_register 29
	ldr	x16, [x28, 64]
	mov	sp, x16
	bl	_caml_initialize
	mov	sp, x29
	ldr	x29, [sp], 16
	.cfi_restore_state
	orr	x0, xzr, #1
	.loc	1	4	0	; meander.ml
	str	x29, [sp, -16]!
	mov	x29, sp
	.cfi_remember_state
	.cfi_def_cfa_register 29
	ldr	x16, [x28, 64]
	mov	sp, x16
	bl	_caml_fresh_oo_id
	mov	sp, x29
	ldr	x29, [sp], 16
	.cfi_restore_state
	.loc	1	4	0	; meander.ml
	bl	_caml_alloc2
L116:	add	x1, x27, #8
	movz	x9, #2296, lsl #0
	str	x9, [x1, #-8]
	adrp	x10, _camlMeander$2@GOTPAGE
	ldr	x10, [x10, _camlMeander$2@GOTPAGEOFF]
	str	x10, [x1, #0]
	str	x0, [x1, #8]
	adrp	x11, _camlMeander@GOTPAGE
	ldr	x11, [x11, _camlMeander@GOTPAGEOFF]
	.loc	1	4	0	; meander.ml
	add	x0, x11, #8
	.loc	1	4	0	; meander.ml
	str	x29, [sp, -16]!
	mov	x29, sp
	.cfi_remember_state
	.cfi_def_cfa_register 29
	ldr	x16, [x28, 64]
	mov	sp, x16
	bl	_caml_initialize
	mov	sp, x29
	ldr	x29, [sp], 16
	.cfi_restore_state
	adrp	x1, _camlMeander$7@GOTPAGE
	ldr	x1, [x1, _camlMeander$7@GOTPAGEOFF]
	adrp	x14, _camlMeander@GOTPAGE
	ldr	x14, [x14, _camlMeander@GOTPAGEOFF]
	add	x0, x14, #16
	str	x29, [sp, -16]!
	mov	x29, sp
	.cfi_remember_state
	.cfi_def_cfa_register 29
	ldr	x16, [x28, 64]
	mov	sp, x16
	bl	_caml_initialize
	mov	sp, x29
	ldr	x29, [sp], 16
	.cfi_restore_state
	adrp	x19, _camlMeander@GOTPAGE
	ldr	x19, [x19, _camlMeander@GOTPAGEOFF]
	ldr	x1, [x19, #16]
	adrp	x0, _camlMeander$3@GOTPAGE
	ldr	x0, [x0, _camlMeander$3@GOTPAGEOFF]
	.file	2 "/Users/tsmc/projects/ocaml" "callback.ml"
	.loc	2	22	2	; callback.ml
	adrp	x8, _caml_register_named_value@GOTPAGE
	ldr	x8, [x8, _caml_register_named_value@GOTPAGEOFF]
	bl	_caml_c_call
L117:
	adrp	x1, _camlMeander$6@GOTPAGE
	ldr	x1, [x1, _camlMeander$6@GOTPAGEOFF]
	adrp	x23, _camlMeander@GOTPAGE
	ldr	x23, [x23, _camlMeander@GOTPAGEOFF]
	add	x0, x23, #24
	str	x29, [sp, -16]!
	mov	x29, sp
	.cfi_remember_state
	.cfi_def_cfa_register 29
	ldr	x16, [x28, 64]
	mov	sp, x16
	bl	_caml_initialize
	mov	sp, x29
	ldr	x29, [sp], 16
	.cfi_restore_state
	orr	x0, xzr, #1
	.loc	1	13	16	; meander.ml
	bl	_camlMeander$omain_278
L118:
	cmp	x0, #85
	b.eq	L112
	.loc	1	13	8	; meander.ml
	bl	_caml_alloc2
L119:	add	x0, x27, #8
	orr	x2, xzr, #2048
	str	x2, [x0, #-8]
	adrp	x3, _caml_exn_Assert_failure@GOTPAGE
	ldr	x3, [x3, _caml_exn_Assert_failure@GOTPAGEOFF]
	str	x3, [x0, #0]
	adrp	x4, _camlMeander$5@GOTPAGE
	ldr	x4, [x4, _camlMeander$5@GOTPAGEOFF]
	str	x4, [x0, #8]
	.loc	1	13	8	; meander.ml
	bl	_caml_raise_exn
L120:
L112:
	orr	x0, xzr, #1
	ldr	x30, [sp, #8]
	add	sp, sp, #16
	.cfi_adjust_cfa_offset	-16
	ret
	.cfi_adjust_cfa_offset	16
	.cfi_endproc
	.data
	.align	3
	.quad	_ocaml_to_c
	.text
	.globl	_camlMeander$code_end
_camlMeander$code_end:
Lfunc_end0:
	.data
	.quad	0
	.globl	_camlMeander$data_end
_camlMeander$data_end:
	.quad	0
	.align	3
	.globl	_camlMeander$frametable
_camlMeander$frametable:
	.quad	10
	.quad	L120
	.short	17
	.short	0
	.align	2
	.long	L121 - . + 0x0
	.align	3
	.quad	L119
	.short	19
	.short	0
	.byte	1
	.byte	1
	.align	2
	.long	L122 - . + 0x0
	.align	3
	.quad	L118
	.short	17
	.short	0
	.align	2
	.long	L123 - . + 0x0
	.align	3
	.quad	L117
	.short	17
	.short	0
	.align	2
	.long	L124 - . + 0x0
	.align	3
	.quad	L116
	.short	19
	.short	1
	.short	1
	.byte	1
	.byte	1
	.align	2
	.long	L125 - . + 0x0
	.align	3
	.quad	L115
	.short	19
	.short	1
	.short	1
	.byte	1
	.byte	1
	.align	2
	.long	L126 - . + 0x0
	.align	3
	.quad	L111
	.short	16
	.short	0
	.align	3
	.quad	L110
	.short	32
	.short	0
	.align	3
	.quad	L109
	.short	49
	.short	0
	.align	2
	.long	L127 - . + 0x0
	.align	3
	.quad	L101
	.short	17
	.short	0
	.align	2
	.long	L128 - . + 0x0
	.align	3
	.align	2
L125:
	.long	L130 - . + 0x0
	.long	0x200060
	.align	2
L127:
	.long	L131 - . + 0x0
	.long	0x5044f0
	.align	2
L124:
	.long	L133 - . + 0x1
	.long	0xb00940
	.long	L130 - . + 0x68000000
	.long	0x312108
	.align	2
L123:
	.long	L130 - . + 0x0
	.long	0x6840c0
	.align	2
L121:
	.long	L130 - . + 0x2
	.long	0x6820f0
	.align	2
L122:
	.long	L130 - . + 0x0
	.long	0x6820f0
	.align	2
L126:
	.long	L130 - . + 0x0
	.long	0x180060
	.align	2
L128:
	.long	L134 - . + 0x2
	.long	0x2850e0
L129:
	.asciz	"meander.ml"
L132:
	.asciz	"callback.ml"
	.align	2
L134:
	.long	L129 - . + 0x0
	.asciz	"Meander.c_to_ocaml"
	.align	2
L131:
	.long	L129 - . + 0x0
	.asciz	"Meander.omain"
	.align	2
L130:
	.long	L129 - . + 0x0
	.asciz	"Meander"
	.align	2
L133:
	.long	L132 - . + 0x0
	.asciz	"Stdlib__Callback.register"
	.align	3

	.section	__DWARF,__debug_abbrev,regular,debug
Lsection_abbrev:
	.byte	1                               ; Abbreviation Code
	.byte	17                              ; DW_TAG_compile_unit
	.byte	1                               ; DW_CHILDREN_yes
	.byte	37                              ; DW_AT_producer
	.byte	14                              ; DW_FORM_strp
	.byte	21                              ; DW_AT_language
	.byte	5                               ; DW_FORM_data2
	.byte	3                               ; DW_AT_name
	.byte	14                              ; DW_FORM_strp
	.ascii	"\202|"                         ; DW_AT_LLVM_sysroot
	.byte	14                              ; DW_FORM_strp
	.ascii	"\357\177"                      ; DW_AT_APPLE_sdk
	.byte	14                              ; DW_FORM_strp
	.byte	16                              ; DW_AT_stmt_list
	.byte	23                              ; DW_FORM_sec_offset
	.byte	27                              ; DW_AT_comp_dir
	.byte	14                              ; DW_FORM_strp
	.byte	17                              ; DW_AT_low_pc
	.byte	1                               ; DW_FORM_addr
	.byte	18                              ; DW_AT_high_pc
	.byte	6                               ; DW_FORM_data4
	.byte	0                               ; EOM(1)
	.byte	0                               ; EOM(2)
	.byte	2                               ; Abbreviation Code
	.byte	52                              ; DW_TAG_variable
	.byte	0                               ; DW_CHILDREN_no
	.byte	73                              ; DW_AT_type
	.byte	19                              ; DW_FORM_ref4
	.byte	58                              ; DW_AT_decl_file
	.byte	11                              ; DW_FORM_data1
	.byte	59                              ; DW_AT_decl_line
	.byte	11                              ; DW_FORM_data1
	.byte	2                               ; DW_AT_location
	.byte	24                              ; DW_FORM_exprloc
	.byte	0                               ; EOM(1)
	.byte	0                               ; EOM(2)
	.byte	3                               ; Abbreviation Code
	.byte	1                               ; DW_TAG_array_type
	.byte	1                               ; DW_CHILDREN_yes
	.byte	73                              ; DW_AT_type
	.byte	19                              ; DW_FORM_ref4
	.byte	0                               ; EOM(1)
	.byte	0                               ; EOM(2)
	.byte	4                               ; Abbreviation Code
	.byte	33                              ; DW_TAG_subrange_type
	.byte	0                               ; DW_CHILDREN_no
	.byte	73                              ; DW_AT_type
	.byte	19                              ; DW_FORM_ref4
	.byte	55                              ; DW_AT_count
	.byte	11                              ; DW_FORM_data1
	.byte	0                               ; EOM(1)
	.byte	0                               ; EOM(2)
	.byte	5                               ; Abbreviation Code
	.byte	36                              ; DW_TAG_base_type
	.byte	0                               ; DW_CHILDREN_no
	.byte	3                               ; DW_AT_name
	.byte	14                              ; DW_FORM_strp
	.byte	62                              ; DW_AT_encoding
	.byte	11                              ; DW_FORM_data1
	.byte	11                              ; DW_AT_byte_size
	.byte	11                              ; DW_FORM_data1
	.byte	0                               ; EOM(1)
	.byte	0                               ; EOM(2)
	.byte	6                               ; Abbreviation Code
	.byte	36                              ; DW_TAG_base_type
	.byte	0                               ; DW_CHILDREN_no
	.byte	3                               ; DW_AT_name
	.byte	14                              ; DW_FORM_strp
	.byte	11                              ; DW_AT_byte_size
	.byte	11                              ; DW_FORM_data1
	.byte	62                              ; DW_AT_encoding
	.byte	11                              ; DW_FORM_data1
	.byte	0                               ; EOM(1)
	.byte	0                               ; EOM(2)
	.byte	7                               ; Abbreviation Code
	.byte	46                              ; DW_TAG_subprogram
	.byte	0                               ; DW_CHILDREN_no
	.byte	17                              ; DW_AT_low_pc
	.byte	1                               ; DW_FORM_addr
	.byte	18                              ; DW_AT_high_pc
	.byte	6                               ; DW_FORM_data4
	.byte	64                              ; DW_AT_frame_base
	.byte	24                              ; DW_FORM_exprloc
	.byte	3                               ; DW_AT_name
	.byte	14                              ; DW_FORM_strp
	.byte	58                              ; DW_AT_decl_file
	.byte	11                              ; DW_FORM_data1
	.byte	59                              ; DW_AT_decl_line
	.byte	11                              ; DW_FORM_data1
	.byte	39                              ; DW_AT_prototyped
	.byte	25                              ; DW_FORM_flag_present
	.byte	73                              ; DW_AT_type
	.byte	19                              ; DW_FORM_ref4
	.byte	63                              ; DW_AT_external
	.byte	25                              ; DW_FORM_flag_present
	.byte	0                               ; EOM(1)
	.byte	0                               ; EOM(2)
	.byte	0                               ; EOM(3)
	.section	__DWARF,__debug_info,regular,debug
Lsection_info:
Lcu_begin0:
.set Lset0, Ldebug_info_end0-Ldebug_info_start0 ; Length of Unit
	.long	Lset0
Ldebug_info_start0:
	.short	4                               ; DWARF version number
.set Lset1, Lsection_abbrev-Lsection_abbrev ; Offset Into Abbrev. Section
	.long	Lset1
	.byte	8                               ; Address Size (in bytes)
	.byte	1                               ; Abbrev [1] 0xb:0x73 DW_TAG_compile_unit
	.long	0                               ; DW_AT_producer
	.short	12                              ; DW_AT_language
	.long	46                              ; DW_AT_name
	.long	57                              ; DW_AT_LLVM_sysroot
	.long	152                             ; DW_AT_APPLE_sdk
.set Lset2, Lline_table_start0-Lsection_line ; DW_AT_stmt_list
	.long	Lset2
	.long	163                             ; DW_AT_comp_dir
	.quad	Lfunc_begin0                    ; DW_AT_low_pc
.set Lset3, Lfunc_end0-Lfunc_begin0     ; DW_AT_high_pc
	.long	Lset3
	.byte	2                               ; Abbrev [2] 0x32:0x11 DW_TAG_variable
	.long	67                              ; DW_AT_type
	.byte	1                               ; DW_AT_decl_file
	.byte	4                               ; DW_AT_decl_line
	.byte	9                               ; DW_AT_location
	.byte	3
	.quad	l_.str
	.byte	3                               ; Abbrev [3] 0x43:0xc DW_TAG_array_type
	.long	79                              ; DW_AT_type
	.byte	4                               ; Abbrev [4] 0x48:0x6 DW_TAG_subrange_type
	.long	86                              ; DW_AT_type
	.byte	14                              ; DW_AT_count
	.byte	0                               ; End Of Children Mark
	.byte	5                               ; Abbrev [5] 0x4f:0x7 DW_TAG_base_type
	.long	190                             ; DW_AT_name
	.byte	6                               ; DW_AT_encoding
	.byte	1                               ; DW_AT_byte_size
	.byte	6                               ; Abbrev [6] 0x56:0x7 DW_TAG_base_type
	.long	195                             ; DW_AT_name
	.byte	8                               ; DW_AT_byte_size
	.byte	7                               ; DW_AT_encoding
	.byte	7                               ; Abbrev [7] 0x5d:0x19 DW_TAG_subprogram
	.quad	Lfunc_begin0                    ; DW_AT_low_pc
.set Lset4, Lfunc_end0-Lfunc_begin0     ; DW_AT_high_pc
	.long	Lset4
	.byte	1                               ; DW_AT_frame_base
	.byte	109
	.long	216                             ; DW_AT_name
	.byte	1                               ; DW_AT_decl_file
	.byte	3                               ; DW_AT_decl_line
                                        ; DW_AT_prototyped
	.long	118                             ; DW_AT_type
                                        ; DW_AT_external
	.byte	5                               ; Abbrev [5] 0x76:0x7 DW_TAG_base_type
	.long	221                             ; DW_AT_name
	.byte	5                               ; DW_AT_encoding
	.byte	4                               ; DW_AT_byte_size
	.byte	0                               ; End Of Children Mark
Ldebug_info_end0:
	.section	__DWARF,__debug_str,regular,debug
Linfo_string:
	.asciz	"Apple clang version 15.0.0 (clang-1500.3.9.4)" ; string offset=0
	.asciz	"meander.ml"                    ; string offset=46
	.asciz	"/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk" ; string offset=57
	.asciz	"MacOSX.sdk"                    ; string offset=152
	.asciz	"/Users/tsmc/projects/ocaml"    ; string offset=163
	.asciz	"char"                          ; string offset=190
	.asciz	"__ARRAY_SIZE_TYPE__"           ; string offset=195
	.byte	0                               ; string offset=215
	.asciz	"mane"                          ; string offset=216
	.asciz	"int"                           ; string offset=221
	.section	__DWARF,__apple_names,regular,debug
Lnames_begin:
	.long	1212240712                      ; Header Magic
	.short	1                               ; Header Version
	.short	0                               ; Header Hash Function
	.long	2                               ; Header Bucket Count
	.long	2                               ; Header Hash Count
	.long	12                              ; Header Data Length
	.long	0                               ; HeaderData Die Offset Base
	.long	1                               ; HeaderData Atom Count
	.short	1                               ; DW_ATOM_die_offset
	.short	6                               ; DW_FORM_data4
	.long	0                               ; Bucket 0
	.long	1                               ; Bucket 1
	.long	2090499946                      ; Hash in Bucket 0
	.long	5381                            ; Hash in Bucket 1
.set Lset5, LNames0-Lnames_begin        ; Offset in Bucket 0
	.long	Lset5
.set Lset6, LNames1-Lnames_begin        ; Offset in Bucket 1
	.long	Lset6
LNames0:
	.long	216                             ; main
	.long	1                               ; Num DIEs
	.long	93
	.long	0
LNames1:
	.long	215                             ; 
	.long	1                               ; Num DIEs
	.long	50
	.long	0
	.section	__DWARF,__apple_objc,regular,debug
Lobjc_begin:
	.long	1212240712                      ; Header Magic
	.short	1                               ; Header Version
	.short	0                               ; Header Hash Function
	.long	1                               ; Header Bucket Count
	.long	0                               ; Header Hash Count
	.long	12                              ; Header Data Length
	.long	0                               ; HeaderData Die Offset Base
	.long	1                               ; HeaderData Atom Count
	.short	1                               ; DW_ATOM_die_offset
	.short	6                               ; DW_FORM_data4
	.long	-1                              ; Bucket 0
	.section	__DWARF,__apple_namespac,regular,debug
Lnamespac_begin:
	.long	1212240712                      ; Header Magic
	.short	1                               ; Header Version
	.short	0                               ; Header Hash Function
	.long	1                               ; Header Bucket Count
	.long	0                               ; Header Hash Count
	.long	12                              ; Header Data Length
	.long	0                               ; HeaderData Die Offset Base
	.long	1                               ; HeaderData Atom Count
	.short	1                               ; DW_ATOM_die_offset
	.short	6                               ; DW_FORM_data4
	.long	-1                              ; Bucket 0
	.section	__DWARF,__apple_types,regular,debug
Ltypes_begin:
	.long	1212240712                      ; Header Magic
	.short	1                               ; Header Version
	.short	0                               ; Header Hash Function
	.long	3                               ; Header Bucket Count
	.long	3                               ; Header Hash Count
	.long	20                              ; Header Data Length
	.long	0                               ; HeaderData Die Offset Base
	.long	3                               ; HeaderData Atom Count
	.short	1                               ; DW_ATOM_die_offset
	.short	6                               ; DW_FORM_data4
	.short	3                               ; DW_ATOM_die_tag
	.short	5                               ; DW_FORM_data2
	.short	4                               ; DW_ATOM_type_flags
	.short	11                              ; DW_FORM_data1
	.long	-1                              ; Bucket 0
	.long	-1                              ; Bucket 1
	.long	0                               ; Bucket 2
	.long	193495088                       ; Hash in Bucket 2
	.long	2090147939                      ; Hash in Bucket 2
	.long	-594775205                      ; Hash in Bucket 2
.set Lset7, Ltypes0-Ltypes_begin        ; Offset in Bucket 2
	.long	Lset7
.set Lset8, Ltypes1-Ltypes_begin        ; Offset in Bucket 2
	.long	Lset8
.set Lset9, Ltypes2-Ltypes_begin        ; Offset in Bucket 2
	.long	Lset9
Ltypes0:
	.long	221                             ; int
	.long	1                               ; Num DIEs
	.long	118
	.short	36
	.byte	0
	.long	0
Ltypes1:
	.long	190                             ; char
	.long	1                               ; Num DIEs
	.long	79
	.short	36
	.byte	0
	.long	0
Ltypes2:
	.long	195                             ; __ARRAY_SIZE_TYPE__
	.long	1                               ; Num DIEs
	.long	86
	.short	36
	.byte	0
	.long	0
.subsections_via_symbols
	.section	__DWARF,__debug_line,regular,debug
Lsection_line:
Lline_table_start0:
