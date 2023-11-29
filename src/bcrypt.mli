(** Module for safe salting and hashing of passwords using the Bcrypt algorithm.
*)


(********************************************************************************)
(** {1 Exceptions}                                                              *)
(********************************************************************************)

(** The provided [count] is invalid.  The [count] must be an integer between
    4 and 31, inclusive.
*)
exception Invalid_count of int

(** The given string [seed] cannot be used as seed.  Please provide a string
    at least 16 bytes long.
*)
exception Invalid_seed of string

(** An exception occurred obtaining random seed from [/dev/urandom].
*)
exception Urandom_error of exn

(** An exception occurred in backend's [_crypt_gensalt_blowfish_rn] function.
*)
exception Gensalt_error

(** An exception ocurred in backend's [_crypt_blowfish_rn] function.
*)
exception Bcrypt_error


(********************************************************************************)
(** {1 Type definitions}                                                        *)
(********************************************************************************)

(** Abstract type holding a password in salted and hashed form. Use function
    {!hash} to generate a hash.
*)
type hash

(** Supported variants of the Bcrypt algorithm.
*)
type variant = A | Y | B


(********************************************************************************)
(** {1 Public functions and values}                                             *)
(********************************************************************************)

(** Call [hash ?count ?variant ?seed password] to hash the given password string.
    The password is automatically salted before hashing.  If [seed] is not given,
    the salting procedure automatically fetches a seed from [/dev/urandom].
    If given, [seed] must be a string at least 16 bytes long.  The [count]
    parameter is the log{_2} number of Blowfish iterations to use in the
    hashing procedure.  Its default value is 6, and any integer between 4
    and 31 (inclusive) may be used.  Finally, [variant] picks which of the
    Bcrypt variants to use (defaults to [Y]).
*)
val hash: ?count:int -> ?variant:variant -> ?seed:string -> string -> hash

(** Call [verify password hash] to verify if the given password matches the
    previously hashed password.
*)
val verify: string -> hash -> bool

(** Convert [string] to {!hash}
*)
val hash_of_string: string -> hash

(** Convert {!hash} to [string]
*)
val string_of_hash: hash -> string

