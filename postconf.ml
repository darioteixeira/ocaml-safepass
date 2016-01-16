#load "unix.cma";;
#load "str.cma";;

let re_xen_flags = Str.regexp "^CFLAGS="

let check_status cmd =
  let proc = Unix.open_process_out cmd in
  let status = Unix.close_process_out proc in
  assert (status = Unix.WEXITED 0)

let check_output cmd =
  let from_cmd = Unix.open_process_in cmd in
  let output = input_line from_cmd in
  let status = Unix.close_process_in from_cmd in
  assert (status = Unix.WEXITED 0);
  output

let () =
  let ch = open_in "setup.data" in
  let b = Buffer.create 4000 in
  let xen = ref false in
  try
    while true do
      let line = input_line ch in
      if line = "xen=\"true\"" then xen := true;
      if not (Str.string_match re_xen_flags line 0) then (
        Buffer.add_string b line;
        Buffer.add_char b '\n'
      )
    done
  with End_of_file ->
  close_in ch;

  let pkgconfig_output cmd =
    try check_output cmd
    with _ -> check_output ("env PKG_CONFIG_PATH=`opam config var prefix`/lib/pkgconfig " ^ cmd) in

  let xen_cflags, xen_ldflags =
    if !xen then
      let libc = (Unix.getcwd ()) ^ "/xen-libc" in
      let () = check_status ("gcc -shared -o " ^ libc ^ "/libc.so " ^ libc ^ "/libc.c") in
      (pkgconfig_output "pkg-config --static --cflags mirage-xen-ocaml", "-L" ^ libc)
    else ("", "") in

  Buffer.add_string b (Printf.sprintf "CFLAGS=%S\nLDFLAGS=%S\n" xen_cflags xen_ldflags);
  let ch = open_out "setup.data" in
  Buffer.output_buffer ch b;
  close_out ch


