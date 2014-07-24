/********************************************************************************/
/*	Bcrypt_stub.c
	Copyright (c) 2012 Dario Teixeira (dario.teixeira@yahoo.com)
*/
/********************************************************************************/

#include <stdlib.h>
#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/alloc.h>
#include <caml/fail.h>
#include <caml/callback.h>
#include "crypt_blowfish.h"


/********************************************************************************/
/* Stub definitions.								*/
/********************************************************************************/

CAMLprim value bcrypt_gensalt_stub (value v_input, value v_count)
	{
	CAMLparam2 (v_input, v_count);
	CAMLlocal1 (v_output);
	char prefix [3] = {'$', '2', 'y'};
	char output [30];

	char *input = String_val (v_input);
	unsigned long count = Unsigned_long_val (v_count);

	char *result = _crypt_gensalt_blowfish_rn (prefix, count, input, caml_string_length (v_input), output, sizeof (output));

	if (result == NULL)
		{
		caml_raise_constant (*caml_named_value ("gensalt_error"));
		}

	output [sizeof (output) - 1] = 0;
	v_output = caml_copy_string (output);

	CAMLreturn (v_output);
	}


CAMLprim value bcrypt_stub (value v_key, value v_salt)
	{
	CAMLparam2 (v_key, v_salt);
	CAMLlocal1 (v_output);
	char output [61] = {0};		// Must be initialised to 0.

	char *key = String_val (v_key);
	char *salt = String_val (v_salt);

	char *result = _crypt_blowfish_rn (key, salt, output, sizeof (output));

	if (result == NULL)
		{
		caml_raise_constant (*caml_named_value ("bcrypt_error"));
		}

	output [sizeof (output) - 1] = 0;
	v_output = caml_copy_string (output);

	CAMLreturn (v_output);
	}

