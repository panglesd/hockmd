(lang dune 2.0)

(name hockmd)

(documentation "https://panglesd.github.io/hockmd/")

(source
 (github panglesd/hockmd))

(license MIT)

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
  (dune
   (>= 2.0))
  cohttp
  cohttp-lwt-unix
  (lwt
   (>= 5.3.0))
  ppx_deriving
  yojson
  ppx_yojson_conv
  (alcotest :with-test)
  (odoc :with-doc)))
