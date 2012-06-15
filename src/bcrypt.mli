(********************************************************************************)
(*	Bcrypt.mli
	Copyright (c) 2012 Dario Teixeira (dario.teixeira@yahoo.com)
*)
(********************************************************************************)

(**	Module for safe salting and hashing of passwords using the Bcrypt algorithm.
*)


(********************************************************************************)
(**	{1 Exceptions}								*)
(********************************************************************************)

(**	An exception occurred obtaining random seed from [/dev/urandom].
*)
exception Urandom_error of exn

(**	An exception occurred in backend's [_crypt_gensalt_blowfish_rn] function.
*)
exception Gensalt_error

(**	An exception ocurred in backend's [_crypt_blowfish_rn] function.
*)
exception Bcrypt_error


(********************************************************************************)
(**	{1 Type definitions}							*)
(********************************************************************************)

(**	Abstract type holding the salt for a password.  Use function {!gensalt}
	to generate a new salt.
*)
type salt_t

(**	Abstract type holding a password in salted and hashed form. Use function
	{!hash} to generate a hash.
*)
type hash_t


(********************************************************************************)
(**	{1 Public functions and values}						*)
(********************************************************************************)

(**	Create a new salt using [count] as the log{_2} of the number of Blowfish
	iterations to use (the default is 7, and currently any value between 4
	and 31 is accepted).  If provided, the [seed] parameter must be a string
	of at least 16 bytes; if not provided, then 16 random bytes will be used,
	obtained from [/dev/urandom].
*)
val gensalt: ?count:int -> ?seed:string -> unit -> salt_t

(**	Hash the given password with the given salt.
*)
val hash: string -> salt_t -> hash_t

(**	Verifies if the given password matches the previously hashed password.
*)
val verify: string -> hash_t -> bool

(**	Convert [string] to {!hash_t}
*)
external hash_of_string: string -> hash_t = "%identity"

(**	Convert {!hash_t} to [string]
*)
external string_of_hash: hash_t -> string = "%identity"

