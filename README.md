[OCaml-safepass][]

[![Build Status](https://travis-ci.org/darioteixeira/ocaml-safepass.svg?branch=master)](https://travis-ci.org/darioteixeira/ocaml-safepass)

[Dario Teixeira][dario]

Overview
========

OCaml-safepass is a library offering facilities for the safe storage of
user passwords.  By "safe" we mean that passwords are salted and hashed
using the [Bcrypt][] algorithm.  Salting prevents [rainbow-table based
attacks][RT], whereas hashing by a very time-consuming algorithm such as
Bcrypt renders brute-force password cracking impractical.

OCaml-safepass's obvious usage domain are web applications, though it does not
depend on any particular framework.  Internally, OCaml-safepass binds to the C
routines from Openwall's [Crypt_blowfish][crypt].  However, it would be
incorrect to describe OCaml-safepass as an OCaml binding to Crypt_blowfish,
because the API it exposes is higher-level and more compact than that offered
by Crypt_blowfish.  Moreover, OCaml-safepass's API takes advantage of OCaml's
type-system to make usage mistakes nearly impossible.


Dependencies
============

OCaml-safepass has no external dependencies.  Note that it bundles
the Public Domain licensed 'crypt_blowfish.h' and 'crypt_blowfish.c'
C modules from Openwall's Crypt_blowfish.


Building and installing
=======================

OCaml-safepass uses jbuilder.  Building and installing follows the costumary
`make` call sequence.  To generate the ocamldoc API documentation, use `make doc`.


License
=======

OCaml-safepass is distributed under the terms of the GNU LGPL version 2.1 with
the usual OCaml linking exception.  See LICENSE file for full license text.


References
==========

[dario]: mailto:dario.teixeira@nleyten.com
[ocaml-safepass]: http://ocaml-safepass.forge.ocamlcore.org/
[Bcrypt]: http://en.wikipedia.org/wiki/Bcrypt
[RT]: http://en.wikipedia.org/wiki/Rainbow_table
[crypt]: http://www.openwall.com/crypt/
