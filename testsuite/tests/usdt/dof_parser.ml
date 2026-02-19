(* Standalone DOF (DTrace Object Format) parser.
   Extracts USDT probe names from Mach-O or ELF binaries.
 *)

let read_file path =
  let ic = open_in_bin path in
  let n = in_channel_length ic in
  let buf = Bytes.create n in
  really_input ic buf 0 n;
  close_in ic;
  buf

(* Little-endian binary readers *)

let u8 buf off = Char.code (Bytes.get buf off)

let u16 buf off =
  u8 buf off
  lor (u8 buf (off + 1) lsl 8)

let u32 buf off =
  u8 buf off
  lor (u8 buf (off + 1) lsl 8)
  lor (u8 buf (off + 2) lsl 16)
  lor (u8 buf (off + 3) lsl 24)

(* Big-endian u32 for fat Mach-O headers *)
let u32be buf off =
  (u8 buf off lsl 24)
  lor (u8 buf (off + 1) lsl 16)
  lor (u8 buf (off + 2) lsl 8)
  lor (u8 buf (off + 3))

let u64 buf off =
  u32 buf off lor (u32 buf (off + 4) lsl 32)

(* Null-terminated string *)
let cstring buf off =
  let len = Bytes.length buf in
  let rec find_nul i =
    if i >= len || Bytes.get buf i = '\000'
    then i
    else find_nul (i + 1)
  in
  Bytes.sub_string buf off (find_nul off - off)

(* Fixed-length string, trimmed at first null *)
let fixstr buf off n =
  let s = Bytes.sub_string buf off n in
  match String.index_opt s '\000' with
  | Some i -> String.sub s 0 i
  | None -> s

(* DTrace encodes hyphens as double underscores *)
let convert_name s =
  let b = Buffer.create (String.length s) in
  let len = String.length s in
  let rec loop i =
    if i >= len then ()
    else if i + 1 < len
            && s.[i] = '_' && s.[i + 1] = '_'
    then (Buffer.add_char b '-'; loop (i + 2))
    else (Buffer.add_char b s.[i]; loop (i + 1))
  in
  loop 0;
  Buffer.contents b

type dof_loc = { off : int; sz : int }

(* --- Mach-O parsing --- *)

let find_dof_macho buf base =
  let magic = u32 buf base in
  let is_64 = magic = 0xFEEDFACF in
  let ncmds = u32 buf (base + 16) in
  let hdr_sz = if is_64 then 32 else 28 in
  let acc = ref [] in
  let pos = ref (base + hdr_sz) in
  for _ = 0 to ncmds - 1 do
    let cmd = u32 buf !pos in
    let cmdsize = u32 buf (!pos + 4) in
    (* LC_SEGMENT=0x01, LC_SEGMENT_64=0x19 *)
    if cmd = 0x19 || cmd = 0x01 then begin
      let nsects_off = if is_64 then 64 else 48 in
      let nsects = u32 buf (!pos + nsects_off) in
      let seg_hdr = if is_64 then 72 else 56 in
      let sec_sz = if is_64 then 80 else 68 in
      for j = 0 to nsects - 1 do
        let s = !pos + seg_hdr + j * sec_sz in
        let name = fixstr buf s 16 in
        if String.length name >= 5
           && String.sub name 0 5 = "__dof"
        then begin
          let size, foff =
            if is_64 then
              u64 buf (s + 40), u32 buf (s + 48)
            else
              u32 buf (s + 36), u32 buf (s + 40)
          in
          acc := { off = foff; sz = size } :: !acc
        end
      done
    end;
    pos := !pos + cmdsize
  done;
  List.rev !acc

(* Fat (universal) binary: use first architecture *)
let find_dof_fat buf =
  let narch = u32be buf 4 in
  if narch = 0 then []
  else
    (* fat_arch[0].offset is at file offset 16 *)
    let arch_off = u32be buf 16 in
    find_dof_macho buf arch_off

(* --- ELF parsing --- *)

let find_dof_elf buf =
  if u8 buf 4 <> 2 then [] (* ELF64 only *)
  else
    let shoff = u64 buf 40 in
    let shentsz = u16 buf 58 in
    let shnum = u16 buf 60 in
    let shstrndx = u16 buf 62 in
    let str_sh = shoff + shstrndx * shentsz in
    let str_off = u64 buf (str_sh + 24) in
    let acc = ref [] in
    for i = 0 to shnum - 1 do
      let sh = shoff + i * shentsz in
      let nm = cstring buf (str_off + u32 buf sh) in
      if nm = ".SUNW_dof" then begin
        let o = u64 buf (sh + 24) in
        let s = u64 buf (sh + 32) in
        acc := { off = o; sz = s } :: !acc
      end
    done;
    List.rev !acc

(* --- DOF parsing --- *)

let parse_dof buf base size =
  if size < 64
     || u8 buf base <> 0x7F
     || u8 buf (base + 1) <> Char.code 'D'
     || u8 buf (base + 2) <> Char.code 'O'
     || u8 buf (base + 3) <> Char.code 'F'
  then []
  else
    let is_64 = u8 buf (base + 4) = 2 in
    let secsize = u32 buf (base + 24) in
    let secnum = u32 buf (base + 28) in
    let secoff =
      if is_64 then u64 buf (base + 32)
      else u32 buf (base + 32)
    in
    (* Parse DOF section table: type, entsize, off, sz *)
    let secs = Array.init secnum (fun i ->
      let p = base + secoff + i * secsize in
      let stype = u32 buf p in
      let entsz = u32 buf (p + 12) in
      let soff, ssz =
        if is_64 then
          u64 buf (p + 16), u64 buf (p + 24)
        else
          u32 buf (p + 16), u32 buf (p + 20)
      in
      (stype, entsz, soff, ssz)
    ) in
    let probes = ref [] in
    Array.iter (fun (stype, _, soff, _) ->
      if stype = 15 then begin (* PROVIDER *)
        let p = base + soff in
        let strtab_idx = u32 buf p in
        let probes_idx = u32 buf (p + 4) in
        let pname_off = u32 buf (p + 16) in
        if strtab_idx < Array.length secs
           && probes_idx < Array.length secs
        then begin
          let st_type, _, st_off, _ =
            secs.(strtab_idx)
          in
          let prov =
            if st_type = 8 (* STRTAB *) then
              convert_name
                (cstring buf
                   (base + st_off + pname_off))
            else "unknown"
          in
          let _, pr_entsz, pr_off, pr_sz =
            secs.(probes_idx)
          in
          if pr_entsz > 0 then begin
            let n = pr_sz / pr_entsz in
            for j = 0 to n - 1 do
              let po =
                base + pr_off + j * pr_entsz
              in
              (* name offset: after addr + func *)
              let nm_off =
                if is_64 then u32 buf (po + 12)
                else u32 buf (po + 8)
              in
              let nm =
                convert_name
                  (cstring buf
                     (base + st_off + nm_off))
              in
              probes :=
                (prov ^ ":" ^ nm) :: !probes
            done
          end
        end
      end
    ) secs;
    List.rev !probes

(* --- Main --- *)

let () =
  if Array.length Sys.argv < 2 then begin
    Printf.eprintf "Usage: %s <binary>\n"
      Sys.argv.(0);
    exit 1
  end;
  let path = Sys.argv.(1) in
  let buf = read_file path in
  if Bytes.length buf < 4 then begin
    Printf.eprintf "File too small\n";
    exit 1
  end;
  let m0 = u8 buf 0 in
  let m1 = u8 buf 1 in
  let m2 = u8 buf 2 in
  let m3 = u8 buf 3 in
  let dofs =
    (* Mach-O 64-bit LE: CF FA ED FE *)
    if m0 = 0xCF && m1 = 0xFA
       && m2 = 0xED && m3 = 0xFE
    then find_dof_macho buf 0
    (* Mach-O 32-bit LE: CE FA ED FE *)
    else if m0 = 0xCE && m1 = 0xFA
            && m2 = 0xED && m3 = 0xFE
    then find_dof_macho buf 0
    (* Fat binary: CA FE BA BE *)
    else if m0 = 0xCA && m1 = 0xFE
            && m2 = 0xBA && m3 = 0xBE
    then find_dof_fat buf
    (* ELF: 7F 45 4C 46 *)
    else if m0 = 0x7F && m1 = 0x45
            && m2 = 0x4C && m3 = 0x46
    then find_dof_elf buf
    else begin
      Printf.eprintf "Unknown binary format\n";
      exit 1
    end
  in
  let all = List.concat
    (List.map
       (fun l -> parse_dof buf l.off l.sz)
       dofs)
  in
  let sorted = List.sort_uniq String.compare all in
  List.iter print_endline sorted
