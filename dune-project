(lang dune 2.0)

(name hackmd-api)

(documentation "https://panglesd.github.io/hackmd-api/")

(source
 (github panglesd/hackmd-api))

(license ISC)

(authors
  "Paul-Elliot Anglès d'Auriac <peada@free.fr>")

(maintainers
  "Paul-Elliot Anglès d'Auriac <peada@free.fr>")

(generate_opam_files true)

(package
 (name hackmd-api)
 (synopsis "A wrapper around hackmd api")
 (description "A wrapper around hackmd api")
 (depends
  (ocaml (>= 4.08.0))
  dune
  cohttp
  cohttp-lwt-unix
  lwt
  (alcotest :with-test)
  (odoc :with-doc)))
