(********************************************************************************)
(*	Bcrypt.ml
	Copyright (c) 2012 Dario Teixeira (dario.teixeira@yahoo.com)
*)
(********************************************************************************)


(********************************************************************************)
(**	{1 Exceptions}								*)
(********************************************************************************)

exception Urandom_error of exn
exception Gensalt_error
exception Bcrypt_error


(********************************************************************************)
(**	{1 Type definitions}							*)
(********************************************************************************)

type salt_t = string
type hash_t = string


(********************************************************************************)
(**	{1 Private functions and values}					*)
(********************************************************************************)

external bcrypt_gensalt: string -> int -> string = "bcrypt_gensalt_stub"
external bcrypt: string -> string -> string = "bcrypt_stub"


let () =
	Callback.register_exception "gensalt_error" Gensalt_error;
	Callback.register_exception "bcrypt_error" Bcrypt_error


(********************************************************************************)
(**	{1 Public functions and values}						*)
(********************************************************************************)

let gensalt ?(count = 7) ?seed () =
	let make_seed () =
		try
			let rng = open_in_bin "/dev/urandom" in
			let len = 16 in
			let buf = String.create len in
			let _ = really_input rng buf 0 len in
			close_in rng;
			buf
		with
			exc -> raise (Urandom_error exc) in
	let seed = match seed with
		| Some s -> s
		| None	 -> make_seed ()
	in bcrypt_gensalt seed count

let hash passwd salt =
	bcrypt passwd salt

let verify passwd hash =
	bcrypt passwd hash = hash

external hash_of_string: string -> hash_t = "%identity"

external string_of_hash: hash_t -> string = "%identity"

