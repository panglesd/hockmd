(lang dune 2.0)

(name hockmd)

(documentation "https://panglesd.github.io/hockmd-api/")

(source
 (github panglesd/hockmd))

(license ISC)

(authors "Paul-Elliot Anglès d'Auriac <peada@free.fr>")

(maintainers "Paul-Elliot Anglès d'Auriac <peada@free.fr>")

(generate_opam_files true)

(package
 (name hockmd)
 (synopsis "A library to access hackmd's api")
 (description "A library to access hackmd's api")
 (depends
  (ocaml
   (>= 4.08.0))
  dune
  cohttp
  cohttp-lwt-unix
  lwt
  ppx_deriving
  yojson
  ppx_yojson_conv
  (alcotest :with-test)
  (odoc :with-doc)))
