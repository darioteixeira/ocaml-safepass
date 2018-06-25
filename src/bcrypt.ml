(********************************************************************************)
(*  Bcrypt.ml
    Copyright (c) 2012-2016 Dario Teixeira <dario.teixeira@nleyten.com>
*)
(********************************************************************************)


(********************************************************************************)
(** {1 Exceptions}                                                              *)
(********************************************************************************)

exception Invalid_count of int
exception Invalid_seed of string
exception Urandom_error of exn
exception Gensalt_error
exception Bcrypt_error


(********************************************************************************)
(** {1 Type definitions}                                                        *)
(********************************************************************************)

type hash = string

type variant =
  | A
  | Y
  | B


(********************************************************************************)
(** {1 Private functions and values}                                            *)
(********************************************************************************)

external bcrypt_gensalt: char -> string -> int -> string = "bcrypt_gensalt_stub"
external bcrypt: string -> string -> string = "bcrypt_stub"

let () =
    Callback.register_exception "gensalt_error" Gensalt_error;
    Callback.register_exception "bcrypt_error" Bcrypt_error

let char_of_variant = function
    | A -> 'a'
    | Y -> 'y'
    | B -> 'b'

let read_seed () =
    let rec really_read ?(already_read=0) fd to_read buff =
        let read_this_time = Unix.read fd buff already_read (to_read - already_read) in
        let already_read = already_read + read_this_time in
        match already_read >= to_read with
            | true -> ()
            | false -> really_read ~already_read fd to_read buff
    in
    let fd = Unix.openfile "/dev/urandom" [Unix.O_RDONLY] 0o400 in
    let len = 16 in
    let buff = Bytes.create len in
    really_read fd len buff;
    Unix.close fd;
    Bytes.unsafe_to_string buff


(********************************************************************************)
(** {1 Public functions and values}                                             *)
(********************************************************************************)

let hash ?(count = 6) ?(variant=Y) ?seed passwd =
    if count < 4 || count > 31
    then raise (Invalid_count count)
    else begin
        let seed = match seed with
            | Some s when String.length s >= 16 -> s
            | Some s -> raise (Invalid_seed s)
            | None -> try read_seed () with exc -> raise (Urandom_error exc)
        in
        let salt = bcrypt_gensalt seed count in
        bcrypt passwd salt
    end

let verify passwd hash =
    bcrypt passwd hash = hash

let hash_of_string x = x

let string_of_hash x = x

