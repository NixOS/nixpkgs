{stdenv, fetchurl, ocaml, findlib, ocaml_data_notation, ocaml_typeconv,
 ocamlmod, ocamlify, ounit, expect}:

stdenv.mkDerivation {
  name = "ocaml-oasis-0.4.1";

  src = fetchurl {
    url = http://forge.ocamlcore.org/frs/download.php/1355/oasis-0.4.1.tar.gz;
    sha256 = "1lsnw9f1jh6106kphxg40qp0sia6cbkbb9ahs5y6ifnfkmllkjhj";
  };

  createFindlibDestdir = true;

  buildInputs =
    [
      ocaml findlib ocaml_data_notation ocaml_typeconv ocamlmod ocamlify ounit
    ];

  configurePhase = "ocaml setup.ml -configure --prefix $out";
  buildPhase     = "ocaml setup.ml -build";
  installPhase   = "ocaml setup.ml -install";

  meta = {
    homepage = http://oasis.forge.ocamlcore.org/;
    description = "Configure, build and install system for OCaml projects";
    license = stdenv.lib.licenses.lgpl21;
    platforms = ocaml.meta.platforms;
    maintainers = with stdenv.lib.maintainers; [
      z77z
    ];
  };
}
