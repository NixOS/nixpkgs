{stdenv, fetchurl, ocaml, findlib, ocaml_data_notation, ocaml_typeconv, camlp4,
 ocamlmod, ocamlify, ounit, expect}:

stdenv.mkDerivation {
  name = "ocaml-oasis-0.4.4";

  src = fetchurl {
    url = http://forge.ocamlcore.org/frs/download.php/1355/oasis-0.4.4.tar.bz2;
    sha256 = "1lsnw9f1jh6106kphxg40qp0sia6cbkbb9ahs5y6ifnfkmllkjhj";
  };

  createFindlibDestdir = true;

  buildInputs =
    [
      ocaml findlib ocaml_typeconv ocamlmod ocamlify ounit camlp4
    ];

  propagatedBuildInputs = [ ocaml_data_notation ];

  configurePhase = "ocaml setup.ml -configure --prefix $out";
  buildPhase     = "ocaml setup.ml -build";
  installPhase   = "ocaml setup.ml -install";

  meta = with stdenv.lib; {
    homepage = http://oasis.forge.ocamlcore.org/;
    description = "Configure, build and install system for OCaml projects";
    license = licenses.lgpl21;
    platforms = ocaml.meta.platforms;
    maintainers = with maintainers; [
      vbgl z77z
    ];
  };
}
